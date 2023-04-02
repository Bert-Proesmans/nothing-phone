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

> Delta updates calculate partition checksums! Don't force anything regarding updates bruh, or you'll brick and require EDL

- OTA update is probably a DELTA update, if it is you need to find the boot image of the NothingOS version that's running
    - Check the XDA thread for OTA Full download links
        - https://forum.xda-developers.com/t/phone-1-rom-ota-nothing-os-repo-of-nothing-os-update-17-09-2022.4464039/
    - Or find the magisk backup image
        - Check /data/magisk_backup_[SHA1]/boot.img.gz
- Restore original boot.img
    - `adb reboot bootloader`
    - `fastboot flash boot <boot_original.img>`
    - `fastboot reboot`
- Install OTA through Google Play Update
- REBOOT !!
    - You have to reboot after the OTA is "installed" because the crucial installation steps happens _after first reboot_
    - The OTA mechanism will restore the original boot.img if you root before this step
- Boot Magisk patched boot.img
    - `adb reboot bootloader`
    - `fastboot boot <magisk_patched<>.img>`
- Open up Magisk app and perform direct install on top of the OTA original bootloader
    - Magisk > Install > Direct Install > Let's Go

## Quicker method

* Restore original boot images
** Open Magisk
** Press "Uninstall Magisk"
** Press "Restore boot images"
* Execute OTA, wait for it to ask for a reboot
* Reinstall Magisk
** Open Magisk
** Press "Install"
** Choose "Other partition slot (after OTA), DO NOT REBOOT THROUGH MAGISK
* Reboot from OTA screen
** Go back to OTA success screen
** Press "Reboot"

Phone will reboot from the other partition slot (a->b or b->a). You'll see the bootlog first, then the update screen.  
Just for good measure, root again with the direct install method and verify with another reboot.

* Root boot image with direct install
** Open Magisk
** Press "Install"
** Choose "Direct Install"
** Wait for finish, press "Reboot"

# ROOT MODULES

# OOM pressure issue

NothingOS v1.5.3 has an issue with root, see https://github.com/topjohnwu/Magisk/issues/6780.  
According to https://github.com/topjohnwu/Magisk/issues/6780#issuecomment-1493036154, running `resetprop persist.sys.mglru_enable false` from a root shell will disable the new LRU system and prevent Out-of-memory (OOM) issues.

The change above _does not_ survive reboot and requires a persistent solution, aka a module.  
Download sources here https://github.com/LukeSkyD/NP1-MGLRU-FIX/, zip them, install them through Magisk.

# BootloopSaver

- https://github.com/Magisk-Modules-Alt-Repo/HuskyDG_BootloopSaver/tree/v1.8.1

# Safety net fix

> I haven't gotten bank apps to work because of "Play Store Attestation" which is a hardware backed
> verification service that supercedes "Safety Net API".  
> This thing basically means everyone unlocked/rooted/using a custom ROM is fucked (at the moment, very probably forever)
> if device attestation is required.

Hide existence of magisk and other device unlocking tools/features from apps

- https://github.com/Displax/safetynet-fix/releases/tag/v2.3.1-MOD_2.0

### Requires
- Zygote

### Configuration

- Install the Safetynet fix module
- Add Banking apps to DenyList
    - I added Google play services to denylist too, but it automatically deselected after reboot
- Enforce DenyList
- Reboot
- Profit

### Note

You don't need complex hooking (LSPosed lib injection + Hide my Applist function overrides) for Payconiq!
Banking apps don't care about developer mode! You might have to toggle on/off USB debugging (ADB)

# Advanced Charging controller

> Keep the configuration of Acc simple. Acca doesn't work properly, and the native acc config utilities do not work when
> the device is in battery saver.

Control the mechanism that handles charging the phone itself

- https://github.com/VR-25/acc/tree/v2022.7.30-dev
    - Do _not_ handle acc installations through the AccA app, because uninstall/reinstall doesn't properly happen 2 out of 3 times!

The AccA app is sheit, use it for monitoring and nothing else.
- https://github.com/MatteCarra/AccA/tree/v1.0.35
    - The AccA app is a front-end for acc and the apk also holds the Magisk Module
    - Don't install acc through AccA, it doesn't always properly work

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

Don't need a Dolby mod, could use the Wavelet app just fine.

- Wavelet
    - https://forum.xda-developers.com/t/increase-soundquality-of-the-nothing-phone-1-speakers-tenfold-non-root.4484165/
- Dolby Atmos Magisk module
    - https://gitlab.com/magisk-module/dolby-atmos-magic-revision-magisk-module

# Systemless hosts

Don't really need it since it doesn't work on most apps (like Youtube)

# Call recorder

Call recorder app is a payed option. Look out for in-built options..

# Google camera

- https://www.celsoazevedo.com/files/android/google-camera/dev-suggested/
    - There are multiple versions of GCAM because of device specific modifications
    - Release; BSG 8.1 [BSG is the modder name]
    - Releases from BigKaka should also work

- https://www.celsoazevedo.com/files/android/google-camera/f/settings09/
    - Config files for GCam might/will unlock camera specs and improve picture performance
    - Above link has meta information
    - As for config file, there is a telegram group for photo enthousiasts on the Nothing Phone
        - https://t.me/NothingPhonePhotography

Yes, it's overwhelming for a beginner

## Currently in use

- GCAM LMC 8.4 R15 snapcam
- LMC R14.xml (/sdcard//LMC8.4/LMC\ R14.xml)

# AOSP Customizations

?? Untested
- https://github.com/siavash79/AOSPMods/tree/v1.3.2