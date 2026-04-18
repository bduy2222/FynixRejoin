#!/data/data/com.termux/files/usr/bin/bash

echo "[FYNIX] PRO OPTIMIZER STARTING..."

# ===== WAKELOCK =====
termux-wake-lock 2>/dev/null

# ===== UI BOOST =====
su -c "settings put global window_animation_scale 0"
su -c "settings put global transition_animation_scale 0"
su -c "settings put global animator_duration_scale 0"

# ===== DISABLE DOZE =====
su -c "dumpsys deviceidle disable"

# ===== KEEP WIFI =====
svc wifi stayon true

# ===== CPU BOOST (SAFE) =====
su -c "
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo performance > \$cpu 2>/dev/null
done
"

# ===== CPU INPUT BOOST =====
su -c "echo 1 > /sys/module/cpu_boost/parameters/input_boost_enabled 2>/dev/null"

# ===== GPU BOOST (ANDROID 10-11) =====
su -c "
for gpu in /sys/class/kgsl/kgsl-3d0/devfreq/*; do
    echo performance > \$gpu/governor 2>/dev/null
done
"

# ===== I/O OPT =====
su -c "
for queue in /sys/block/*/queue/scheduler; do
    echo mq-deadline > \$queue 2>/dev/null
done
"

# ===== VM TWEAK (KHÔNG PHÁ) =====
su -c "echo 10 > /proc/sys/vm/swappiness"
su -c "echo 50 > /proc/sys/vm/vfs_cache_pressure"

# ===== THERMAL (GIẢM BÓP FPS) =====
su -c "stop thermal-engine 2>/dev/null"

# ===== LOOP =====
while true
do
    RAM=$(free | awk '/Mem:/ {print int($3/$2 * 100)}')

    # ===== SMART CACHE =====
    if [ "$RAM" -gt 88 ]; then
        echo "[FYNIX] RAM HIGH ($RAM%) → CLEAN"
        su -c "sync"
        su -c "echo 1 > /proc/sys/vm/drop_caches"
    fi

    # ===== ROBLOX PRIORITY =====
    for pkg in $(pm list packages | cut -d: -f2 | grep -i roblox)
    do
        PID=$(pidof $pkg 2>/dev/null)

        if [ ! -z "$PID" ]; then
            su -c "renice -10 -p $PID"
            su -c "ionice -c1 -n0 -p $PID"
            su -c "echo -100 > /proc/$PID/oom_score_adj 2>/dev/null"
        fi
    done

    # ===== CLEAN LOG =====
    pkill -f logcat 2>/dev/null

    # ===== FPS DROP DETECT (AUTO BOOST) =====
    LOAD=$(cat /proc/loadavg | awk '{print $1}')

    if (( $(echo "$LOAD > 3.0" | bc -l) )); then
        echo "[FYNIX] HIGH LOAD → BOOST CPU"
        su -c "
        for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_min_freq; do
            echo 80% > \$cpu 2>/dev/null
        done
        "
    fi

    # ===== SMART SLEEP =====
    if [ "$RAM" -gt 90 ]; then
        sleep 6
    elif [ "$RAM" -gt 75 ]; then
        sleep 12
    else
        sleep 20
    fi

done