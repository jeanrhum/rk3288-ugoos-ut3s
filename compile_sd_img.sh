#!/bin/sh

# Requirements:
# linaro toolchain > 4.5
# https://www.linaro.org/downloads/

# Get last Myy script to built a kernel
wget https://raw.githubusercontent.com/Miouyouyou/RockMyy/master/GetPatchAndCompileKernel.sh
# Make it executable
chmod +x GetPatchAndCompileKernel.sh

# Modify it to use master branch! otherwise: Could not download 0001-drivers-Integrating-Mali-Midgard-video-and-gpu-drive.patch

# Launch kernel compilation
./GetPatchAndCompileKernel.sh
# Create kernel.from previous compilation
git clone https://github.com/tlgimenes/archlinux-firefly.git
#./firefly-rk3288-kernel/mkkrnlimg /tmp/RockMyy-Build/boot/zImage kernel.img
archlinux-firefly/create-linux-sdcard-usb/Tools/mkkrnlimg /tmp/RockMyy-Build/boot/zImage kernel.img

# 
git clone https://github.com/neo-technologies/rockchip-mkbootimg.git
cd rockchip-mkbootimg
make
export PATH=$PATH:`pwd`
cd ..

# Create initrd
git clone https://github.com/TeeFirefly/initrd.git
make -C initrd

# mkbootimg
#git clone https://github.com/neo-technologies/rockchip-mkbootimg.git
#cd rockchip-mkbootimg/
#make
#cd ..

# Create boot image
./rockchip-mkbootimg/mkbootimg --kernel kernel.img --ramdisk initrd.img -o boot-linux.img

# resource_tool to process miqi dtb to resource.img
wget https://github.com/rockchip-linux/rkbin/raw/master/tools/resource_tool
chmod +x resource_tool
./resource_tool /tmp/RockMyy-Build/boot/rk3288-miqi.dtb

## Building a rootfs:
# get MiQi armbian img
#wget https://dl.armbian.com/miqi/Ubuntu_xenial_next_desktop.7z
# Extract it
#7z e Ubuntu_xenial_next_desktop.7z
# Check its size: dd if=/dev/zero of=rootfs.img bs=1M count=0 seek=3000
#du -m Armbian_xxx.img
# Create an empty img, a bit greater than previous size
#dd if=/dev/zero of=rootfs.img bs=1M count=0 seek=3000 
# Format new img and set its label linuxroot
#sudo mkfs.ext4 -F -L linuxroot rootfs.img
# Create a temporary directory to copy rootfs file and mount it
#mkdir tmp
#cd tmp
#install -d rootfs
# Mount previous empty rootfs
#sudo mount -o loop ../rootfs.img rootfs/
# Remove useless files
#sudo rm -rf rootfs/lost+found/
# Mount armbian img
#install -d armbian
# Look armbian img to get starting adress
#sudo fdisk -l ../Armbian_xxx.img
#sudo mount -t auto -o loop,offset=$((8192*512)) ./Armbian_xxx.img ./armbian
# Copy files from armbian to rootfs
#sudo cp -r armbian/* rootfs/
#sudo cp -r ../RockMyy-Build/lib/* rootfs/image/lib
#sudo sync
#sudo umount rootfs/
#sudo umount armbian
#ln -s rootfs.img linux-rfs.img
#mv resource.img resource-linux.img
# Download and extract archive from https://plus.google.com/+IanMORRISON/posts/22Vxc6Sr5Ei?cfem=1
#../create-sdcard/create-linux-sdcard
