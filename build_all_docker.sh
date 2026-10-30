#!/bin/bash
# Build kernel + rootfs BÊN TRONG Docker (chạy trên Windows/macOS/Linux đều được)
# Chạy container với: --privileged (để mount loop + chroot/mknod)
set -e
WORKSPACE="/work"
cd "$WORKSPACE"
LOGFILE="build_all.log"

echo "=== Tai ma nguon ====" | tee -a "$LOGFILE"
if [ ! -d "linux-5.15.163" ]; then
    git clone --depth=1 --branch v5.15.163 https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git linux-5.15.163
fi

echo "=== Build Kernel ====" | tee -a "$LOGFILE"
cd linux-5.15.163
if [ ! -f ".config" ]; then
    make defconfig
    ./scripts/kconfig/merge_config.sh -m .config ../release.config
    make olddefconfig
fi
export LOCALVERSION=-edu
make -j"$(nproc)"
cd "$WORKSPACE"

echo "=== Tao Root Filesystem ====" | tee -a "$LOGFILE"
if [ ! -f "rootfs.img" ]; then
    qemu-img create -f raw rootfs.img 4G
    mkfs.ext4 -F rootfs.img
else
    echo "rootfs.img already exists, moving on..."
fi

mkdir -p /mnt/rootfs
umount /mnt/rootfs/dev 2>/dev/null || true
umount /mnt/rootfs/sys 2>/dev/null || true
umount /mnt/rootfs/proc 2>/dev/null || true
umount /mnt/rootfs 2>/dev/null || true

mount -o loop rootfs.img /mnt/rootfs

echo "=== Cai dat Ubuntu len rootfs (debootstrap) ====" | tee -a "$LOGFILE"
if [ ! -f /mnt/rootfs/bin/bash ]; then
    debootstrap --arch=amd64 noble /mnt/rootfs http://archive.ubuntu.com/ubuntu
else
    echo "rootfs already bootstrapped, skipping debootstrap..."
fi

echo "=== Mount Virtual FS ===" | tee -a "$LOGFILE"
cp /etc/resolv.conf /mnt/rootfs/etc/resolv.conf
mount --bind /dev /mnt/rootfs/dev
mount --bind /sys /mnt/rootfs/sys
mount --bind /proc /mnt/rootfs/proc

echo "=== Thiet lap ben trong (chroot) ====" | tee -a "$LOGFILE"
chroot /mnt/rootfs /bin/bash -c '
set -e
echo "uetsys" > /etc/hostname
cat > /etc/hosts <<EOF
127.0.0.1 localhost
127.0.1.1 uetsys
EOF

mkdir -p /etc/netplan
cat > /etc/netplan/01-net.yaml <<YAML
network:
  version: 2
  ethernets:
    default:
      match:
        name: "e*"
      dhcp4: true
YAML

mkdir -p /etc/systemd/system/getty.target.wants
ln -sf /lib/systemd/system/serial-getty@.service /etc/systemd/system/getty.target.wants/serial-getty@ttyS0.service

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server vim less curl ca-certificates net-tools iproute2 iputils-ping sudo

if ! id student >/dev/null 2>&1; then
  useradd -m -s /bin/bash student
fi
echo "student:student" | chpasswd
usermod -aG sudo student
systemctl enable ssh || true
apt-get clean
'

echo "=== Cleanup va Unmount ====" | tee -a "$LOGFILE"
umount /mnt/rootfs/dev
umount /mnt/rootfs/sys
umount /mnt/rootfs/proc
umount /mnt/rootfs

echo "=== HOAN TAT ===" | tee -a "$LOGFILE"
ls -lh bzImage 2>/dev/null || cp linux-5.15.163/arch/x86/boot/bzImage ./bzImage
ls -lh rootfs.img bzImage
