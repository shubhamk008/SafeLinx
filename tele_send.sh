#!/bin/sh

message=$( cat )

TELE_ID=$(cat tele_id.txt)

sendTelegram() {
        curl -s \
        -X POST \
        https://api.telegram.org/bot322810060:AAF6u26_Vd6Jv5cnapTAyNyC89ZQS5QgYyc/sendMessage \
        -d text="$message" \
        -d chat_id="$TELE_ID"
}

if  [ -z "$message" ]
then
	echo "Please pipe a message to me!"
else
        sendTelegram
fi

exit
