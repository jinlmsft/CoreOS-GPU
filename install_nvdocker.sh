#!/bin/sh -x
# CoreOS + Nvidia Drivers, CUDA and docker plugin

# -------------
# nvidia-docker
# -------------
PREFIX=/opt/nvidia-docker
sudo rm -rf $PREFIX
sudo mkdir -p $PREFIX/bin
sudo mkdir -p $PREFIX/lib64
sudo chown -R $USER:root $PREFIX
rm -rf nvidia-docker
git clone https://github.com/nvidia/nvidia-docker
cd nvidia-docker/tools
sed -i -e "s/os.Link/Copy/" src/nvidia/volumes.go
docker rmi nvdocker-build
docker build --build-arg USER_ID=`id -u $USER` -t nvdocker-build -f Dockerfile.build .
docker run -v $PREFIX/bin:/go/bin --rm nvdocker-build
sudo chown -R root:root $PREFIX

