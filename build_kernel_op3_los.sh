#!/bin/sh
export CROSS_COMPILE=/usr/bin/aarch64-linux-gnu-
export KCONFIG_NOTIMESTAMP=true
export ARCH=arm64
export SUBARCH=arm64

VER="\"-GoogyMax-OP3-LOS_v$1\""
cp -f /home/anas/OnePlus3/Kernel/arch/arm64/configs/googymax_op3_defconfig /home/anas/OnePlus3/googymax_op3_defconfig
sed "s#^CONFIG_LOCALVERSION=.*#CONFIG_LOCALVERSION=$VER#" /home/anas/OnePlus3/googymax_op3_defconfig > /home/anas/OnePlus3/Kernel/arch/arm64/configs/googymax_op3_defconfig

find -name '*.ko' -exec rm -rf {} \;

rm -f /home/anas/OnePlus3/Kernel/arch/arm64/boot/Image*.*
rm -f /home/anas/OnePlus3/Kernel/arch/arm64/boot/.Image*.*
make googymax_op3_defconfig || exit 1

make -j2 || exit 1

mkdir -p /home/anas/OnePlus3/Release/system/lib/modules
rm -rf /home/anas/OnePlus3/Release/system/lib/modules/*
# find -name '*.ko' -exec cp -av {} /home/anas/OnePlus3/Release/system/lib/modules/ \;
# ${CROSS_COMPILE}strip --strip-unneeded /home/anas/OnePlus3/Release/system/lib/modules/*

cp -f /home/anas/OnePlus3/Kernel/arch/arm64/boot/Image.gz-dtb /home/anas/OnePlus3/Out/los/kernel
cd /home/anas/OnePlus3/Out
./repack los /home/anas/OnePlus3/Release/boot.img

cd /home/anas/OnePlus3/Release
rm -f /home/anas/OnePlus3/GoogyMax-OP3_LOS_Kernel_v${1}.zip
zip -r ../GoogyMax-OP3_LOS_Kernel_v${1}.zip .

adb push /home/anas/OnePlus3/GoogyMax-OP3_LOS_Kernel_v${1}.zip /sdcard/GoogyMax-OP3_LOS_Kernel_v${1}.zip

adb kill-server

echo "GoogyMax-OP3_LOS_Kernel_v${1}.zip READY !"
