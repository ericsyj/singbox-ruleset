#!/bin/bash

if [ -f ads.json ]; then > ads.json; fi

input=$(curl -fsSL https://raw.githubusercontent.com/Cats-Team/AdRules/main/adrules_domainset.txt)

# 转换为JSON格式
echo '{
    "version": 1,
    "rules": [
        {
            "domain_suffix": [' > ads.json

# 遍历每一行
while IFS= read -r line
do
    # 忽略注释行
    if [[ $line == \#* ]]; then
        continue
    fi
    # 去掉开头的加号
    line=${line#+}
    # 添加到JSON文件
    echo '                "'$line'",' >> ads.json
done <<< $input

# 移除最后一个逗号
sed -i '$ s/,$//' ads.json

# 添加结束标记
echo '            ]
        }
    ]
}' >> ads.json
