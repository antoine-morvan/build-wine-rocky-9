#!/usr/bin/env bash
set -eu -o pipefail

(
    sudo dnf update -y
    sudo dnf install -y \
        gcc automake autoconf libtool pkgconfig \
        cmake vim htop btop rsync geany git terminator firefox chromium byobu
)


exit 0
