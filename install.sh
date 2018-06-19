#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2018 Nathan Chancellor
# adb and fastboot installer for Chrome OS

# Move to user's download directory and make a temporary folder
mkdir -p "${HOME}/Downloads/aftmp"
cd "${HOME}/Downloads/aftmp" || { echo "Temporary folder in Downloads could not be made!"; exit 1; }

# Get the proper URL of the platform tools (the one below is just a redirect
URL=$(curl -s https://dl.google.com/android/repository/platform-tools-latest-linux.zip | cut -d \" -f 2)

# Download the latest zip
curl -s "${URL}" -o tmp.zip

# Unzip the latest tools
bsdtar -x -f tmp.zip

# Install the tools
cd platform-tools || { echo "Unzipping platform-tools failed!"; exit 1; }
sudo mkdir -p /usr/local/bin /usr/local/lib64
sudo install adb dmtracedump e2fsdroid etc1tool fastboot hprof-conv make_f2fs mke2fs mke2fs.conf sload_f2fs sqlite3 /usr/local/bin
sudo install lib64/libc++.so /usr/local/lib64

# Cleanup
cd "${HOME}" || { echo "HOME folder could not be found??"; exit 1; }
rm -rf "${HOME}/Downloads/aftmp"

# Get current version of adb-fastboot and install it
curl -s https://raw.githubusercontent.com/nathanchance/chromeos-adb-fastboot/master/adb-fastboot.sh -o ${HOME}/adb-fastboot.sh
if ! grep -q adb-fastboot ${HOME}/.bashrc; then
    echo "[[ -f \${HOME}/adb-fastboot.sh ]] && source \${HOME}/adb-fastboot.sh" >> ${HOME}/.bashrc
fi
echo "Installation complete! Please run 'source ~/.bashrc' now."
