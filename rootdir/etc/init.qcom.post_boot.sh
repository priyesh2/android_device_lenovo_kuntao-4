#!/vendor/bin/sh
# Copyright (c) 2012-2013, 2016-2018, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of The Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

target=`getprop ro.board.platform`

case "$target" in
    "msm8953")

               # disable thermal & BCL core_control to update interactive gov settings
               echo 0 > /sys/module/msm_thermal/core_control/enabled

               #governor settings
               echo 1 > /sys/devices/system/cpu/cpu0/online
               echo "interactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
               echo "19000 1401600:39000" > /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay
               echo 85 > /sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load
               echo 20000 > /sys/devices/system/cpu/cpufreq/interactive/timer_rate
               echo 1401600 > /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq
               echo 0 > /sys/devices/system/cpu/cpufreq/interactive/io_is_busy
               echo "85 1401600:80" > /sys/devices/system/cpu/cpufreq/interactive/target_loads
               echo 39000 > /sys/devices/system/cpu/cpufreq/interactive/min_sample_time
               echo 40000 > /sys/devices/system/cpu/cpufreq/interactive/sampling_down_factor
               echo 652800 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq

               # Enable sched guided freq control
               echo 1 > /sys/devices/system/cpu/cpufreq/interactive/use_sched_load
               echo 1 > /sys/devices/system/cpu/cpufreq/interactive/use_migration_notif
            ;;
        esac
    ;;
esac

case "$target" in
    "msm8953")
        setprop vendor.post_boot.parsed 1
    ;;
esac

# Let kernel know our image version/variant/crm_version
if [ -f /sys/devices/soc0/select_image ]; then
    image_version="10:"
    image_version+=`getprop ro.build.id`
    image_version+=":"
    image_version+=`getprop ro.build.version.incremental`
    image_variant=`getprop ro.product.name`
    image_variant+="-"
    image_variant+=`getprop ro.build.type`
    oem_version=`getprop ro.build.version.codename`
    echo 10 > /sys/devices/soc0/select_image
    echo $image_version > /sys/devices/soc0/image_version
    echo $image_variant > /sys/devices/soc0/image_variant
    echo $oem_version > /sys/devices/soc0/image_crm_version
fi
