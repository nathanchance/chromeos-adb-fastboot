# How to set up ADB and fastboot on an x86_64 Chromebook

## 1. Check to make sure you actually have an x86_64 Chromebook

Open crosh by hitting Ctrl-Alt-T. In the window that opened up, type `uname -m`. If that spits out `x86_64`, you are good to go. You can also use [this website](https://www.chromium.org/chromium-os/developer-information-for-chrome-os-devices) to figure it out.

## 2. Put your device into developer mode

Accessing the USB ports requires root access, which can only be accessed through developer mode.

THIS WILL MAKE YOUR CHROMEBOOK LESS SECURE. Developer mode turns off verified boot and enables the root shell by default. Unfortunately, if you need adb/fastboot access like I do, you'll have to make this sacrifice. Additionally, this WILL powerwash (wipe) your device. I recommend doing this as soon as you get your Chromebook if you know that you want it.

To put your device into developer mode, find your device on [this website](https://www.chromium.org/chromium-os/developer-information-for-chrome-os-devices), click on its name, and follow the "Entering" section. Read the entire article to familiarize yourself with developer mode so you do not accidentally reset your device by hitting space bar during boot.

## 3. Familiarize yourself with crosh

crosh, the Chrome OS shell, is your gateway to adb/fastboot. To open crosh, hit Ctrl-Alt-T. By default, crosh is a sandboxed shell, meaning you have a limited number of commands and access to the unlying filesystem. We need to go into the next level so to speak. Next, you will type `shell`; this is a true command prompt where we are going to run all of our commands.

At this point, I will recommend setting a sudo password so that if your device is ever compromised, there is some level of protection. Type `sudo su -` to get into a root shell (this should require no password), type `chromeos-setdevpasswd`, then set your password. After this, `sudo` commands will require that password.

Further reading: https://www.chromium.org/chromium-os/poking-around-your-chrome-os-device

## 4. Run the setup script

The script in this repo will do two things:

1. Download the binaries and move them to the appropriate location (`/usr/local/bin`).

2. Download and install an `adb`/`fastboot` wrapper that saves you from having to type a long and arduous command every time you want to run `adb` and `fastboot`.

I have commented the scripts so that you know they are doing nothing nefarious.

To install, run `curl -s https://raw.githubusercontent.com/nathanchance/chromeos-adb-fastboot/master/install.sh | bash` in your shell prompt.

Alternatively, if piping things from curl to bash scares you, you can run `cd ${HOME}/Downloads; curl -s https://raw.githubusercontent.com/nathanchance/chromeos-adb-fastboot/master/install.sh -o install.sh`, inspect it with `more` or `vim`, then run `chmod +x install.sh; bash install.sh`.

To verify the installation was successful, run `adb --version` and `fastboot --version`. These should say they have been installed to `/usr/local/bin`. If they don't say that or they error, do a reboot before trying again.

# Getting support

Open an issue on this repo.
