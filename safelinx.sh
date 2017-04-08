#!/bin/bash

kdialog --textbox welcome 512 256

kdesudo --caption SafeLinx -d --comment "Enter sudo (Super User) password to scan your Bluetooth LE device." -c "sudo timeout -s SIGINT 5s hcitool lescan > hcitool.txt"

if [ "$?" = 1 ]; then
	exit
fi

tail -n +2 hcitool.txt > LE_list.txt

awk '{$1=""; print $0}' LE_list.txt > options.txt

rm LE_list.txt

sed -i '/(unknown)/d' ./options.txt

DEV1=$(awk 'NR==1' options.txt)
DEV2=$(awk 'NR==2' options.txt)
DEV3=$(awk 'NR==3' options.txt)
DEV4=$(awk 'NR==4' options.txt)
DEV5=$(awk 'NR==5' options.txt)
CHOICE=

if [ -z "$DEV1" ]
then
    rm options.txt
    kdialog --title "SafeLinx" --error "No devices found.";
    exit
elif [ -z "$DEV2" ]
then
    CHOICE=$(kdialog --title "SafeLinx" --radiolist "1 device found. Select your device:" 1 "$DEV1" on)
elif [ -z "$DEV3" ]
then
    CHOICE=$(kdialog --title "SafeLinx" --radiolist "2 devices found. Select your device:" 1 "$DEV1" on 2 "$DEV2" off)
elif [ -z "$DEV4" ]
then
    CHOICE=$(kdialog --title "SafeLinx" --radiolist "3 devices found. Select your device:" 1 "$DEV1" on 2 "$DEV2" off 3 "$DEV3" off)
elif [ -z "$DEV5" ]
then
    CHOICE=$(kdialog --title "SafeLinx" --radiolist "4 devices found. Select your device:" 1 "$DEV1" on 2 "$DEV2" off 3 "$DEV3" off 4 "$DEV4" off)
elif [ -z "$DEV6" ]
then
    CHOICE=$(kdialog --title "SafeLinx" --radiolist "5 devices found. Select your device:" 1 "$DEV1" on 2 "$DEV2" off 3 "$DEV3" off 4 "$DEV4" off 5 "$DEV5" off)
else
    kdialog --title "SafeLinx" --error "Error @ Device select ladder";
    exit
fi

if [ -z "$CHOICE" ]
then
    exit
elif [ $CHOICE -eq 1 ]
then
    DEV=$DEV1
elif [ $CHOICE -eq 2 ]
then
    DEV=$DEV2
elif [ $CHOICE -eq 3 ]
then
    DEV=$DEV3
elif [ $CHOICE -eq 4 ]
then
    DEV=$DEV4
elif [ $CHOICE -eq 5 ]
then
    DEV=$DEV5
else
    kdialog --title "SafeLinx" --error "Error @ Choice select ladder";
    exit
fi

MAC=$(grep "$DEV" hcitool.txt | awk '{print $1;}')

rm options.txt


TELE_USER=$(kdialog --inputbox "Added @liftybot to Telegram? Give us your username (without @):");

if [ -z "$TELE_USER" ]; then
	echo TELE_USER not added
else
	kdialog --msgbox "We'll notify you at Telegram";
fi

echo Polling $DEV

while [ true ]
do
    set -x
	sh poll.sh $DEV $MAC $TELE_USER
    set +x
done


exit
