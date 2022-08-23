#!/bin/bash
# TODO help, opitonal force link

DOTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

exists() {
    command -v $1 >/dev/null 2>&1
}

install_packages() {
    echo install some basic command line utilities using apt

    local packages=(
        curl
        direnv
        git
        ripgrep
        rsync
        tmux
        tree
        vim
        xsel
        zsh
    )

    sudo apt update
    echo ${packages[*]} | xargs sudo apt install --assume-yes
}

install_dev_packages() {
    echo install some packages for development using apt

    local packages=(
        build-essential
        clang-format
        clangd-9
        exuberant-ctags
        python3-dev
    )

    sudo apt update
    echo ${packages[*]} | xargs sudo apt install --assume-yes

    echo make clangd-9 the default clangd
    sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-9 100
}

install_oh_my_zsh() {
    echo install oh my zsh
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

install_powerline_symbols() {
    echo install powerline symbols
    local FONT_DIR="~/.local/share/fonts"
    local URL="https://github.com/powerline/powerline/raw/develop/font"

    if [[ ! -e "${FONT_DIR}/PowerlineSymbols.otf" ]]; then
        curl -fLo ${FONT_DIR}/PowerlineSymbols.otf ${URL}/PowerlineSymbols.otf --create-dirs
        fc-cache -vf ${FONT_DIR}
        curl -fLo ~/.config/fontconfig/conf.d/10-powerline-symbols.conf ${URL}/10-powerline-symbols.conf --create-dirs
    fi
}

install_solarized_color_scheme() {
    echo install solarized color scheme for gnome terminal
    local DIR="/tmp/solarized$$"

    if ! exists dconf; then
        echo "Package dconf-cli required for solarized colors!"
        sudo apt install dconf-cli
        return -1
    fi

    git clone https://github.com/sigurdga/gnome-terminal-colors-solarized $DIR
    $DIR/install.sh
    rm -rf $DIR
}

configure_vim() {
    echo configure vim

    ln -sv ${DOTDIR}/vimrc ~/.vimrc

    # never overwrite existing .vimrc.local
    if [ ! -f ~/.vimrc.local ]; then
        cp ${DOTDIR}/vimrc.local ~/.vimrc.local
    fi

    echo install vim plugins
    vim "+PlugInstall" "+qa"
}

configure_tmux() {
    echo configure tmux

    ln -sv ${DOTDIR}/tmux.conf ~/.tmux.conf
}

configure_git() {
    echo configure git

    ln -sv ${DOTDIR}/gitconfig.base ~/.gitconfig.base
    ln -sv ${DOTDIR}/gitignore ~/.gitignore

    if [ ! -e ~/.git_template ]; then
        ln -sv ${DOTDIR}/git_template ~/.git_template
    else
        echo could not create ~/.git_template/ as it already exists
    fi

    if [ ! -e ~/.gitmessage ]; then
        echo creating empty .gitmessage file
        touch ~/.gitmessage
    fi

    # never overwrite existing .gitconfig
    if [ ! -f ~/.gitconfig ]; then
        cp ${DOTDIR}/gitconfig ~/.gitconfig
        echo please edit your user in ~/.gitconfig
    fi
}

configure_zsh() {
    echo configure zsh
    echo download prompt
    git clone https://github.com/sindresorhus/pure.git ~/.zsh/pure
    echo download colors
    curl -fLo ~/.zsh/dircolors/dircolors.ansi-dark https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.ansi-dark --create-dirs
    mkdir ~/.zsh/completions
    mkdir ~/.zsh/cache
    ln -sv ${DOTDIR}/zshrc ~/.zshrc
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
unset DOTDIR

# vim:set et sw=4 ts=4 fdm=indent:
