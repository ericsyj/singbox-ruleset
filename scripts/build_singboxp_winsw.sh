#!/bin/bash

WINSW_VER_PRE=$(curl -s https://api.github.com/repos/winsw/winsw/releases |
    grep tag_name |
    cut -d ":" -f2 |
    sed 's/\"//g;s/\,//g;s/\ //g;s/v//' |
    head -n 1)

cd singboxp_winsw/
curl -Lo winsw.exe "https://github.com/winsw/winsw/releases/download/v$WINSW_VER_PRE/WinSW-x64.exe"

curl -Lo sing-box.exe "https://raw.githubusercontent.com/ericsyj/singbox-ruleset/sing-box-p/sbc-puer/sbc-puer-windows-amd64v3/sing-box-client.exe"

curl -Lo upx "https://raw.githubusercontent.com/ericsyj/singbox-ruleset/main/upx/upx"

chmod -R +x ./
./upx --best sing-box.exe

rm -f upx

cp -f ../windows/singboxp.json data/config.json
zip -r singboxp-winsw.zip winsw.exe sing-box.xml *.vbs sing-box.exe data/