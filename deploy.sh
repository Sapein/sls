#!/bin/sh

XBPS_PACKAGES_REPO="https://github.com/Sapein/void-packages.git"

install() {
    _programs="$(cat programs/programs)"
    su -c "xbps-install -Su ${_programs}"
}

bash() {
    mv ~/.bashrc ~/.bashrc.bak
    mv ~/.bash_profile ~/.bash_profile.bak
    ln -s "${PWD}"/bash/bashrc ~/.bashrc
    ln -s "${PWD}"/bash/bash_profile ~/.bash_profile
}

programs() {
    rm "${HOME}/.config/i3"
    rm "${HOME}/.config/i3status"
    ln -s "${PWD}"/i3 "${HOME}/.config/i3"
    ln -s "${PWD}"/dunst "${HOME}"/.config/dunst
    ln -s "${PWD}"/i3status "${HOME}".config/i3status
}

vim() {
    rm -rf ~/.vim
    rm ~/.vimrc
    git clone "https://Chanku@bitbucket.org/Chanku/vim-setup.git" "${HOME}/.vim"
    "${HOME}/.vim/deploy.sh"
}

images() {
    ln -s "${PWD}"/images "${HOME}/.config/sls_background"
}

void_packages() (
    git clone "${XBPS_PACKAGES_REPO}" "${HOME}"/develop/personal/void-packages
    cd "${HOME}"/develop/personal/void-packages
    ./xbps-src binary-bootstrap
    ./void-packages/discord
    ./void-packages/st
    ./void-packages/'linux5.16'
    ./void-packages/linux-firmware
)

system_scripts() (
    ln -s "${HOME}"/develop/personal/system-scripts/ "${HOME}"/.config/scripts
)
