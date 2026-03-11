#!/bin/bash

# Modify Default IP
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# Modify default hostname
sed -i 's/OpenWrt/Railgun/g' package/base-files/files/bin/config_generate

# Enable 802.11 r
sed -i 's/FtSupport=0/FtSupport=1/g' package/lean/mt/drivers/mt_wifi/files/mt7615.1.2G.dat
sed -i 's/FtSupport=0/FtSupport=1/g' package/lean/mt/drivers/mt_wifi/files/mt7615.1.5G.dat


# 1. 强制对 Xray 核心进行极致压缩 (--ultra-brute)
# 注意：这会显著增加 GitHub Actions 的编译时间，但能省下约 1MB 空间
find feeds/passwall/ -name "Makefile" | xargs sed -i 's/$(1)\/usr\/bin\/xray/$(STAGING_DIR_HOST)\/bin\/upx --ultra-brute $(1)\/usr\/bin\/xray/g'

# 2. 修改 SquashFS 块大小（从 256k 改为 1024k）
# 这会让固件只读层的压缩率更高，通常能再省下 200-300KB
sed -i 's/256k/1024k/g' target/linux/ramips/image/mt7621.mk

# 3. 剔除没用的内核特性
echo "CONFIG_KERNEL_DEBUG_INFO=n" >> .config
echo "CONFIG_KERNEL_DEBUG_KERNEL=n" >> .config
