ADB NOTE; `adb.exe devices` lists all connected devices, make sure to allow the computer (on the phone itself) otherwise the device state will say "unauthorized"!

FASTBOOT NOTE; Fastboot mode can be accessed without ADB by booting with [POWER] + [VOLUME DOWN]

# Prep Unlock bootloader

Settings > About phone > Software info > Tap build number
Back
Developer options >
    - OEM unlocking
    - USB debugging

NOTE; You'll want to prep rooting with Magisk before actually performing the unlock!

# Unlock bootloader

- Get adb/fastboot tools
    - https://developer.android.com/studio/releases/platform-tools
- `adb reboot bootloader`
- Wacht tot reboot
- `fastboot flashing unlock`
- Message appears, press volume up to apply
- Wait for process to complete
- `fastboot reboot`

# Prep Magisk rooting

- Download latest Magisk apk and sideload id
    - https://github.com/topjohnwu/Magisk/releases
    - `adb install magisk.apk`
- Extract bootloader .img file from installed(!) OS release
    - Nothing Phone has A/B partition scheme so bootloader is hidden inside `payload.bin`
    - Use https://github.com/ssut/payload-dumper-go/releases
    - `payload-dumper-go -p boot payload.bin`
- `adb push <bootloader.img> /sdcard/Download`
- Patch bootloader image with Magisk
- `adb pull /sdcard/Download/magisk_patched<>.img`

# Flash rooted bootloader

- `adb reboot bootloader`
- `fastboot flash boot <magisk_patched<>.img>`
- `fastboot reboot`

# UNROOT

- `adb flash boot original_bootloader.img`

# RE-LOCK

- `adb reboot bootloader`
- `fastboot flashing lock`

# Over-the-air (OTA) UPDATE

- Restore original boot.img
    - `adb reboot bootloader`
    - `fastboot flash boot <boot_original.img>`
    - `fastboot reboot`
- Install OTA through Google Play Update
- Boot Magisk patched boot.img
    - `adb reboot bootloader`
    - `fastboot boot <magisk_patched<>.img>`
- Open up Magisk app and perform direct install on top of the OTA original bootloader
    - Magisk > Install > Direct Install > Let's Go

# ROOT MODULES

# BootloopSaver

- https://github.com/Magisk-Modules-Alt-Repo/HuskyDG_BootloopSaver/tree/v1.8.1

# Safety net fix

> I haven't gotten bank apps to work because of "Play Store Attestation" which is a hardware backed
> verification service that supercedes "Safety Net API".  
> This thing basically means everyone unlocked/rooted/using a custom ROM is fucked (at the moment, very probably forever)
> if device attestation is required.

Hide existence of magisk and other device unlocking tools/features from apps

- https://github.com/kdrag0n/safetynet-fix/tree/v2.3.1

### Requires
- Zygote

# Advanced Charging controller

> Keep the configuration of Acc simple. Acca doesn't work properly, and the native acc config utilities do not work when
> the device is in battery saver.

Control the mechanism that handles charging the phone itself

- https://github.com/VR-25/acc/tree/v2022.7.30-dev
    - Do _not_ handle acc installations through the AccA app, because uninstall/reinstall doesn't properly happen 2 out of 3 times!

Use the AccA app but remove the standard profiles (Cooldown/Charge till 90%/Default) to prevent overwriting our custom config!
- https://github.com/MatteCarra/AccA/tree/v1.0.35
    - The AccA app is a front-end for acc and the apk also holds the Magisk Module
    - Don't install acc through AccA, it doesn't always properly work
    - AccA is super nice for simpel charging/discharging and current stats

- https://github.com/VR-25/djs/tree/v2021.12.14
    - Used for scheduling charge configs
    - Also applies proper config on boot, so reboot if all else fails

[OPTIONAL]
- https://install.appcenter.ms/users/sven-knispel-g51w/apps/betterbatterystats-xda-edition/distribution_groups/testers
    - Install the APK for battery monitoring

## Setup

- Run the script `acc-setup.sh` in an elevated terminal
    - `adb push '<acc-setup.sh>' /sdcard/Download`
    - `adb shell`
        - `su`
        - `sh /sdcard/Download/acc-setup.sh`
    - `adb reboot`
- 

## Important bits

Acc controls both USB charging and Qi charging.

- Not sure if the is kernel support (as of 2022-08-15) for "Battery Idle" mode, which bypasses the battery during charging, or not.
    - Not officially confirmed, but
    - The stats look kinda convincing at 0mA current.
- Using switch battery/charge_control_limit 0 _ battery/charge_control_limit_max
- Using forceOff
    - Required because heat management tools would turn on usb/wireless charging coil again

# Termux

Terminal emulator. DON'T DOWNLOAD THE APP STORE VERSION

- https://github.com/termux/termux-app

# Dolby Atmos EQ

- https://www.pling.com/p/1610004/
    - DolbyAtmos-MagicRevision-MagiskModule-20220628022755zip

# Systemless hosts

Redirect system's hosts file to user-writable one, for ad-blocking purposes

- https://github.com/gloeyisk/systemless-hosts/tree/v17.0

# Call recorder

- https://github.com/Magisk-Modules-Repo/callrecorder-skvalex/tree/v.42
    - Install trial app of call recorder!

# Google camera

- https://www.celsoazevedo.com/files/android/google-camera/dev-suggested/
    - There are multiple versions of GCAM because of device specific modifications
    - Release; BSG 8.1 [BSG is the modder name]
    - Releases from BigKaka should also work

# AOSP Customizations

?? Untested
- https://github.com/siavash79/AOSPMods/tree/v1.3.2