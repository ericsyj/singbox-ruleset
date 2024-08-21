#!/bin/bash

curl -fsSL -o antiad.yaml https://raw.githubusercontent.com/privacy-protection-tools/anti-AD/master/anti-ad-clash.yaml
wget -O ssc https://github.com/PuerNya/sing-srs-converter/releases/download/v2.0.1/sing-srs-converter-v2.0.1-linux-x86_64_v3
chmod +x ssc
./ssc antiad.yaml -m
mv antiad.yaml.srs antiad.srs
rm -f ssc antiad.yaml