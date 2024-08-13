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

#更新sing-box linux amd64核心、shellcrash arm64核心和sing-box win amd64v3核心
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

curl -Lo sing-box.tar.gz "https://github.com/SagerNet/sing-box/releases/download/v$SINGBOX_VER_PRE/sing-box-$SINGBOX_VER_PRE-linux-amd64.tar.gz"
tar -zxvf sing-box.tar.gz -C sing-box
rm sing-box.tar.gz
cp -f sing-box/sing-box-$SINGBOX_VER_PRE-linux-amd64/sing-box sing-box/
rm -rf sing-box/sing-box-$SINGBOX_VER_PRE-linux-amd64

curl -Lo sing-box.tar.gz "https://github.com/SagerNet/sing-box/releases/download/v$SINGBOX_VER_PRE/sing-box-$SINGBOX_VER_PRE-linux-arm64.tar.gz"
tar -zxvf sing-box.tar.gz -C sing-box/
rm sing-box.tar.gz
cp -f sing-box/sing-box-$SINGBOX_VER_PRE-linux-arm64/sing-box sing-box/CrashCore
rm -rf sing-box/sing-box-$SINGBOX_VER_PRE-linux-arm64/

curl -Lo sing-box.zip "https://github.com/SagerNet/sing-box/releases/download/v$SINGBOX_VER_PRE/sing-box-$SINGBOX_VER_PRE-windows-amd64v3.zip"
unzip sing-box.zip -d sing-box/
rm sing-box.zip
cp -f sing-box/sing-box-$SINGBOX_VER_PRE-windows-amd64v3/sing-box.exe sing-box/sing-box_win64v3.exe
rm -rf sing-box/sing-box-$SINGBOX_VER_PRE-windows-amd64v3/

chmod +x upx/upx
upx/upx --best sing-box/CrashCore
upx/upx --best sing-box/sing-box_win64v3.exe
cd sing-box
tar -czvf CrashCore.tar.gz CrashCore
echo $SINGBOX_VER_PRE >version.txt

# RUN_ID=$(curl -s https://api.github.com/repos/PuerNya/sing-box/actions/runs | jq -r '.workflow_runs[] | select(.name == "Build SFA") | .id' | head -n 1)
# ARTIFACT_ID=$(curl -s https://api.github.com/repos/PuerNya/sing-box/actions/runs/$RUN_ID/artifacts | jq '.artifacts[] | .id' | head -n 1)
# curl -L -H "Authorization: token $TOKEN" -o singbox.zip https://api.github.com/repos/PuerNya/sing-box/actions/artifacts/$ARTIFACT_ID/zip
# NAME=$(curl -s https://api.github.com/repos/PuerNya/sing-box/actions/runs/$RUN_ID/artifacts | jq '.artifacts[] | .name' | head -n 1)
# echo $NAME | awk -F'-' '{print $2 "-" $3}' >version-p.txt
# unzip singbox.zip
# rm -f singbox.zip
# mv -f SFA-*-foss-arm64-v8a-signed.apk sing-box-puer
mkdir tmp
mkdir sfa-puer
mkdir sbc-puer
cd tmp
RUN_ID=$(curl -s https://api.github.com/repos/PuerNya/sing-box/actions/runs | jq -r '.workflow_runs[] | select(.name == "Build SFA") | .id' | head -n 1)
ARTIFACT_ID_LIST=$(curl -s https://api.github.com/repos/PuerNya/sing-box/actions/runs/$RUN_ID/artifacts?per_page=100 | jq '.artifacts[] | .id')
for ARTIFACT_ID in $ARTIFACT_ID_LIST; do
    curl -L -H "Authorization: token $TOKEN" -o $ARTIFACT_ID.zip https://api.github.com/repos/PuerNya/sing-box/actions/artifacts/$ARTIFACT_ID/zip
    unzip -o $ARTIFACT_ID.zip
    rm -f $ARTIFACT_ID.zip
    filename=$(curl -s https://api.github.com/repos/PuerNya/sing-box/actions/artifacts/$ARTIFACT_ID | jq -r '.name' | cut -d '-' -f 4-)
    mv -f *.apk ../sfa-puer/sfa-puer-$filename.apk
done

NAME=$(curl -s https://api.github.com/repos/PuerNya/sing-box/actions/runs/$RUN_ID/artifacts | jq '.artifacts[] | .name' | head -n 1)
echo $NAME | awk -F'-' '{print $2 "-" $3}' >../version-p.txt

RUN_ID=$(curl -s https://api.github.com/repos/PuerNya/sing-box/actions/runs | jq -r '.workflow_runs[] | select(.name == "Build Cores") | .id' | head -n 1)
ARTIFACT_ID_LIST=$(curl -s https://api.github.com/repos/PuerNya/sing-box/actions/runs/$RUN_ID/artifacts?per_page=100 | jq '.artifacts[] | .id')
for ARTIFACT_ID in $ARTIFACT_ID_LIST; do
    curl -L -H "Authorization: token $TOKEN" -o $ARTIFACT_ID.zip https://api.github.com/repos/PuerNya/sing-box/actions/artifacts/$ARTIFACT_ID/zip
    unzip -o $ARTIFACT_ID.zip
    rm -f $ARTIFACT_ID.zip
    filename=$(curl -s https://api.github.com/repos/PuerNya/sing-box/actions/artifacts/$ARTIFACT_ID | jq -r '.name' | cut -d '-' -f 5-)
    mkdir -p ../sbc-puer/sbc-puer-$filename
    mv -f * ../sbc-puer/sbc-puer-$filename
done

cd ..
rm -rf tmp
