#!/bin/bash

#获取最新版本alist
ALIST_VER=$(curl -s https://api.github.com/repos/alist-org/alist/releases/latest |
    grep tag_name |
    cut -d ":" -f2 |
    sed 's/\"//g;s/\,//g;s/\ //g;s/v//' |
    head -n 1)

curl -Lo alist-win64.zip "https://github.com/alist-org/alist/releases/download/v$ALIST_VER/alist-windows-amd64-upx.zip"
unzip alist-win64.zip
rm alist-win64.zip
cp -f alist.exe alist/alist-win64.exe
rm -rf alist.exe
