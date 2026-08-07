#!/bin/bash

rm -rf sfa-puer sbc-puer shellcrash-puer
mkdir tmp sfa-puer sbc-puer shellcrash-puer
cd tmp

count=0
RUN_ID=$(curl -s https://api.github.com/repos/PuerNya/sing-box/actions/runs?status=success | jq -r '.workflow_runs[] | select(.name == "Build SFA") | .id' | head -n 1)
NAME=$(curl -s https://api.github.com/repos/PuerNya/sing-box/actions/runs/$RUN_ID/artifacts | jq '.artifacts[] | .name' | head -n 1)
echo $NAME | grep -q -e "alpha" -e "beta" -e "rc" && count=1
echo $NAME | cut -d '-' -f "2-$((count+3))" > ../version-sfa-p.txt
ARTIFACT_ID_LIST=$(curl -s https://api.github.com/repos/PuerNya/sing-box/actions/runs/$RUN_ID/artifacts?per_page=100 | jq '.artifacts[] | .id')
for ARTIFACT_ID in $ARTIFACT_ID_LIST; do
    curl -L -H "Authorization: token $TOKEN" -o $ARTIFACT_ID.zip https://api.github.com/repos/PuerNya/sing-box/actions/artifacts/$ARTIFACT_ID/zip
    unzip -o $ARTIFACT_ID.zip
    rm -f $ARTIFACT_ID.zip
    filename=$(curl -s https://api.github.com/repos/PuerNya/sing-box/actions/artifacts/$ARTIFACT_ID | jq -r '.name' | cut -d '-' -f "$((count+4))-")
    mv -f *.apk ../sfa-puer/sfa-puer-$filename.apk
done

count=0
RUN_ID=$(curl -s https://api.github.com/repos/PuerNya/sing-box/actions/runs?status=success | jq -r '.workflow_runs[] | select(.name == "Build Cores") | .id' | head -n 1)
NAME=$(curl -s https://api.github.com/repos/PuerNya/sing-box/actions/runs/$RUN_ID/artifacts | jq '.artifacts[] | .name' | head -n 1)
echo $NAME | grep -q -e "alpha" -e "beta" -e "rc" && count=1
echo $NAME | cut -d '-' -f "3-$((count+4))" > ../version-p.txt
ARTIFACT_ID_LIST=$(curl -s https://api.github.com/repos/PuerNya/sing-box/actions/runs/$RUN_ID/artifacts?per_page=100 | jq '.artifacts[] | .id')
for ARTIFACT_ID in $ARTIFACT_ID_LIST; do
    curl -L -H "Authorization: token $TOKEN" -o $ARTIFACT_ID.zip https://api.github.com/repos/PuerNya/sing-box/actions/artifacts/$ARTIFACT_ID/zip
    unzip -o $ARTIFACT_ID.zip
    rm -f $ARTIFACT_ID.zip
    filename=$(curl -s https://api.github.com/repos/PuerNya/sing-box/actions/artifacts/$ARTIFACT_ID | jq -r '.name' | cut -d '-' -f "$((count+5))-")
    mkdir -p ../sbc-puer/sbc-puer-$filename
    mv -f * ../sbc-puer/sbc-puer-$filename
done

cd ..
rm -rf tmp

cp -f sbc-puer/sbc-puer-linux-arm64/sing-box-client shellcrash-puer/CrashCore
curl -s -o upx https://raw.githubusercontent.com/ericsyj/singbox-ruleset/main/upx/upx
chmod -R +x ./
./upx --best shellcrash-puer/CrashCore
tar -czvf shellcrash-puer/CrashCore.tar.gz shellcrash-puer/CrashCore
rm -f upx
