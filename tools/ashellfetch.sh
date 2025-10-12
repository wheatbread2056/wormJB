#!/bin/sh
# original version of this script by GrandDiJay
# modified by wheatbread2056 and chatGPT for wormJB
# but wheatbread2056 didnt originally make this, it was GrandDiJay
# credit to GrandDiJay
# shoutout to GrandDiJay
# i love GrandDiJay

# the original repo is here:
# https://github.com/GrandDiJay/aShellFetch

user=$(whoami)
host=$(uname -n)
os=$(uname -s)
kernel=$(uname -r)
uptime=$(uptime | awk '{print $3,$4}' | sed 's/,//')
shell="$SHELL"
cpu_arch=$(uname -p)
cpu_model=$(uname -m)
wormjb_version=$(cat ~/Documents/wormjbver 2>/dev/null)

calculate_memory() {
    local meminfo="/tmp/meminfo"
    local total_mem=0
    local free_mem=0


    if [ -f "$meminfo" ]; then
        total_mem=$(awk '/MemTotal/ {print $2}' "$meminfo")
        free_mem=$(awk '/MemAvailable/ {print $2}' "$meminfo")
        rm "$meminfo"
    fi


    total_mem=$(format_bytes "$total_mem")
    free_mem=$(format_bytes "$free_mem")

    echo "$total_mem"
    echo "$free_mem"
}


format_bytes() {
    local bytes=$1
    local unit="B"

    if [ $bytes -gt 1024 ]; then
        bytes=$((bytes / 1024))
        unit="KB"
    fi

    if [ $bytes -gt 1024 ]; then
        bytes=$((bytes / 1024))
        unit="MB"
    fi

    if [ $bytes -gt 1024 ]; then
        bytes=$((bytes / 1024))
        unit="GB"
    fi

    echo "$bytes $unit"
}


total_memory=$(calculate_memory)




cat << "EOF"
                    ,xNMM.
               .OMMMMo
               lMM"
     .;loddo:.  .olloddol;.
   cKMMMMMMMMMMNWMMMMMMMMMM0:
$.KMMMMMMMMMMMMMMMMMMMMMMMWd.
 XMMMMMMMMMMMMMMMMMMMMMMMX.
$MMMMMMMMMMMMMMMMMMMMMMMM:
:MMMMMMMMMMMMMMMMMMMMMMMM:
$MMMMMMMMMMMMMMMMMMMMMMMMX.
 kMMMMMMMMMMMMMMMMMMMMMMMMWd.
 $XMMMMMMMMMMMMMMMMMMMMMMMMMMk
  'XMMMMMMMMMMMMMMMMMMMMMMMMK.
    $kMMMMMMMMMMMMMMMMMMMMMMd
     ;KMMMMMMMWXXWMMMMMMMk.
       "cooc*"    "*coo'"

EOF


echo "User:                  $user"
echo "Host:                  $host"
echo "OS:                    $os"
echo "Kernel:                $kernel"
echo "Uptime:                $uptime"
echo "Shell:                 $shell"
echo "CPU Architecture:      $cpu_arch"
echo "CPU Model:             $cpu_model"
echo "Environment:           Semi-Rootless"
echo "wormJB Version:        $wormjb_version"
