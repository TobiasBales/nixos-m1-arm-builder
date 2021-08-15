FROM ubuntu:21.10

# install dependencies
RUN apt update -y
RUN apt install curl sudo xz-utils -y

# use bash instead of sh to be able to source nix configuration
SHELL ["/bin/bash", "-c"]

# create nix user and grant passwordless sudo rights for nix installation
RUN useradd -ms /bin/bash nix
RUN echo "nix ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/100-nix
USER nix
WORKDIR /home/nix

# install nix and set environment
RUN curl -L https://nixos.org/nix/install | sh
RUN source /home/nix/.nix-profile/etc/profile.d/nix.sh
# sourcing nix.sh somehow does not properly export the environment variables
# so we're going to set them manually
ENV PATH /home/nix/.nix-profile/bin:$PATH
ENV NIX_PATH /home/nix/.nix-defexpr/channels

# install nix-generators
RUN /home/nix/.nix-profile/bin/nix-env -f https://github.com/nix-community/nixos-generators/archive/master.tar.gz -i

# generate nix iso
RUN /home/nix/.nix-profile/bin/nixos-generate -f iso

RUN cp $(find /nix/store/*-nixos.iso/iso/nixos.iso) /tmp/nixos.iso

