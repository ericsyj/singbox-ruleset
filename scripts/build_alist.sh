#!/bin/bash

#获取最新版本openlist
ALIST_VER=$(curl -s https://api.github.com/repos/OpenListTeam/OpenList/releases/latest |
    grep tag_name |
    cut -d ":" -f2 |
    sed 's/\"//g;s/\,//g;s/\ //g;s/v//' |
    head -n 1)

curl -Lo openlist-win64.zip "https://github.com/OpenListTeam/OpenList/releases/download/v$ALIST_VER/openlist-windows-amd64-lite.zip"
unzip openlist-win64.zip
rm openlist-win64.zip
mv -f openlist.exe alist/alist-win64.exe
