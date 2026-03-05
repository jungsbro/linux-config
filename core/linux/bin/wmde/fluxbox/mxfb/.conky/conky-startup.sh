#!/bin/sh

sleep 10s
killall -e -u $(id -nu) conky 2>/dev/null
cd "/usr/share/mx-conky-data/themes/MX-Infinity"
conky -c "/usr/share/mx-conky-data/themes/MX-Infinity/MX-Infinity-conkyrc" &
exit 0
