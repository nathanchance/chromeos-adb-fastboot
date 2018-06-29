#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2018 Nathan Chancellor
# adb and fastboot installer for Chrome OS

# Prints message in bold red and exits
function die() {
    echo -e "\033[01;31m"
    echo "${1}"
    echo -e "\033[0m"
    exit 1
}

# Prints message in bold green
function success() {
    echo -e "\033[01;32m"
    echo "${1}"
    echo -e "\033[0m"
}

# Displays warning in bold yellow
function warn() {
    echo -e "\033[01;33m"
    echo "${1}"
    echo -e "\033[0m"
}

# This script must NOT be run as root
[[ "$(whoami)" = "root" ]] && die "Do NOT run this script as root! Type 'exit' to get back to regular shell."

# Move to user's download directory and make a temporary folder
mkdir -p "${HOME}/Downloads/aftmp" || die "Temporary folder in Downloads could not be made!"
cd "${HOME}/Downloads/aftmp" || die "Temporary folder in Downloads could not be made!"

# Download the latest zip
curl -Ls "https://dl.google.com/android/repository/platform-tools-latest-linux.zip" -o tmp.zip || die "platform-tools could not be downloaded!"

# Unzip the latest tools
bsdtar -x -f tmp.zip || die "platform-tools zip could not be unzipped!"

# Install the tools
cd platform-tools || die "platform-tools zip could not be unzipped!"
# Make sure that the install folders exist
sudo mkdir -p /usr/local/bin /usr/local/lib64 || die "/usr/local folders could not be created"
# List of files to push to /usr/local/bin
FILES_TO_INSTALL=( adb dmtracedump e2fsdroid etc1tool fastboot hprof-conv
                   make_f2fs mke2fs mke2fs.conf sload_f2fs sqlite3 )
sudo install "${FILES_TO_INSTALL[@]}" /usr/local/bin
# This library is needed to run the tools
sudo install lib64/libc++.so /usr/local/lib64

# Cleanup
cd "${HOME}" || die "HOME folder could not be found??"
rm -rf "${HOME}/Downloads/aftmp" || warn "Temporary folder could not be cleaned up!"

# Get current version of adb-fastboot and install it
curl -s https://raw.githubusercontent.com/nathanchance/chromeos-adb-fastboot/master/adb-fastboot.sh -o "${HOME}/adb-fastboot.sh" || die "adb-fastboot wrapper could not be downloaded!"
if ! grep -q adb-fastboot "${HOME}/.bashrc"; then
    echo "[[ -f \${HOME}/adb-fastboot.sh ]] && source \${HOME}/adb-fastboot.sh" >> "${HOME}/.bashrc"
fi
success "Installation complete! Please run 'source ~/.bashrc' now."
