#!/bin/bash

#更新UPX版本
UPX_VER=$(curl -s https://api.github.com/repos/upx/upx/releases/latest |
    grep tag_name |
    cut -d ":" -f2 |
    sed 's/\"//g;s/\,//g;s/\ //g;s/v//' |
    head -n 1)

curl -Lo upx.tar.xz "https://github.com/upx/upx/releases/download/v$UPX_VER/upx-$UPX_VER-amd64_linux.tar.xz"
tar -xf upx.tar.xz
rm upx.tar.xz
cp -f upx-$UPX_VER-amd64_linux/upx upx/
rm -rf upx-$UPX_VER-amd64_linux/

#更新sing-box linux amd64核心、shellcrash arm64核心和sing-box win amd64核心
SINGBOX_VER_LATEST=$(curl -s https://api.github.com/repos/SagerNet/sing-box/releases/latest |
    grep tag_name |
    cut -d ":" -f2 |
    sed 's/\"//g;s/\,//g;s/\ //g;s/v//' |
    head -n 1)

SINGBOX_VER_PRE=$(curl -s https://api.github.com/repos/SagerNet/sing-box/releases |
    grep tag_name |
    cut -d ":" -f2 |
    sed 's/\"//g;s/\,//g;s/\ //g;s/v//' |
    head -n 1)

curl -Lo sing-box.tar.gz "https://github.com/SagerNet/sing-box/releases/download/v$SINGBOX_VER_LATEST/sing-box-$SINGBOX_VER_LATEST-linux-amd64.tar.gz"
tar -zxvf sing-box.tar.gz -C sing-box
rm sing-box.tar.gz
cp -f sing-box/sing-box-$SINGBOX_VER_LATEST-linux-amd64/sing-box sing-box/
rm -rf sing-box/sing-box-$SINGBOX_VER_LATEST-linux-amd64

curl -Lo sing-box.tar.gz "https://github.com/SagerNet/sing-box/releases/download/v$SINGBOX_VER_LATEST/sing-box-$SINGBOX_VER_LATEST-linux-arm64.tar.gz"
tar -zxvf sing-box.tar.gz -C sing-box/
rm sing-box.tar.gz
cp -f sing-box/sing-box-$SINGBOX_VER_LATEST-linux-arm64/sing-box sing-box/CrashCore
rm -rf sing-box/sing-box-$SINGBOX_VER_LATEST-linux-arm64/

curl -Lo sing-box.zip "https://github.com/SagerNet/sing-box/releases/download/v$SINGBOX_VER_LATEST/sing-box-$SINGBOX_VER_LATEST-windows-amd64.zip"
unzip sing-box.zip -d sing-box/
rm sing-box.zip
cp -f sing-box/sing-box-$SINGBOX_VER_LATEST-windows-amd64/sing-box.exe sing-box/sing-box_win64.exe
rm -rf sing-box/sing-box-$SINGBOX_VER_LATEST-windows-amd64/

chmod -R +x ./
upx/upx --best sing-box/CrashCore
upx/upx --best sing-box/sing-box_win64.exe
cd sing-box
tar -czvf CrashCore.tar.gz CrashCore
echo $SINGBOX_VER_LATEST >version.txt
