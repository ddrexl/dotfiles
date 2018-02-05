#!/bin/bash
# install some basic command line utilities using apt

packages=(
build-essential
clang-format
cmake
curl
dconf-cli
exuberant-ctags
git
python-dev
python3-dev
rsync
tmux
tree
vim
xsel
zsh
)

sudo apt update
echo ${packages[*]} | xargs sudo apt install --assume-yes

unset packages;
