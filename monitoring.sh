#!/bin/bash
architecture=$(uname -a)
cpu_physical=$(lscpu | grep -i "socket(s)" | sort | uniq | wc -l)
vcpu=$(lscpu | grep -i "Core(s) per socket" | sort | uniq | wc -l)
memory_usage=$(free -m | grep Mem | awk '{printf"%d/%dMB", $3, $2}' )
memory_percent=$(free -m | grep Mem | awk '{printf"(%.2f%%)", $3/$2*100 }')
diskUsage_m=$(df -h -m --total | grep 'total' | awk '{printf"%d", $3}')
diskUsage=$(df -h --total | grep 'total' | awk '{printf"%dGb (%d%%)", $2, $5}')
cpuload=$(mpstat | grep all | awk '{printf"%.1f%%", 100 - $13}')
lastBoot=$(who -b | grep 'system boot' | awk '{print $3" "$4}')
lvm=$(lsblk | grep lvm | awk '{if($1) {print "yes";exit;}}')
tcp=$(netstat -ant | grep ESTABLISHED | wc -l)
userLog=$(who | cut -d " " -f 1 | sort -u | wc -l)
mac=$(ip a | grep link/ether | awk '{print$2}')
ip=$(ip a | grep 'scope global' | awk '{print$2}' | cut -d "/" -f 1)
sudo=$(journalctl -q _COMM=sudo | grep COMMAND | wc -l)
wall " #Architecture: $architecture
 #CPU physical : $cpu_physical
 #vCPU : $vcpu
 #Memory Usage: $memory_usage $memory_percent
 #Disk Usage: $diskUsage_m/$diskUsage
 #CPU load: $cpuload
 #Last boot: $lastBoot
 #LVM use: $lvm
 #Connections TCP : $tcp ESTABLISHED
 #User log: $userLog
 #Network: IP $ip ($mac)
 #Sudo: $sudo
"
