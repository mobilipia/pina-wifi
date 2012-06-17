#!/bin/bash
iw dev wlan0 station dump > stadump #obtener todas la estaciones conectadas

function GetHosts() {
local i=1
sta_list=$(cat stadump | grep -e "Station" | cut -f 2 -d" ") #listar los SSID de todas las estaciones
sta_count=$(cat stadump | grep -e "Station" | cut -f 2 -d" " | wc -w) #contar cuantas estaciones

	while [ "${i}" -le "${sta_count}" ] # para tantas veces como estaciones hayan
	do
	sta[${i}]=$(echo ${sta_list} | awk -v num=$i '{print $num}') #set sta as i in sta_list
	sta_ip[${i}]=$(cat /tmp/dhcp.leases | grep "${sta[${i}]}" | awk '{print $3}') # grap the IP corresponding with the bssid in the DHCP lease file
	sta_ssid[${i}]=$(cat /tmp/karma.log | grep "${sta[${i}]}" | grep SSID | tail -1 | awk '{print $8}') # grab the Karma'd SSID corresponding to the bssid in the karma log
	sta_hostname[${i}]=$(cat /tmp/dhcp.leases | grep "${sta[${i}]}" | awk '{print $4}') # grap the hostname corresponding with the bssid in the DHCP lease file
	sta_linenum[${i}]=$(grep -n -E "${sta[${i}]}" stadump | cut -f1 -d: ) # find out what line number the station was listed in, used later when we modify the file
	let "i += 1"
	done
}

function Format() {
local i=1
local divider=" "

	while [ "${i}" -le "${sta_count}" ] # do this for as many times as there are stations
	do
	line=$(grep -e "${sta[${i}]}" stadump) # grab the line with the station bssid
	sed -i '/'"${sta[${i}]}"'/ s/.*/'"${line}\n        direcci&oacute;n IP:     \<b\>${sta_ip[${i}]}\<\/b\>\n        nombre host:      \<b\>${sta_hostname[${i}]}\<\/b\>\n        SSID Karma:     \<b\>${sta_ssid[${i}]}\<\/b\>"'/g' stadump
	#sed -i '/'"${sta[${i}]}"'/ i'"${divider}"'' ${DIR}/${FILE}
	let "i += 1"
	done
}

GetHosts
Format
cat stadump

