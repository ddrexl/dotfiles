#!/bin/bash

exists() {
  command -v $1 >/dev/null 2>&1
}

install_packages() {
echo install some basic command line utilities using apt

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
tmux
tree
vim
xsel
zsh
)

sudo apt update
echo ${packages[*]} | xargs sudo apt install --assume-yes
unset packages;

}

install_oh_my_zsh() {
    echo "install oh my zsh"
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

install_powerline_symbols() {
    echo "install powerline symbols"
    local POWERLINE_URL="https://github.com/powerline/powerline/raw/develop/font"
    local POWERLINE_SYMBOLS_FILE="PowerlineSymbols.otf"
    local POWERLINE_SYMBOLS_CONF="10-powerline-symbols.conf"

    if [[ ! -e ~/.fonts/$POWERLINE_SYMBOLS_FILE ]]; then
        curl -fsSL $POWERLINE_URL/$POWERLINE_SYMBOLS_FILE -o /tmp/$POWERLINE_SYMBOLS_FILE
        mkdir ~/.fonts 2> /dev/null
        mv /tmp/$POWERLINE_SYMBOLS_FILE ~/.fonts/$POWERLINE_SYMBOLS_FILE
        fc-cache -vf ~/.fonts/
    fi

    if [[ ! -e ~/.config/fontconfig/conf.d/$POWERLINE_SYMBOLS_CONF ]]; then
        curl -fsSL $POWERLINE_URL/$POWERLINE_SYMBOLS_CONF -o /tmp/$POWERLINE_SYMBOLS_CONF
        mkdir -p ~/.config/fontconfig/conf.d 2> /dev/null
        mv /tmp/$POWERLINE_SYMBOLS_CONF ~/.config/fontconfig/conf.d/$POWERLINE_SYMBOLS_CONF
    fi
}

install_solarized_color_scheme() {
    echo "install solarized color scheme"
    local DIR="/tmp/solarized$$"

    if ! exists dconf; then
        echo "Package dconf-cli required for solarized colors!"
        return -1
    fi

    echo Install solarized color scheme
    git clone https://github.com/sigurdga/gnome-terminal-colors-solarized $DIR
    $DIR/install.sh
    rm -rf $DIR
}

configure_vim() {
    echo configure vim

    cd "$(dirname "${BASH_SOURCE}")";
    cp .vimrc ~
    cp .ycm_extra_conf.py ~
    cp -r .vimcache ~

    # never overwrite existing .vimrc.local
    if [ ! -f ~/.vimrc.local ]; then
        cp .vimrc.local ~
    fi

    # install vim plugins
    vim "+PlugInstall" "+qa"

    # compile youcompleteme
    cd ~/.vim/plugged/youcompleteme || exit 1
    ./install.py --clang-completer
}

configure_tmux() {
    echo configure tmux

    cd "$(dirname "${BASH_SOURCE}")";
    cp .tmux.conf ~
}

configure_git() {
    echo configure git

    cd "$(dirname "${BASH_SOURCE}")";
    cp .gitconfig_common ~
    cp .gitignore ~
    cp -r .git_template ~

    # never overwrite existing .gitconfig
    if [ ! -f ~/.gitconfig ]; then
        cp .gitconfig ~
    fi
}

configure_zsh() {
    echo configure zsh

    cd "$(dirname "${BASH_SOURCE}")";
    cp .zshrc ~
}

IFS=', '
read -p "Choose your option(s)
install
    1) packages
    2) oh_my_zsh!
    3) powerline symbols
    4) solarized color scheme
    5) all of the above
configure
    6)  vim
    7)  tmux
    8)  git
    9)  zsh
    10) all of the above
> " -a array

for choice in "${array[@]}"; do
    case "$choice" in
        1)
            install_packages
            ;;
        2)
            install_oh_my_zsh
            ;;
        3)
            install_powerline_symbols
            ;;
        4)
            install_solarized_color_scheme
            ;;
        5)
            install_packages
            install_oh_my_zsh
            install_powerline_symbols
            install_solarized_color_scheme
            ;;
        6)
            configure_vim
            ;;
        7)
            configure_tmux
            ;;
        8)
            configure_git
            ;;
        9)
            configure_zsh
            ;;
        10)
            configure_vim
            configure_tmux
            configure_git
            configure_zsh
            ;;
        *)
            echo invalid number
            ;;
    esac
done
