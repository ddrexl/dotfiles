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
        vifm
        vim-athena
        xsel
        zsh
        jq
        dnsutils
    )
    # vim-athena has +clipboard and +python3

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

install_kubernetes_tools() {
    if ! exists kubectl; then
        echo install kubectl
        local RELEASE=$(curl -L -s https://dl.k8s.io/release/stable.txt)
        curl -LO "https://dl.k8s.io/release/$RELEASE/bin/linux/amd64/kubectl"
        chmod +x ./kubectl
        sudo mv ./kubectl /usr/local/bin/
    else
        echo kubectl found
    fi

    if ! exists helm; then
        echo install helm
        curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
        chmod 700 get_helm.sh
        sudo ./get_helm.sh
        rm ./get_helm.sh
    else
        echo helm found
    fi
}

configure_vim() {
    echo configure vim

    ln -svf ${DOTDIR}/vimrc ~/.vimrc

    # never overwrite existing .vimrc.local
    if [ ! -f ~/.vimrc.local ]; then
        cp ${DOTDIR}/vimrc.local ~/.vimrc.local
    fi

    echo install vim plugins
    vim "+PlugInstall" "+qa"
}

configure_tmux() {
    echo configure tmux

    ln -svf ${DOTDIR}/tmux.conf ~/.tmux.conf
}

configure_git() {
    echo configure git

    ln -svf ${DOTDIR}/gitconfig.base ~/.gitconfig.base

    if [ ! -e ~/.gitignore ]; then
        ln -sv ${DOTDIR}/gitignore ~/.gitignore
    fi

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
    ln -svf ${DOTDIR}/zshrc ~/.zshrc
}

configure_vifm() {
    echo configure vifm

    local VIFM_CONFIG="${HOME}/.config/vifm"
    mkdir -vp ${VIFM_CONFIG}/colors

    ln -svf ${DOTDIR}/solarized-dark.vifm ${VIFM_CONFIG}/colors/solarized-dark.vifm
    ln -svf ${DOTDIR}/vifmrc ${VIFM_CONFIG}/vifmrc
}

configure_kubernetes_tools() {
    echo configure kubernetes tools

    if [ -d ~/.zsh/completions ]; then
        cd ~/.zsh/completions

        kubectl  completion zsh > _kubectl
        helm     completion zsh > _helm
    fi

}

# tested with ubuntu 24.04
install_docker_in_wsl2() {
    # System is up to date
    sudo apt update && sudo apt upgrade -y

    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Install the docker repository
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Update package index
    sudo apt update

    # Install docker
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # No sudo for docker commands
    sudo groupadd docker || true
    sudo usermod -aG docker $USER

    echo restart WSL2 to apply the changes
    echo execute \"wsl --shutdown\" in cmd or pwsh
}

help() {
    echo "Install and configure the dotfiles
    -h|--help               show this help

    --install_packages      my dev packages
    --oh_my_zsh
    --powerline_symbols
    --solarized_color_theme install tested for gnome_shell
    --install_k8s           install kubectl, helm
    --install_all           installs all above options
    --install_docker_wsl2   installs docker in wsl2 (no docker desktop)

    --configure_all         configures all below options
    --configure_vim
    --configure_tmux
    --configure_git
    --configure_zsh
    --configure_vifm
    --configure_k8s

Without arguments, the default applies:
    --install_packages
    --install_k8s
    --configure_all
"
}

array=()

if [[ "$#" -eq 0 ]]; then
    array+=(1)
    array+=(13)
    array+=(6)
fi

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help) help; exit 0;;

        --install_packages) array+=(1);;
        --oh_my_zsh) array+=(2);;
        --powerline_symbols) array+=(3);;
        --solarized_color_theme) array+=(4);;
        --install_k8s) array+=(13);;
        --install_all) array+=(5);;
        --install_docker_wsl2) array+=(14);;

        --configure_all) array+=(6);;
        --configure_vim) array+=(7);;
        --configure_tmux) array+=(8);;
        --configure_git) array+=(9);;
        --configure_zsh) array+=(10);;
        --configure_vifm) array+=(11);;
        --configure_k8s) array+=(12);;

        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

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
        13)
            install_kubernetes_tools
            ;;
        14)
            install_docker_in_wsl2
            ;;
        5)
            install_packages
            install_oh_my_zsh
            install_powerline_symbols
            install_solarized_color_scheme
            install_kubernetes_tools
            ;;
        6)
            configure_vim
            configure_tmux
            configure_git
            configure_zsh
            configure_vifm
            configure_kubernetes_tools
            ;;
        7)
            configure_vim
            ;;
        8)
            configure_tmux
            ;;
        9)
            configure_git
            ;;
        10)
            configure_zsh
            ;;
        11)
            configure_vifm
            ;;
        12)
            configure_kubernetes_tools
            ;;
        *)
            echo invalid number $choice
            ;;
    esac
done

unset array
unset DOTDIR

# vim:set et sw=4 ts=4 fdm=indent:
