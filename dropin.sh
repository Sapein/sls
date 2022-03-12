#!/bin/sh

LOCATION=""
MIN_REQUIRED="git"
su -c 'xbps-install -Su'
su -c "xbps-install -S ${MIN_REQUIRED}"

mkdir develop
mkdir personal

git clone "${LOCATION}" develop/personal/sls
cd develop/personal/sls
./deploy.sh
