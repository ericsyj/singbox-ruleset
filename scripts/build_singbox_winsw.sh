#!/bin/bash

WINSW_VER_PRE=$(curl -s https://api.github.com/repos/winsw/winsw/releases |
    grep tag_name |
    cut -d ":" -f2 |
    sed 's/\"//g;s/\,//g;s/\ //g;s/v//' |
    head -n 1)

cd singbox_winsw/
curl -Lo winsw.exe "https://github.com/winsw/winsw/releases/download/v$WINSW_VER_PRE/WinSW-x64.exe"

curl -Lo sing-box.exe "https://raw.githubusercontent.com/ericsyj/singbox-ruleset/main/sing-box/sing-box_win64.exe"

cp -f ../windows/singbox.json data/config.json

zip -r singbox-winsw.zip winsw.exe sing-box.xml *.vbs sing-box.exe data/
