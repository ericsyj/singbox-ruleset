#!/bin/bash

VERSION=$(curl -s https://api.github.com/repos/SagerNet/sing-box/releases |
    grep tag_name |
    cut -d ":" -f2 |
    sed 's/\"//g;s/\,//g;s/\ //g;s/v//' |
    head -n 1)

chmod +x sing-box/sing-box
CURRENT=$(sing-box/sing-box version | grep "sing-box version" | awk '{print $3}')

if [ "$VERSION" != "$CURRENT" ]; then
    curl -Lo sing-box.tar.gz "https://github.com/SagerNet/sing-box/releases/download/v$VERSION/sing-box-$VERSION-linux-amd64.tar.gz"
    tar -zxvf sing-box.tar.gz -C sing-box
    rm sing-box.tar.gz
    cp -f sing-box/sing-box-$VERSION-linux-amd64/sing-box sing-box
    rm -rf sing-box/sing-box-$VERSION-linux-amd64
fi

curl -Lo sing-box.tar.gz "https://github.com/SagerNet/sing-box/releases/download/v$VERSION/sing-box-$VERSION-linux-arm64.tar.gz"
tar -zxvf sing-box.tar.gz -C sing-box
rm sing-box.tar.gz
cp -f sing-box/sing-box-$VERSION-linux-arm64/sing-box sing-box/CrashCore
rm -rf sing-box/sing-box-$VERSION-linux-arm64
chmod -x upx/upx
upx/upx --best sing-box/CrashCore
cd sing-box
tar -czvf CrashCore.tar.gz CrashCore
