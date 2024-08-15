> [!NOTE]  
> This README was last updated when I was running NothingOS version 2.6

> [!TIP]  
> FASTBOOT NOTE; Fastboot mode can be accessed without ADB by booting with [POWER] + [VOLUME DOWN]

# Bootloader

## Before unlocking

Settings > About phone > Software info > Tap build number
Back
Developer options >
    - OEM unlocking
    - USB debugging

## Unlock bootloader

- Get adb/fastboot tools
    - https://developer.android.com/studio/releases/platform-tools
- `adb reboot bootloader`
- Wait until phone rebooted
- `fastboot flashing unlock`
- Message appears, press volume up to apply
- Wait for process to complete
- `fastboot reboot`

## Re-lock bootloader

> [!CAUTION]  
> Reflash stock bootloader first and boot it before relocking.
> If there is no working legit bootloader present after re-locking the bootloader, you'll brick the device!

- `adb reboot bootloader`
- `fastboot flashing lock`

# Rooting

# Prep Magisk rooting

> [!NOTE]  
> Patching happens on the phone itself to make the process less error-prone.

- Download latest Magisk apk and sideload the app onto the phone
    - https://github.com/topjohnwu/Magisk/releases
    - `adb install magisk.apk`
- Download (or extract) the bootloader partition image matching your OS version
    - OR Download from
        - https://xdaforums.com/t/nothing-phone-1-repo-nos-ota-img-guide-root.4464039/#post-87101175
    - OR Extract bootloader .img file from full OTA's
        - Nothing Phone has A/B partition scheme so bootloader is hidden inside `payload.bin`
        - Use https://github.com/ssut/payload-dumper-go/releases
            - `payload-dumper-go -p boot payload.bin`
- `adb push <bootloader.img> /sdcard/Download`
- Patch bootloader image with Magisk
    - Open Magisk app
    - Next to title "Magisk", tap "Install"
    - Choose "Select and Patch a File"
    - Tap "Let's go"
    - Pick bootloader partition image and patch
- `adb pull /sdcard/Download/magisk_patched<>.img`

# Flash rooted bootloader

> [!CAUTION]  
> It's best to work in a non-persisted way when performing manual actions.
> This is why booting from memory is preferred instead of flashing the image!

- `adb reboot bootloader`
- `fastboot boot <magisk_patched<>.img>`
- Wait for phone to boot
- Patch bootloader from Magisk app
    - Open Magisk app
    - Tap "Install"
    - Choose "Direct Install"
    - Tap "Let's go"

Or, from fastboot, run the command `fastboot flash boot <magisk_patched<>.img>`

# UNROOT

- Unroot from Magisk app
    - Open Magisk app
    - Tap "Uninstall Magisk"
    - Tap "Restore images"

Or, from fastboot, run the command `adb flash boot original_bootloader.img`

> [!TIP]  
> The unroot steps from the Magisk app are also part of using the builtin patcher to do OS updates.


# Over-the-air (OTA) UPDATE

> [!NOTE]  
> Update packages (which in itself are zip files of partition images) are distributed in "full" or "delta".
> The latter can only be used to upgrade from a specific older version to a new version.
> Not all OS versions get a "full" update package, and often it takes a few weeks before the "full" packages become
> available to users.

> [!NOTE]  
> Delta updates calculate partition checksums! If you force apply them, you'll brick the phone and require EDL

- Provided the builtin updater application wants to update your operating system
- Uninstall Magisk from the bootloader image
    - ! Updates from the builtin updater are almost always delta updates, so you need original partition images!
    - Open Magisk app
    - Tap "Uninstall Magisk"
    - Tap "Restore images"
- Start the update from the builtin updater application
    - ! DO NOT REBOOT
    - Go back to the Magisk app when the updater asks to reboot the phone
- Re-root updated bootloader
    - Open Magisk app
    - Next to the "Magisk" title, tap "Install"
    - Choose "Install to inactive slot (after OTA)"
    - Tap "Let's go"
    - Tap "Reboot" after patching completes


> [!TIP]  
> Patching the bootloader partition from the Magisk app leaves behind an image copy of the original bootloader.
> This image copy makes reverting to stock and performing OTA updates easy!

# Magisk root modules

## CF.Lumen

Installed from app store, driver activated through Magisk root.

| ![CF.Lumen settings](/assets/CF%20lumen%20main-1.png) | 
|:--:| 
| *My CF.Lumen settings.* |

| ![CF.Lumen settings](/assets/CF%20lumen%20main-2.png) | 
|:--:| 
| *My CF.Lumen settings (cont.)* |

| ![CF.Lumen settings](/assets/CF%20lumen%20main-3.png) | 
|:--:| 
| *My CF.Lumen settings (cont.)* |

> [!NOTE]  
> I bought the app from the store, using an older google account, but I cannot seem to get the app to recognize I have a pro license.
> Thankfully it has a freeload option though!

## LiveBoot

Installed from app store, installs a boot script through Magisk root.  
No configuration.

## BootloopSaver

