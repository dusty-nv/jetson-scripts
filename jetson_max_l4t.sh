#!/bin/sh

# turn on fan for safety
echo "Enabling fan for safety..."
if [ ! -w /sys/kernel/debug/tegra_fan/target_pwm ] ; then
	echo "Cannot set fan -- exiting..."
fi
echo 255 > /sys/kernel/debug/tegra_fan/target_pwm

echo 0 > /sys/devices/system/cpu/cpuquiet/tegra_cpuquiet/enable
echo 1 > /sys/kernel/cluster/immediate
echo 1 > /sys/kernel/cluster/force
echo G > /sys/kernel/cluster/active
echo "Cluster: `cat /sys/kernel/cluster/active`"

# online all CPUs - ignore errors for already-online units
echo "onlining CPUs: ignore errors..."
for i in 0 1 2 3 ; do
	echo 1 > /sys/devices/system/cpu/cpu${i}/online
done
echo "Online CPUs: `cat /sys/devices/system/cpu/online`"

# set CPUs to max freq (perf governor not enabled on L4T yet)
echo userspace > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
cpumax=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies | awk '{print $NF}'`
echo "${cpumax}" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed
for i in 0 1 2 3 ; do
	echo "CPU${i}: `cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq`"
done

# max GPU clock (should read from debugfs)
cat /sys/kernel/debug/clock/gbus/max > /sys/kernel/debug/clock/override.gbus/rate
echo 1 > /sys/kernel/debug/clock/override.gbus/state
echo "GPU: `cat /sys/kernel/debug/clock/gbus/rate`"

# max EMC clock (should read from debugfs)
cat /sys/kernel/debug/clock/emc/max > /sys/kernel/debug/clock/override.emc/rate
echo 1 > /sys/kernel/debug/clock/override.emc/state
echo "EMC: `cat /sys/kernel/debug/clock/emc/rate`"







