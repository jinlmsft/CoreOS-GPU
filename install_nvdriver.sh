#!/bin/sh -x
# CoreOS + Nvidia Drivers

PREFIX=/opt/nvidia-docker

# -------------
# Nvidia Driver
# -------------
sudo chown -R $USER:root $PREFIX
docker build -t coreos-gpu .
docker run --rm --privileged -v /var/lib/docker/volumes:/var/lib/docker/volumes -v /opt/nvidia-docker:/opt/nvidia-docker -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/bin/docker -v /usr/lib/libdevmapper.so.1.02:/usr/lib/libdevmapper.so.1.02 coreos-gpu
sudo ./setup_devices.sh
sudo chown -R root:root $PREFIX
