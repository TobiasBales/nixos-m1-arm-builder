#!/run/current-system/sw/bin/bash

HDD="${1}"
if [ -z "${HDD}" ]; then
  echo "You need to provide the path to the hdd to be used as the first argument."
  echo "e.g. ./${0##*/} /dev/nvme0n1"
  exit 1
fi

set -euo pipefail

echo "Creating gpt partition table"
sudo parted "${HDD}" -- mklabel gpt

echo "Creating primary partition"
sudo parted "${HDD}" -- mkpart primary 512MiB -8GiB

echo "Creating swap partition"
sudo parted "${HDD}" -- mkpart primary linux-swap -8GiB 100%

echo "Creating boot partition"
sudo parted "${HDD}" -- mkpart ESP fat32 1MiB 512MiB

echo "Enabling ESP for boot partition"
sudo parted "${HDD}" -- set 3 esp on

echo "Creating ext4 filesystem on primary partition"
sudo mkfs.ext4 -L nixos "${HDD}p1"

echo "Creating swap filesystem on swap partition"
sudo mkswap -L swap "${HDD}p2"

echo "Creating swap filesystem on swap partition"
sudo mkfs.fat -F 32 -n boot "${HDD}p3"

echo "Mounting primary partition"
sudo mount /dev/disk/by-label/nixos /mnt

echo "Mounting boot partition"
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot

echo "Enabling swap"
sudo swapon "${HDD}p2"

echo "Generating configuration"
sudo nixos-generate-config --root /mnt

echo "Feel free to edit /mnt/etc/nixos/configuration.nix now and then"
echo "sudo run nixos-install && sudo reboot"
