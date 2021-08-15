# Building nixos images in docker

This can be used to build nixos isos to run on an m1 Mac in Parallels/a VM.

Since the docker base image being used is aarch64 when run an an m1 Mac,
it generates the matching iso which works out of the box (only tested in parallels).

# Getting started

## Run build script
```sh
./build.sh
```

This will write the iso to nixos.iso

## Create new VM in parallels

Start parallels and select the created iso.
You probably want to check CPU/RAM assignments when starting.

## Install NixOS

[By following the official installation procedure](https://nixos.org/manual/nixos/stable/#sec-installation-partitioning)

I went the UEFI route but MBR should also work.
