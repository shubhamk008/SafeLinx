#!/bin/bash

# $1: Device name (Eg: Gear S2)
# $2: MAC address (Eg: 32:32:32:32:23:23)
# $3: TELE_USER (Eg: shubhamk008)

touch tele_flag.txt

sudo timeout -s SIGINT 5s hcitool lescan > hcitool_poll.txt

if grep -q "$2" hcitool_poll.txt; then
    echo $1 in range
    echo 0 > tele_flag.txt
    cat tele_flag.txt
else
    echo $DEV not in range
    kdialog --title "Locking Computer..." --passivepopup "Your $1 is out of range" 5;
    if [ ! -z "$3" ]
    then
        echo Sending telegram to $3
        if grep -q "0" tele_flag.txt; then
            # Telegram Notification
            echo Curling
            curl -s "https://api.telegram.org/bot322810060:AAF6u26_Vd6Jv5cnapTAyNyC89ZQS5QgYyc/getUpdates" | grep $3 | head -1 | grep -oh "\"id\":........." | cut -c6- | head -1 > tele_id.txt
            (echo "Your $1 is out of range." ; echo ; echo \> $USER locked from $(sudo dmidecode -s system-manufacturer) $(sudo dmidecode -s baseboard-version) ; echo \> $(date '+%H:%M:%S %d/%m/%y')) | ./tele_send.sh
        else
            echo No telegram
        fi
    fi
    sleep 5;
    qdbus org.freedesktop.ScreenSaver /ScreenSaver Lock
    echo 1 > tele_flag.txt
    cat tele_flag.txt
fi


exit
