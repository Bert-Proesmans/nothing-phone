set -e

## acc notes ##

# If the commands aren't found, prefix them with /system/bin/
# Default configuration file is found at /data/adb/vr25/acc-data/config.txt

# Allow for a +- 5% charge deviation from the set parameters!

# Prioritize battery idle mode influences automatic switch(-off) selection.
# This config statically defines the switch so there is no need to define
# prioritize_batt_idle_mode=true

# acc can send notifications to user-space!
# acc -n 'Longer battery life mode'

# cli acc is used instead of acca because some commands act weirdly through acca!

default_acc_config () {

# Start acc and reset the configuration
acc --daemon
acc --set --reset a

acc --set batt_status_workaround=true off_mid=true reset_batt_stats_on_pause=true

# Battery Failsafe
acc --set max_temp=45 max_temp_pause=90 shutdown_temp=55 shutdown_capacity=5

# Battery passthrough mode at 60
acc --set pause_capacity=60 resume_capacity=55

# Time based cooldown to ease battery charging
# This is a good approach for new batteries, but switch over to limit _charge current_ on older batteries!
acc --set cooldown_capacity=60 cooldown_charge=50 cooldown_pause=10 cooldown_temp=40

# Specific to Nothing Phone
# Settign the charging switch will trigger a daemon restart!
acc --set charging_switch="battery/charge_control_limit 0 battery/charge_control_limit_max --" force_off=true

}

if type acc &> /dev/null; then
default_acc_config
else
echo "'Advanced Charging Controller' not found!"
fi
