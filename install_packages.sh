#!/usr/bin/env bash
# install some basic command line utilities using apt

packages=(
build-essential
clang-format
cmake
curl
exuberant-ctags
git
python-dev
python3-dev
rsync
tmux
tmux
tree
vim
xsel
)

sudo apt update
echo ${packages[*]} | xargs sudo apt install --assume-yes

unset packages;
