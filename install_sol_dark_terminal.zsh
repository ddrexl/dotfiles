#!/bin/zsh

exists() {
  command -v $1 >/dev/null 2>&1
}

install_oh_my_zsh() {
    echo "install oh my zsh"
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

install_powerline_fonts() {
    echo "install powerline fonts"
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

install_oh_my_zsh
install_powerline_fonts
install_solarized_color_scheme
