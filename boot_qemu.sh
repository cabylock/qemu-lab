#!/bin/bash
cd /home/cabylock/Desktop/qemu-lab
qemu-system-x86_64 \
  -m 1024 -smp 2 \
  -kernel linux-5.15.163/arch/x86/boot/bzImage \
  -drive file=rootfs.img,format=raw,if=virtio \
  -append "root=/dev/vda rw console=ttyS0" \
  -device virtio-net,netdev=n1 \
  -netdev user,id=n1,hostfwd=tcp::2222-:22 \
  -virtfs local,path=/home/cabylock/Desktop/qemu-lab/labs,mount_tag=hostshare,security_model=none \
  -nographic
