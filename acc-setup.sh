set -e

CONFIG_IDLE=/data/adb/acc-default-conf.txt
CONFIG_FAST=/data/adb/acc-fast-conf.txt

## acc notes ##

# Allow for a +- 5% charge deviation from the set parameters!

# Prioritize battery idle mode influences automatic switch(-off) selection.
# This config statically defines the switch so there is no need to define
# prioritize_batt_idle_mode=true

# acc can send notifications to user-space!
# acc -n 'Longer battery life mode'

# cli acc is used instead of acca because some commands act weirdly through acca!

default_config () {

acc --set --reset a
acc --daemon

acc --set batt_status_workaround=true off_mid=true

# Specific to Nothing Phone
acc --set charging_switch="battery/charge_control_limit 0 battery/charge_control_limit_max --" force_off=true

# Failsafe
acc --set max_temp=45 max_temp_pause=90 shutdown_temp=55 shutdown_capacity=5

acc --set apply_on_plug=true reset_batt_stats_on_pause=true

}

idle_config () {
# AKA forever plugged

default_config

acc --set pause_capacity=60 resume_capacity=55 max_charging_voltage=3900

# Time based cooldown to keep the battery healthy
# This is a good approach for new batteries, but switch over to limit _charge current_ on older batteries!
acc --set cooldown_capacity=60 cooldown_charge=50 cooldown_pause=10 cooldown_temp=40

acc --config cat > ${CONFIG_IDLE}
echo "IDLE CONFIG: Config saved to ${CONFIG_IDLE}"

}

fast_config () {
# AKA pretty good charge

default_config

acc --set pause_capacity=85 resume_capacity=75 max_charging_voltage=4200

# Time based cooldown to keep the battery healthy
# This is a good approach for new batteries, but switch over to limit _charge current_ on older batteries!
acc --set cooldown_capacity=60 cooldown_charge=50 cooldown_pause=10 cooldown_temp=40

acc --config cat > ${CONFIG_FAST}
echo "FAST CONFIG: Config saved to ${CONFIG_FAST}"

}

if type acc &> /dev/null; then

idle_config
fast_config

else
echo "'Advanced Charging Controller' not found!"
fi

if type djsc &> /dev/null; then

# djsc config file is stored at /data/adb/vr25/djs-data/config.txt
rm /data/adb/vr25/djs-data/config.txt

# NOTE; wait until the daemon has started before re-initing
djsc --append "boot /system/bin/acc --daemon stop; /system/bin/accd --init '${CONFIG_IDLE}';"
djsc --append "0900 /system/bin/acc --daemon stop; /system/bin/accd --init '${CONFIG_IDLE}'; /system/bin/acc -n 'Battery saver';"
djsc --append "2200 /system/bin/acc --daemon stop; /system/bin/accd --init '${CONFIG_IDLE}'; /system/bin/acc -n 'Battery saver';"

djsc --append "0700 /system/bin/acc --daemon stop; /system/bin/accd --init '${CONFIG_FAST}'; /system/bin/acc -n 'Fast charging allowed';"
djsc --append "1730 /system/bin/acc --daemon stop; /system/bin/accd --init '${CONFIG_FAST}'; /system/bin/acc -n 'Fast charging allowed';"

else
echo "'Daily Job Scheduler' not found!"
fi
