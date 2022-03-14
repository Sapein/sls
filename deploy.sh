#!/bin/sh

XBPS_PACKAGES_REPO="https://github.com/Sapein/void-packages.git"
UTILITY_SCRIPTS_REPO="https://github.com/Sapein/utility-scripts.git"
VIM_CONFIG_REPO="https://github.com/Sapein/vim-setup.git"

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
    git clone "${VIM_CONFIG_REPO}" "${HOME}/.vim"
    "${HOME}/.vim/deploy.sh"
}

utility_scripts() (
    git clone "${UTILITY_SCRIPTS_REPO}" "${HOME}"/develop/personal/utility-scripts
    ln -s "${HOME}"/develop/personal/system-scripts/ "${HOME}"/.config/scripts
)

void_packages() (
    git clone "${XBPS_PACKAGES_REPO}" "${HOME}"/develop/personal/void-packages
    cd "${HOME}"/develop/personal/void-packages
    ./xbps-src binary-bootstrap
    ./void-packages/discord
    ./void-packages/st
    ./void-packages/'linux5.16'
    ./void-packages/linux-firmware
)

images() {
    ln -s "${PWD}"/images "${HOME}/.config/sls_background"
}

if [ -z "${1}" ]
then
    for arg in ${@}
    do
        case "${1}" in
            install)
                install
                ;;
            bash)
                bash
                ;;
            programs)
                programs
                ;;
            vim)
                vim
                ;;
            system_scripts|utility_scripts)
                utility_scripts
                ;;
            void_packages)
                void_packages
                ;;
            images)
                images
                ;;
            *)
                printf "Unknown Argument!\n"
                exit 0
                ;;
        esac
    done
else
    install
    bash
    programs
    vim
    utility_scripts
    void_packages
    images
fi
