#!/bin/sh

XBPS_PACKAGES_REPO="https://github.com/Sapein/void-packages.git"
UTILITY_SCRIPTS_REPO="https://github.com/Sapein/utility-scripts.git"
MPV_CONTROL_REPO="https://github.com/Sapein/mpv-control.git"
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

mpv_control() (
    git clone "${MPV_CONTROL_REPO}" "${HOME}"/develop/personal/mpv-ctrl
    ln -s "${HOME}"/develop/personal/mpv-ctrl/src/mpv_control.sh "${HOME}/.config/scripts"
)

void_packages() (
    pack_dir="${PWD}"

    git clone "${XBPS_PACKAGES_REPO}" "${HOME}"/develop/personal/void-packages
    cd "${HOME}"/develop/personal/void-packages

    git checkout personal

    ./xbps-src binary-bootstrap
    "${pack_dir}"/void-packages/discord
    "${pack_dir}"/void-packages/st
    "${pack_dir}"/void-packages/'linux5.16'
    "${pack_dir}"/void-packages/linux-firmware
    "${pack_dir}"/void-packages/vim
)

images() {
    ln -s "${PWD}"/images "${HOME}/.config/sls_background"
}

setup_homedir() {
    # Make Primary Directory
    mkdir "${HOME}/develop"
    mkdir "${HOME}/library"
    mkdir "${HOME}/games"
    mkdir "${HOME}/writing"
    mkdir "${HOME}/videos"
    mkdir "${HOME}/ttrpg"

    # Make Secondary Directories
    mkdir "${HOME}/games/launchers"
    mkdir "${HOME}/develop/personal"
}

if [ ! -z "${1}" ]
then
    for arg in ${@}
    do
        case "${1}" in
            setup-homedir)
                setup_homedir
                ;;
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
            mpv_control)
                mpv_control
                ;;
            *)
                printf "Unknown Argument!\n"
                exit 0
                ;;
        esac
    done
else
    setup_homedir
    install
    bash
    programs
    utility_scripts
    mpv_control
    void_packages
    vim
    images
fi
