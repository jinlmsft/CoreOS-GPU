# CoreOS + Nvidia GPUs

This package will install two components to successfully create and run portable CUDA
containers on CoreOS.

* [nvidia-docker](https://github.com/nvidia/nvidia-docker) - a wrapper/plugin for docker
that simplifies the mechanism for provisioning a container with device and driver info.
* Nvidia GPU drivers

## Installation

Strangely, the order of installation is `nvidia-docker` first, then drivers.  This is
because, we will use `nvidia-docker` within the container that installs the driver
to create the docker volume with the driver specific files that will be mapped into 
GPU containers.

### Install nvidia-docker

We have to bypass the normal `sudo make install` because we don't have any drivers
loaded.  I've nic'd out of the Makefile the two critical steps to install `nvidia-docker`.
We simply pull a copy from github, modify the source with a simple sed hack, because
we want to make certain that when nvidia-docker creates the volume from within our
transient container, the files persist to the external store.

```
./install_nvdocker.sh
```

### Install GPU drivers

See script details.  Basically, pass in `nvidia-docker` and `docker` into a priviledged
container that will build and install the kernel extension, then using the host's docker
run `nvidia-docker` to create a volume (mapped back to the host).  We also have to copy
two shared libraries from the container back to the host to allow `nvidia-docker` to 
operate properly in the native CoreOS environment.

```
./install_nvdrivers.sh
```


## TODOs

1) Use Jinja templates to generate Dockerfiles for the driver install.  The way Docker builds are
cached does not account for inline evaluations, e.g. if the kernel version in the code below is updated on
a reboot, the following line is not reevaluated and therefore is considered unchanged.

```
RUN curl https://www.kernel.org/pub/linux/kernel/v`uname -r | grep -o '^[0-9]'`.x/linux-`uname -r | grep -o '[0-9].[0-9].[0-9]'`.tar.xz > linux.tar.xz \
```

Instead, we need to generate a Dockerfile with the current version of the kernel, or any attributed
that we are evaluating inline.  This will ensure the image is properly rebuilt.

2) Somehow determine the latest version of Nvidia's drivers so this value can be baked into the
Jinja template for the Dockerfile.  This will guarantee the latest version of the driver is
installed.

3) Determine how to run these scripts on a CoreOS upgrade or reboot.  
