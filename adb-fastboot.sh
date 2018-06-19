#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2018 Nathan Chancellor
# fastboot and adb wrappers for Chrome OS

# adb and fastboot need to be run as root (to have access to the USB ports).
# Normally, this would be as easy as 'sudo su fastboot'. The problem is that
# HOME then becomes /root, which isn't writtable by default (and shouldn't be).
# The solution is running them with root through `su -c` but pass HOME as the
# user's actual home directory.

export USER_HOME=${HOME}

function adb() {
    sudo su --preserve-environment -c "HOME=${USER_HOME} /usr/local/bin/adb ${*}"
}

function fastboot() {
    sudo su --preserve-environment -c "HOME=${USER_HOME} /usr/local/bin/fastboot ${*}"
}
