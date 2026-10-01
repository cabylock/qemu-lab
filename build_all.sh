#!/bin/bash
# Stop on error
set -e
WORKSPACE="/home/cabylock/Desktop/qemu-lab"
PASS="cabylock2612"

cd "$WORKSPACE"
LOGFILE="build_all.log"

echo "=== Tải mã nguồn ====" | tee -a "$LOGFILE"
if [ ! -d "linux-5.15.163" ]; then
    git clone --depth=1 --branch v5.15.163 https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git linux-5.15.163
fi

echo "=== Build Kernel ====" | tee -a "$LOGFILE"
cd linux-5.15.163

# Skip mrproper to resume build
if [ ! -f ".config" ]; then
    make defconfig
    ./scripts/kconfig/merge_config.sh -m .config ../release.config
    make olddefconfig
fi

export LOCALVERSION=-edu
make -j"$(nproc)"
cd "$WORKSPACE"

echo "=== Tạo Root Filesystem ====" | tee -a "$LOGFILE"
if [ ! -f "rootfs.img" ]; then
    qemu-img create -f raw rootfs.img 4G
    mkfs.ext4 -F rootfs.img
else
    echo "rootfs.img already exists, moving on..."
fi

echo "$PASS" | sudo -S mkdir -p /mnt/rootfs
# unmount in case it was already mounted
echo "$PASS" | sudo -S umount /mnt/rootfs/dev || true
echo "$PASS" | sudo -S umount /mnt/rootfs/sys || true
echo "$PASS" | sudo -S umount /mnt/rootfs/proc || true
echo "$PASS" | sudo -S umount /mnt/rootfs || true

echo "$PASS" | sudo -S mount -o loop rootfs.img /mnt/rootfs

echo "=== Cài đặt Ubuntu lên Root fileserver (debootstrap) ====" | tee -a "$LOGFILE"
echo "$PASS" | sudo -S debootstrap --arch=amd64 noble /mnt/rootfs http://archive.ubuntu.com/ubuntu

echo "=== Mount Virtual FS ===" | tee -a "$LOGFILE"
echo "$PASS" | sudo -S cp /etc/resolv.conf /mnt/rootfs/etc/resolv.conf
echo "$PASS" | sudo -S mount --bind /dev /mnt/rootfs/dev
echo "$PASS" | sudo -S mount --bind /sys /mnt/rootfs/sys
echo "$PASS" | sudo -S mount --bind /proc /mnt/rootfs/proc

echo "=== Thiết lập bên trong (chroot) ====" | tee -a "$LOGFILE"
echo "$PASS" | sudo -S chroot /mnt/rootfs /bin/bash -c '
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

useradd -m -s /bin/bash student
echo "student:student" | chpasswd
usermod -aG sudo student
systemctl enable ssh
apt-get clean
'

echo "=== Cleanup và Unmount ====" | tee -a "$LOGFILE"
echo "$PASS" | sudo -S umount /mnt/rootfs/dev
echo "$PASS" | sudo -S umount /mnt/rootfs/sys
echo "$PASS" | sudo -S umount /mnt/rootfs/proc
echo "$PASS" | sudo -S umount /mnt/rootfs

echo "=== HOÀN TẤT ===" | tee -a "$LOGFILE"
