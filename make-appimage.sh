#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q bulky | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/bulky.svg
export DESKTOP=/usr/share/applications/bulky.desktop
export DEPLOY_PYTHON=1
export ALWAYS_SOFTWARE=1
export PATH_MAPPING='/usr/share/bulky:${SHARUN_DIR}/share/bulky'

# /usr/bin/bulky is a bash script that just executes bulky
# there is no point in that, just symlink the python script directly lol
ln -sf /usr/lib/bulky/bulky.py /usr/bin/bulky

# Deploy dependencies
quick-sharun /usr/bin/bulky /usr/lib/libgtk-3.so*

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
