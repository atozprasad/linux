#!/bin/bash
#go get -u github.com/derailed/k9s

mkdir -p ./k9s
cd k9s
curl -OL https://github.com/derailed/k9s/releases/download/v0.25.7/k9s_Linux_x86_64.tar.gz
gunzip k9s_Linux_x86_64.tar.gz
tar -xvf k9s_Linux_x86_64.tar
mv k9s /usr/local/bin
cd ..
rm -rf k9s

