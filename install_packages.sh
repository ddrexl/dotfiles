#!/usr/bin/env bash
# install some basic command line utilities using apt

packages=(
vim
git
tree
cmake
build-essential
curl
rsync
clang-format
)

sudo apt update
echo ${packages[*]} | xargs sudo apt install --assume-yes

unset packages;
