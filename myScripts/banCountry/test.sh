#!/bin/bash
DATA=./GeoIPCountryWhois.csv
IPT=/sbin/iptables

# ban China
for IPRANGE in `egrep "China" $DATA | cut -d, -f1,2 | sed -e 's/"//g' | sed -e 's/,/-/g'`

do
         $IPT -A INPUT -p all -m iprange --src-range $IPRANGE -j DROP
done
