#!/bin/bash

# mkdir tmp
# mkdir sfa-puer
# mkdir sbc-puer
# cd tmp
# RUN_ID=$(curl -s https://api.github.com/repos/PuerNya/sing-box/actions/runs | jq -r '.workflow_runs[] | select(.name == "Build SFA") | .id' | head -n 1)
# ARTIFACT_ID_LIST=$(curl -s https://api.github.com/repos/PuerNya/sing-box/actions/runs/$RUN_ID/artifacts?per_page=100 | jq '.artifacts[] | .id')
# for ARTIFACT_ID in $ARTIFACT_ID_LIST; do
#     curl -L -H "Authorization: token $TOKEN" -o $ARTIFACT_ID.zip https://api.github.com/repos/PuerNya/sing-box/actions/artifacts/$ARTIFACT_ID/zip
#     unzip -o $ARTIFACT_ID.zip
#     rm -f $ARTIFACT_ID.zip
#     filename=$(curl -s https://api.github.com/repos/PuerNya/sing-box/actions/artifacts/$ARTIFACT_ID | jq -r '.name' | cut -d '-' -f 4-)
#     mv -f *.apk ../sfa-puer/sfa-puer-$filename.apk
# done

# NAME=$(curl -s https://api.github.com/repos/PuerNya/sing-box/actions/runs/$RUN_ID/artifacts | jq '.artifacts[] | .name' | head -n 1)
# echo $NAME | awk -F'-' '{print $2 "-" $3}' >../version-p.txt

# RUN_ID=$(curl -s https://api.github.com/repos/PuerNya/sing-box/actions/runs | jq -r '.workflow_runs[] | select(.name == "Build Cores") | .id' | head -n 1)
# ARTIFACT_ID_LIST=$(curl -s https://api.github.com/repos/PuerNya/sing-box/actions/runs/$RUN_ID/artifacts?per_page=100 | jq '.artifacts[] | .id')
# for ARTIFACT_ID in $ARTIFACT_ID_LIST; do
#     curl -L -H "Authorization: token $TOKEN" -o $ARTIFACT_ID.zip https://api.github.com/repos/PuerNya/sing-box/actions/artifacts/$ARTIFACT_ID/zip
#     unzip -o $ARTIFACT_ID.zip
#     rm -f $ARTIFACT_ID.zip
#     filename=$(curl -s https://api.github.com/repos/PuerNya/sing-box/actions/artifacts/$ARTIFACT_ID | jq -r '.name' | cut -d '-' -f 5-)
#     mkdir -p ../sbc-puer/sbc-puer-$filename
#     mv -f * ../sbc-puer/sbc-puer-$filename
# done

# cd ..
# rm -rf tmp

rm -rf sing-box
