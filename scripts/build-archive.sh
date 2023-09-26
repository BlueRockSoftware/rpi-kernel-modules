#!/bin/bash
CPU=12
KERNEL_VERSION="5.10.92"

mkdir compiled_overlays
cd compiled_overlays
wget -N https://raw.githubusercontent.com/BlueRockSoftware/rpi-kernel-modules/main/source/boot/overlays/interludeaudio-analog.dtbo
wget -N https://raw.githubusercontent.com/BlueRockSoftware/rpi-kernel-modules/main/source/boot/overlays/interludeaudio-digital.dtbo
cd ..
echo "!!!  Build modules for kernel ${KERNEL_VERSION}  !!!"

echo "!!!  Build RPi0 kernel and modules  !!!"
cd linux-${KERNEL_VERSION}/
KERNEL=kernel
make -j${CPU} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcmrpi_defconfig
make -j${CPU} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs
mkdir -p mnt/ext4
sudo env PATH=$PATH make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=mnt/ext4 modules_install
mkdir -p modules-rpi-${KERNEL_VERSION}-interludeaudio/lib/modules/${KERNEL_VERSION}+/kernel/sound/soc/bcm/
cp sound/soc/bcm/snd-soc-rpi-wm8804-soundcard.ko modules-rpi-${KERNEL_VERSION}-interludeaudio//lib/modules/${KERNEL_VERSION}+/kernel/sound/soc/bcm/
sudo rm -rf mnt

echo "!!!  RPi0 build done  !!!"
echo "-------------------------"

echo "!!!  Build RPi3 kernel and modules  !!!"
KERNEL=kernel7
make -j${CPU} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2709_defconfig
make -j${CPU} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs
mkdir -p mnt/ext4
sudo env PATH=$PATH make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=mnt/ext4 modules_install
mkdir -p modules-rpi-${KERNEL_VERSION}-interludeaudio/lib/modules/${KERNEL_VERSION}-v7+/kernel/sound/soc/bcm/
cp sound/soc/bcm/snd-soc-rpi-wm8804-soundcard.ko modules-rpi-${KERNEL_VERSION}-interludeaudio//lib/modules/${KERNEL_VERSION}-v7+/kernel/sound/soc/bcm/
sudo rm -rf mnt

echo "!!!  RPi3 build done  !!!"
echo "-------------------------"

echo "!!!  Build RPi4 kernel and modules  !!!"
KERNEL=kernel7l
make -j${CPU} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2711_defconfig
make -j${CPU} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs
mkdir -p mnt/ext4
sudo env PATH=$PATH make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=mnt/ext4 modules_install
mkdir -p modules-rpi-${KERNEL_VERSION}-interludeaudio/lib/modules/${KERNEL_VERSION}-v7l+/kernel/sound/soc/bcm/
cp sound/soc/bcm/snd-soc-rpi-wm8804-soundcard.ko modules-rpi-${KERNEL_VERSION}-interludeaudio//lib/modules/${KERNEL_VERSION}-v7l+/kernel/sound/soc/bcm/
sudo rm -rf mnt

echo "!!!  RPi4 build done  !!!"
echo "-------------------------"

echo "!!!  Creating archive  !!!"
mkdir -p modules-rpi-${KERNEL_VERSION}-interludeaudio/boot/overlays
cd ..
cp compiled_overlays/interludeaudio-digital.dtbo linux-${KERNEL_VERSION}/modules-rpi-${KERNEL_VERSION}-interludeaudio/boot/overlays
cp compiled_overlays/interludeaudio-analog.dtbo linux-${KERNEL_VERSION}/modules-rpi-${KERNEL_VERSION}-interludeaudio/boot/overlays
cd linux-${KERNEL_VERSION}/
tar -czvf modules-rpi-${KERNEL_VERSION}-interludeaudio.tar.gz modules-rpi-${KERNEL_VERSION}-interludeaudio/ --owner=0 --group=0
md5sum modules-rpi-${KERNEL_VERSION}-interludeaudio.tar.gz > modules-rpi-${KERNEL_VERSION}-interludeaudio.md5sum.txt
sha1sum modules-rpi-${KERNEL_VERSION}-interludeaudio.tar.gz > modules-rpi-${KERNEL_VERSION}-interludeaudio.sha1sum.txt

echo "!!!  Done  !!!"