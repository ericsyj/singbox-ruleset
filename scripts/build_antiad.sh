#!/bin/bash

input=$(curl -fsSL https://raw.githubusercontent.com/privacy-protection-tools/anti-AD/master/anti-ad-clash.yaml)

# 转换为JSON格式
echo '{
    "version": 1,
    "rules": [
        {
            "domain_suffix": [' >antiad.json

# 遍历每一行
while IFS= read -r line; do
    # 忽略注释行
    if [[ $line == \#* ]] || [ $line == "payload:" ] || [ -z $line ]; then
        continue
    fi
    # 去掉yaml开头和结尾的多余字符
    line=${line#  - \'+.}
    line=${line%\'}
    # 添加到JSON文件
    echo '                "'$line'",' >>antiad.json
done <<<$input

# 移除最后一个逗号
sed -i '$ s/,$//' antiad.json

# 添加结束标记
echo '            ]
        }
    ]
}' >>antiad.json

chmod +x sing-box/sing-box
sing-box/sing-box rule-set compile --output antiad.srs antiad.json
