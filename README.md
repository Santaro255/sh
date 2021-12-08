# sh 

---
## CentOS
curl -L https://raw.githubusercontent.com/Santaro255/sh/master/centos/centos-docker-f2b.sh | bash \
curl -L https://raw.githubusercontent.com/Santaro255/sh/master/centos/centos8-docker-f2b.sh | bash

---
## Ubuntu
sudo su \
curl -L https://raw.githubusercontent.com/Santaro255/sh/master/ubuntu/ubuntu-docker-f2b.sh | bash

---
## Create swap
**Interactive script - create swap + change swappiness** \
curl -O https://raw.githubusercontent.com/Santaro255/sh/master/mkswap/mkswap.sh && chmod +x ./mkswap.sh && **./mkswap.sh** && rm ./mkswap.sh

**Create swap: 2Gb** \
curl -O https://raw.githubusercontent.com/Santaro255/sh/master/mkswap/mkswapc.sh && chmod +x ./mkswapc.sh && **./mkswapc.sh 2048** && rm ./mkswapc.sh

**Create swap: 4Gb** \
curl -O https://raw.githubusercontent.com/Santaro255/sh/master/mkswap/mkswapc.sh && chmod +x ./mkswapc.sh && **./mkswapc.sh 4096** && rm ./mkswapc.sh

**Create swap: 8Gb** \
curl -O https://raw.githubusercontent.com/Santaro255/sh/master/mkswap/mkswapc.sh && chmod +x ./mkswapc.sh && **./mkswapc.sh 8192** && rm ./mkswapc.sh

**Create swap: 4Gb and change vm.swappiness: 10** \
curl -O https://raw.githubusercontent.com/Santaro255/sh/master/mkswap/mkswapc+.sh && chmod +x ./mkswapc+.sh && **./mkswapc+.sh 4096 10** && rm ./mkswapc+.sh

---