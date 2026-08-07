#!/bin/bash

#获取最新版本openlist
ALIST_VER=$(curl -s https://api.github.com/repos/OpenListTeam/OpenList/releases/latest |
    grep tag_name |
    cut -d ":" -f2 |
    sed 's/\"//g;s/\,//g;s/\ //g;s/v//' |
    head -n 1)

if [ "v$ALIST_VER" != "$(cat alist/version.txt)" ]; then
    curl -Lo openlist-win64.zip "https://github.com/OpenListTeam/OpenList/releases/download/v$ALIST_VER/openlist-windows-amd64.zip"
    unzip openlist-win64.zip
    rm openlist-win64.zip
    mv -f openlist.exe alist/alist-win64.exe

    curl -Lo openlist-arm64.tar.gz "https://github.com/OpenListTeam/OpenList/releases/download/v$ALIST_VER/openlist-linux-musl-arm64.tar.gz"
    tar -xzvf openlist-arm64.tar.gz
    rm openlist-arm64.tar.gz
    mv -f openlist alist/alist-linux-arm64

    upx/upx --best alist/*

    echo v$ALIST_VER > alist/version.txt
fi
