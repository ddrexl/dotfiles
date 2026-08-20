#!/bin/bash

DOTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

exists() {
    command -v $1 >/dev/null 2>&1
}

install_packages() {
    echo install some basic command line utilities using apt

    local packages=(
        curl
        git
        ripgrep
        rsync
        tmux
        tree
        vifm
        neovim
        wl-clipboard # neovim clipboard on wayland/WSLg
        python3-venv # neovim: mason installs basedpyright into a venv
        xsel
        zsh
        jq
        dnsutils
        bat
        eza
        duf
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

install_powerline_symbols() {
    echo install powerline symbols
    local FONT_DIR="${HOME}/.local/share/fonts"
    local URL="https://github.com/powerline/powerline/raw/develop/font"

    if [[ ! -e "${FONT_DIR}/PowerlineSymbols.otf" ]]; then
        curl -fLo ${FONT_DIR}/PowerlineSymbols.otf ${URL}/PowerlineSymbols.otf --create-dirs
        fc-cache -vf ${FONT_DIR}
        curl -fLo ~/.config/fontconfig/conf.d/10-powerline-symbols.conf ${URL}/10-powerline-symbols.conf --create-dirs
    fi
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

install_docker_in_wsl2() {
    # tested with ubuntu 24.04

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

install_lazydocker() {
    if exists lazydocker; then
        echo lazydocker found
        return
    fi

    # not packaged in apt, take the release binary from github
    echo install lazydocker
    local version=$(curl -fsSL https://api.github.com/repos/jesseduffield/lazydocker/releases/latest | jq -r .tag_name)
    version=${version#v}
    curl -fLo /tmp/lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/download/v${version}/lazydocker_${version}_Linux_x86_64.tar.gz"
    tar -C /tmp -xzf /tmp/lazydocker.tar.gz lazydocker
    sudo install -m 755 /tmp/lazydocker /usr/local/bin/lazydocker
    rm /tmp/lazydocker.tar.gz /tmp/lazydocker
}

install_neovim() {
    if exists nvim; then
        echo neovim found
        return
    fi

    echo install neovim
    local candidate=$(apt-cache policy neovim | awk '/Candidate:/ {print $2}')
    if dpkg --compare-versions "${candidate%%[-+]*}" ge 0.10 2>/dev/null; then
        sudo apt update
        sudo apt install --assume-yes neovim
    else
        # apt version too old for the plugins (ubuntu <= 24.04),
        # use the official build instead
        echo "apt only has neovim '${candidate}', installing the official build to /opt"
        curl -fLo /tmp/nvim-linux-x86_64.tar.gz https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
        sudo rm -rf /opt/nvim-linux-x86_64
        sudo tar -C /opt -xzf /tmp/nvim-linux-x86_64.tar.gz
        sudo ln -svf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
        rm /tmp/nvim-linux-x86_64.tar.gz
    fi
}

configure_neovim() {
    echo configure neovim

    install_neovim

    mkdir -p ~/.config
    # -n: don't follow an existing symlink, or re-runs would nest nvim/nvim
    ln -svfn ${DOTDIR}/nvim ~/.config/nvim

    # never overwrite existing .nvim.local.lua
    if [ ! -f ~/.nvim.local.lua ]; then
        cp ${DOTDIR}/nvim.local.lua ~/.nvim.local.lua
    fi

    echo install neovim plugins, language servers and treesitter parsers
    nvim --headless "+Lazy! sync" +qa
    nvim --headless "+MasonToolsInstallSync" +qa
    nvim --headless "+lua require('nvim-treesitter').install(require('treesitter-parsers')):wait(300000)" +qa
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

    echo install tmux plugins
    # cloned directly instead of via "tpm install", which needs a running
    # server -- and starting one here would trigger a continuum auto-restore
    local plugins=(
        tmux-plugins/tpm
        tmux-plugins/tmux-resurrect
        tmux-plugins/tmux-continuum
    )
    mkdir -p ~/.tmux/plugins
    for repo in ${plugins[*]}; do
        local dir=~/.tmux/plugins/${repo##*/}
        if [ ! -d ${dir} ]; then
            git clone https://github.com/${repo}.git ${dir}
        else
            git -C ${dir} pull --ff-only
        fi
    done
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
    if [ ! -d ~/.zsh/pure ]; then
        git clone https://github.com/sindresorhus/pure.git ~/.zsh/pure
    fi
    echo download colors
    curl -fLo ~/.zsh/dircolors/dircolors.ansi-dark https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.ansi-dark --create-dirs
    mkdir -p ~/.zsh/completions
    mkdir -p ~/.zsh/cache
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

configure_github_cli() {
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install gh

    echo choose "GitHub.com", "HTTPS", "Authenticate Git with your GitHub credentials=YES" and "Login with a web browser"
    gh auth login
}

help() {
    echo "Install and configure the dotfiles
    -h|--help               show this help

    --install_packages      my dev packages
    --powerline_symbols
    --install_k8s           install kubectl, helm
    --install_lazydocker    install lazydocker, a docker TUI
    --install_all           installs all above options
    --install_docker_wsl2   installs docker in wsl2 (no docker desktop)

    --configure_all         configures all below options (vim: only neovim)
    --configure_neovim
    --configure_vim
    --configure_tmux
    --configure_git
    --configure_zsh
    --configure_vifm
    --configure_k8s

Without arguments, the default applies:
    --install_packages
    --install_k8s
    --install_lazydocker
    --configure_all
"
}

array=()

if [[ "$#" -eq 0 ]]; then
    array+=(1)
    array+=(13)
    array+=(16)
    array+=(6)
fi

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help) help; exit 0;;

        --install_packages) array+=(1);;
        --powerline_symbols) array+=(3);;
        --install_k8s) array+=(13);;
        --install_lazydocker) array+=(16);;
        --install_all) array+=(5);;
        --install_docker_wsl2) array+=(14);;

        --configure_all) array+=(6);;
        --configure_neovim) array+=(15);;
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
        3)
            install_powerline_symbols
            ;;
        13)
            install_kubernetes_tools
            ;;
        16)
            install_lazydocker
            ;;
        14)
            install_docker_in_wsl2
            ;;
        5)
            install_packages
            install_powerline_symbols
            install_kubernetes_tools
            install_lazydocker
            ;;
        6)
            configure_neovim
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
        15)
            configure_neovim
            ;;
        *)
            echo invalid number $choice
            ;;
    esac
done

unset array
unset DOTDIR

# vim:set et sw=4 ts=4 fdm=indent:
