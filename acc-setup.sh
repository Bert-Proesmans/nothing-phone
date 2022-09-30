set -e

## acc notes ##

# Allow for a +- 5% charge deviation from the set parameters!

# Prioritize battery idle mode influences automatic switch(-off) selection.
# This config statically defines the switch so there is no need to define
# prioritize_batt_idle_mode=true

# acc can send notifications to user-space!
# acc -n 'Longer battery life mode'

# cli acc is used instead of acca because some commands act weirdly through acca!

default_config () {

acc --daemon
acc --set --reset a

acc --set batt_status_workaround=true off_mid=true reset_batt_stats_on_pause=true

# Specific to Nothing Phone
acc --set charging_switch="battery/charge_control_limit 0 battery/charge_control_limit_max --" force_off=true

# Failsafe
acc --set max_temp=45 max_temp_pause=90 shutdown_temp=55 shutdown_capacity=5

}

if type acc &> /dev/null; then

default_config

cat > /sdcard/Download/acca-configuration.json <<ACCACONF
[
    {
        "profile": {
            "uid": 1,
            "profileName": "Fast",
            "accConfig": {
                "configCapacity": {
                    "shutdown": 5,
                    "resume": 75,
                    "pause": 85
                },
                "configVoltage": {
                    "max": 4200
                },
                "configTemperature": {
                    "coolDownTemperature": 40,
                    "maxTemperature": 45,
                    "pause": 90
                },
                "configCoolDown": {
                    "atPercent": 60,
                    "charge": 50,
                    "pause": 10
                },
                "configResetUnplugged": false,
                "configResetBsOnPause": true,
                "configChargeSwitch": "battery/charge_control_limit 0 battery/charge_control_limit_max",
                "configIsAutomaticSwitchingEnabled": false,
                "prioritizeBatteryIdleMode": false
            }
        },
        "mIsChecked": true
    },
    {
        "profile": {
            "uid": 2,
            "profileName": "Idle",
            "accConfig": {
                "configCapacity": {
                    "shutdown": 5,
                    "resume": 55,
                    "pause": 60
                },
                "configVoltage": {
                    "max": 3900
                },
                "configTemperature": {
                    "coolDownTemperature": 40,
                    "maxTemperature": 45,
                    "pause": 90
                },
                "configCoolDown": {
                    "atPercent": 60,
                    "charge": 50,
                    "pause": 10
                },
                "configResetUnplugged": false,
                "configResetBsOnPause": true,
                "configChargeSwitch": "battery/charge_control_limit 0 battery/charge_control_limit_max",
                "configIsAutomaticSwitchingEnabled": false,
                "prioritizeBatteryIdleMode": false
            }
        },
        "mIsChecked": true
    }
]
ACCACONF

echo 'Go and import your configuration into AccA, and set schedules!'

else
echo "'Advanced Charging Controller' not found!"
fi

if type djsc &> /dev/null; then

# djsc config file is stored at /data/adb/vr25/djs-data/config.txt
rm /data/adb/vr25/djs-data/config.txt
djsc --append "boot /system/bin/acc -n 'Don\'t forget to setup AccA profile schedules!'; : --delete"

else
echo "'Daily Job Scheduler' not found!"
fi
