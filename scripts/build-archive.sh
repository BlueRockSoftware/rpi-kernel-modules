#!/bin/bash
CPU=32
KERNEL_VERSION="6.1.64"
KERNEL_COMMIT="01145f0eb166cbc68dd2fe63740fac04d682133e"

echo "!!!  Build modules for kernel ${KERNEL_VERSION}  !!!"
echo "!!!  Download kernel hash info  !!!"
wget -N https://raw.githubusercontent.com/raspberrypi/rpi-firmware/${KERNEL_COMMIT}/git_hash
GIT_HASH="$(cat git_hash)"
rm git_hash

echo "!!!  Download kernel source  !!!"
wget https://github.com/raspberrypi/linux/archive/${GIT_HASH}.tar.gz

echo "!!!  Extract kernel source  !!!"
rm -rf linux-${KERNEL_VERSION}+/
tar xvzf ${GIT_HASH}.tar.gz
rm ${GIT_HASH}.tar.gz
mv linux-${GIT_HASH}/ linux-${KERNEL_VERSION}/


mkdir -p source
cd source
echo "!! pulling source !!"
wget -N https://raw.githubusercontent.com/BlueRockSoftware/rpilinux/rpi-6.1.y/sound/soc/bcm/rpi-wm8804-soundcard.c
wget -N https://raw.githubusercontent.com/BlueRockSoftware/rpilinux/rpi-6.1.y/arch/arm/boot/dts/overlays/interludeaudio-analog-overlay.dts
wget -N https://raw.githubusercontent.com/BlueRockSoftware/rpilinux/rpi-6.1.y/arch/arm/boot/dts/overlays/interludeaudio-digital-overlay.dts
wget -N https://raw.githubusercontent.com/BlueRockSoftware/rpilinux/rpi-6.1.y/arch/arm/boot/dts/overlays/Makefile


cd ..
sudo cp source/rpi-wm8804-soundcard.c linux-${KERNEL_VERSION}/sound/soc/bcm/rpi-wm8804-soundcard.c
sudo cp source/interludeaudio-analog-overlay.dts linux-${KERNEL_VERSION}/arch/arm/boot/dts/overlays/interludeaudio-analog-overlay.dts
sudo cp source/interludeaudio-digital-overlay.dts linux-${KERNEL_VERSION}/arch/arm/boot/dts/overlays/interludeaudio-digital-overlay.dts
sudo cp source/Makefile linux-${KERNEL_VERSION}/arch/arm/boot/dts/overlays/Makefile

echo "!!!  Build modules for kernel ${KERNEL_VERSION}  !!!"
echo "!!!  Build RPi0 kernel and modules  !!!"
cd linux-${KERNEL_VERSION}/
KERNEL=kernel
make -j ${CPU} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcmrpi_defconfig
make -j ${CPU} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs
mkdir -p mnt/ext4
sudo env PATH=$PATH make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=mnt/ext4 modules_install
mkdir -p modules-rpi-${KERNEL_VERSION}-interludeaudio/${KERNEL_VERSION}+
cp mnt/ext4/lib/modules/${KERNEL_VERSION}/kernel/sound/soc/bcm/snd-soc-rpi-wm8804-soundcard.ko.xz modules-rpi-${KERNEL_VERSION}-interludeaudio/${KERNEL_VERSION}+

sudo rm -rf mnt

echo "!!!  RPi0 build done  !!!"
echo "-------------------------"

echo "!!!  Build RPi3 kernel and modules  !!!"
KERNEL=kernel7
make -j ${CPU} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2709_defconfig
make -j ${CPU} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs
mkdir -p mnt/ext4
sudo env PATH=$PATH make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=mnt/ext4 modules_install
mkdir -p modules-rpi-${KERNEL_VERSION}-interludeaudio/${KERNEL_VERSION}-v7+
cp mnt/ext4/lib/modules/${KERNEL_VERSION}-v7/kernel/sound/soc/bcm/snd-soc-rpi-wm8804-soundcard.ko.xz modules-rpi-${KERNEL_VERSION}-interludeaudio/${KERNEL_VERSION}-v7+

sudo rm -rf mnt

echo "!!!  RPi3 build done  !!!"
echo "-------------------------"

echo "!!!  Build RPi4 kernel and modules  !!!"
KERNEL=kernel7l
make -j ${CPU} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2711_defconfig
make -j ${CPU} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs
mkdir -p mnt/ext4
sudo env PATH=$PATH make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=mnt/ext4 modules_install
mkdir -p modules-rpi-${KERNEL_VERSION}-interludeaudio/${KERNEL_VERSION}-v7l+
cp mnt/ext4/lib/modules/${KERNEL_VERSION}-v7l/kernel/sound/soc/bcm/snd-soc-rpi-wm8804-soundcard.ko.xz modules-rpi-${KERNEL_VERSION}-interludeaudio/${KERNEL_VERSION}-v7l+
sudo rm -rf mnt

echo "!!!  RPi4 build done  !!!"
echo "-------------------------"

echo "!!!  Build 64-bit kernel and modules  !!!"
KERNEL=kernel8
make -j ${CPU}  ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- bcm2711_defconfig
make -j ${CPU}  ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image modules dtbs
mkdir -p mnt/ext4
sudo env PATH=$PATH make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- INSTALL_MOD_PATH=mnt/ext4 modules_install
mkdir -p modules-rpi-${KERNEL_VERSION}-interludeaudio/${KERNEL_VERSION}-v8+
cp mnt/ext4/lib/modules/${KERNEL_VERSION}-v8/kernel/sound/soc/bcm/snd-soc-rpi-wm8804-soundcard.ko.xz modules-rpi-${KERNEL_VERSION}-interludeaudio/${KERNEL_VERSION}-v8+
sudo rm -rf mnt
echo "!!! 64 bit build done"
echo "-------------------------------"

echo "!!! Build Pi 5 kernel and modules !!!"
echo "-------------------------------"
KERNEL=kernel_2712
make -j ${CPU} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- bcm2712_defconfig
make -j ${CPU} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image modules dtbs
mkdir -p mnt/ext4
sudo env PATH=$PATH make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- INSTALL_MOD_PATH=mnt/ext4 modules_install
mkdir -p modules-rpi-${KERNEL_VERSION}-interludeaudio/${KERNEL_VERSION}-v8_16k
cp mnt/ext4/lib/modules/${KERNEL_VERSION}-v8-16k/kernel/sound/soc/bcm/snd-soc-rpi-wm8804-soundcard.ko.xz modules-rpi-${KERNEL_VERSION}-interludeaudio/${KERNEL_VERSION}-v8_16k
echo "!!! Pi 5 build done"
mkdir -p modules-rpi-${KERNEL_VERSION}-interludeaudio/overlays
cp arch/arm64/boot/dts/overlays//interludeaudio-digital.dtbo modules-rpi-${KERNEL_VERSION}-interludeaudio/overlays
cp arch/arm64/boot/dts/overlays//interludeaudio-analog.dtbo modules-rpi-${KERNEL_VERSION}-interludeaudio/overlays
tar -czvf modules-rpi-${KERNEL_VERSION}-interludeaudio.tar.gz modules-rpi-${KERNEL_VERSION}-interludeaudio/ --owner=0 --group=0
#md5sum modules-rpi-${KERNEL_VERSION}-interludeaudio.tar.gz > modules-rpi-${KERNEL_VERSION}-interludeaudio.md5sum.txt
#sha1sum modules-rpi-${KERNEL_VERSION}-interludeaudio.tar.gz > modules-rpi-${KERNEL_VERSION}-interludeaudio.sha1sum.txt

echo "!!!  Done  !!!"