I needed bootloop saver about 5 times since I started rooting, and of those times it failed me 4 out of 5.  
For me this piece of software does not do what I expect from it.

- https://github.com/Magisk-Modules-Alt-Repo/HuskyDG_BootloopSaver/tree/v1.8.1

## Safety net fix + Hide root

### Requires
- Magisk Zygote

Hide existence of magisk and other device unlocking tools/features from apps

- https://github.com/Displax/safetynet-fix/releases/tag/v2.3.1-MOD_2.0


### Configuration

> [!TIP]  
> You don't need complex hooking (LSPosed lib injection + Hide my Applist function overrides) for Payconiq/Argenta/Bancontact.
> Banking apps don't seem to care about developer mode. You might have to toggle on/off USB debugging (ADB) though.

- Open Magisk app
- Install the Safetynet fix module
- Enforce DenyList
    - Open settings
    - Scroll to header "Magisk"
    - Tap "Enforce Denylist"
- Add apps to DenyList
    
- Reboot
- Profit

> [!NOTE]  
> I originally added Google play services to denylist too as some guides recommended it.
> Magisk automatically deselects the play services after reboot so I guess it's not needed ¯\\\_(ツ)\_/¯

| ![Magisk denylist selection](/assets/magisk%20denylist.png) | 
|:--:| 
| *The apps currently on my Magisk denylist.* |


# Advanced Charging controller (ACC)

> [!TIP]  
> Keep the configuration of Acc simple. External battery control is flaky at best and you'll save yourself lots of headache

> [!CAUTION]  
> I have never gotten Acca to work properly, and only use it to read details on the Acca process and charging amperages once every few months.

I limit both wireless charging and charging through USB with ACC. I limit charging amperages, limit maximum battery percentage, and charging cycles to keep battery cool.

- https://github.com/VR-25/acc/tree/v2022.7.30-dev
    - Do _not_ handle acc installations through the AccA app, because uninstall/reinstall doesn't properly happen 2 out of 3 times!

The AccA app is sheit, use it for monitoring and nothing else.
- https://github.com/MatteCarra/AccA/tree/v1.0.35
    - The AccA app is a front-end for acc and the apk also holds the Magisk Module
    - Don't install acc through AccA, it doesn't always properly work

## Setup

- Run the script `acc-setup.sh` in an elevated terminal
    - `adb push '<acc-setup.sh>' /sdcard/Download`
    - `adb shell`
        - `su`
        - Allow the terminal to receive root permissions
            - Tap on "Grant" in the Magisk popup
        - `sh /sdcard/Download/acc-setup.sh`
    - `adb reboot`
- 

## Charging notes

Acc controls both USB charging and Qi charging.

- Not sure if there is kernel support (as of 2022-08-15) for "Battery Idle" mode, which bypasses the battery during charging, or not.
    - Not officially confirmed, but
    - The stats look kinda convincing at 0mA current.
- Using switch battery/charge_control_limit 0 _ battery/charge_control_limit_max
- Using forceOff
    - Required because heat management tools would turn on usb/wireless charging coil again

# Termux

Terminal emulator. DON'T DOWNLOAD THE APP STORE VERSION

- https://github.com/termux/termux-app

# Equalizing audio

Don't need a Dolby (or any other root) mod, could use the Wavelet app from the app store just fine.

- Wavelet
    - https://forum.xda-developers.com/t/increase-soundquality-of-the-nothing-phone-1-speakers-tenfold-non-root.4484165/

## Tuning

Wavelet picks its configuration depending on the active audio sync. It'll automatically switch to settings for your default speakers, bluetooth speakers, bluetooth car connection etc.

### Default speakers

Default tuning IS ABSOLUTELY HORRIBLE. The phone actually has one speaker and the earpiece "acts" as a stereo companion... but their physical properties are entirely different.  
So we have to very aggressively tune and limit! This will lower the maximum volume output, but that's still acceptable (it's still louder than a shower). And tuning the sounds stage is a balancing act to keep the metallic resonance as low as possible.

| ![Nothing phone 1 main wavelet settings](/assets/nothing%20phone%20main%20wavelet.png) | 
|:--:| 
| *Wavelet settings with activated modules displayed.* |

| ![Nothing phone 1 EQ settings](/assets/nothing%20phone%20equalizer%20wavelet.png) | 
|:--:| 
| *Nothing Phone 1 equalize settings.* |

| ![Nothing phone 1 Limiter settings](/assets/nothing%20phone%20limiter%20wavelet.png) | 
|:--:| 
| *Nothing Phone 1 limiter settings.* |

| ![Nothing phone 1 Balancer settings](/assets/nothing%20phone%20channel%20balance%20wavelet.png) | 
|:--:| 
| *Nothing Phone 1 audio balancer settings.* |

Result; A very very noticeable improvement!

### JBL Flip 4

