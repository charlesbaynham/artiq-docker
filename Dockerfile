FROM nixos/nix

# Fix numpy / pandas installation issues
# See https://stackoverflow.com/questions/22388519/problems-with-pip-install-numpy-runtimeerror-broken-toolchain-cannot-link-a
RUN apk update
RUN apk add make automake gcc g++ subversion python3-dev

# Set a cache date, for easy updates
ARG CACHE_DATE=2020-05-19

RUN mkdir /artiq
WORKDIR /artiq

# Add nix channels from https://m-labs.hk/artiq/manual/installing.html#installing-via-nix-linux
RUN nix-channel --add https://nixbld.m-labs.hk/channel/custom/artiq/full/artiq-full
RUN nix-channel --remove nixpkgs
RUN nix-channel --add https://nixos.org/channels/nixos-19.09 nixpkgs
RUN nix-channel --update

# Copy nix security info and environment spec
COPY nix.conf /root/.config/nix/nix.conf
COPY artiq_env.nix .

# Get / build all the requirements once for the image
RUN nix-shell artiq_env.nix --command "artiq_client --version"

# Install these packages into the local environment
RUN nix-env -f artiq_env.nix  -i -A 'buildInputs'