The JBL Flip 4 sounds really good out of the box. I tweaked it a bit to pack more punch since I mostly play more "hard" music.  
The balancer settings are set like this because I don't like the volume stepper (BIG ANDROID PROBLEM BTW) and this volume reduction gives me better volume loudness control in overall atmospheres (kitchen, bathroom, fitness, garden, beach).

| ![JBL Flip 4 main wavelet settings](/assets/jbl%20flip%20main%20wavelet.png) | 
|:--:| 
| *Wavelet settings with activated modules displayed.* |

| ![JBL Flip 4 EQ settings](/assets/jbl%20flip%20equalizer%20wavelet.png) | 
|:--:| 
| *JBL Flip 4 equalize settings.* |

| ![JBL Flip 4 Balancer settings](/assets/nothing%20phone%20channel%20balance%20wavelet.png) | 
|:--:| 
| *JBL Flip 4 audio balancer settings.* |

### Mini countryman

HORRIBLE AUDIO. ABSOLUTELY HORRIBLE.

*TODO*

> [!NOTE]  
> Mini cars have an option for "Harman Kardon tuned audio", providing 6(?) more tweeters and 2(?) subwoofers. The audio setup is supposedly also tuned to the car interior.
> I don't know if it works, but anything better than the default audio setup is worth it. Believe me.

# Call recorder

NothingOS comes with Google's dialer application, but that one has various features enabled/disabled on a per phone basis. The app GAppsMod allows to toggle settings and enable features that are otherwise not available by default.

*TODO Installation instructions GAppsMod*

| ![GAppsMod settings](/assets/gappsmod.png) | 
|:--:| 
| *Basic tuning to enable the call recorder function.* |

# Camera

The camera is a piece of a modern smartphone I **never** understood the hype for. But physically "taking an image" comes down to making an interpretation of the raw light data.  
So obviously there are people with various stands on the purism spectrum. And, honestly, most out of the box camera apps produce horrible images in the average case by oversmoothing, over unsharpen, oversaturating certain hues.

The AI boom has not improved the situation. As someone who appreciates the raw-ness of things, because of the sense of truth behind it, I will never understand the appeal of AI postprocessing images.

## Google camera

The Google camera app is exclusive to the Pixel phones, but because this is Android we can sideload (and entirely reconfigure the processing pipeline of) the app on many other phones.

Admittedly I have been intrigued by what people call "the best photo processing app" for non-apple hardware and wanted to see for myself. What I did is detailed below.

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

### Currently in use

- Builtin Nothing Camera
- GCAM LMC 8.4 R15 snapcam
    - [LMC R14.xml](./LMC%20R14.xml) (adb copy to /sdcard//LMC8.4/LMC\ R14.xml)


> [!CAUTION]  
> It's not possible to remap the power button to open the camera on double tick (which is my preferred way of opening the camera).
> Because the stock camera app opens on that shortcut, I basically never use the google camera app. Making the effort of opening the custom camera app through the launcher is too much work!

# Revanced Youtube

The complexity of ReVanced has always put me off to try it. I'm an oldskool hacker and having to install launchers/managers/companion apps to the stuff I want is off putting! What I want is simplicity, implying I do prep work on my computer and push the resulting binary to my phone. Then all features are available automatically and intuitively!

But the world isn't cool like that, not anymore. Because we make tooling that automates away helpdesk responsibilities... and big G signs their stuff and hardcodes reference inside the "stock" OS (which could be worse, don't fight me).

So to install ReVanced Youtube, you have to install the Revanced Manager app! Then, just like Magisk, you provide it a Youtube apk that is patched. The patched apk is the ReVanced Youtube app you want, install that!

> [!IMPORTANT]  
> Once I was over the initial hurdle of process complexity, it's actually really nice to use ReVanced Youtube. It's a set and forget configuration, has intuitive features, and doesn't throw ads into my face literally every 30 seconds!

## Revanced Manager

*TODO*

## MicroG settings

*TODO*


# Misc

## OOM pressure issue

> [!IMPORTANT]  
> This issue has been solved in NothingOS version 2.0 and later.

NothingOS v1.5.3 has an issue with root, see https://github.com/topjohnwu/Magisk/issues/6780.  
According to https://github.com/topjohnwu/Magisk/issues/6780#issuecomment-1493036154, running `resetprop persist.sys.mglru_enable false` from a root shell will disable the new LRU system and prevent Out-of-memory (OOM) issues.

The change above _does not_ survive reboot and requires a persistent solution, aka a module.  
Download sources here https://github.com/LukeSkyD/NP1-MGLRU-FIX/, zip them, install them through Magisk.

## Magisk Systemless hosts

This option gives user apps control over the hosts file, allowing systemwide adblock/website blocking functionality.

Don't really need it since it doesn't work on most apps (like Youtube). For the Youtube app I'm using Revanced.

## Dolby atmos EQ

Too simplistic, I rather have the features of Wavelet.

- Dolby Atmos Magisk module
    - https://gitlab.com/magisk-module/dolby-atmos-magic-revision-magisk-module

## AOSP Customizations

?? Untested
- https://github.com/siavash79/AOSPMods/tree/v1.3.2