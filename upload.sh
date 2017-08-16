#!/bin/sh

#set -x

date

gpioctl dirout 16

OUT=`/root/checkHumidity 1 DHT22`

gpioctl dirin 16

HUMIDITY=`echo $OUT | cut -d " " -f1`
TEMP=`echo $OUT | cut -d " " -f2`

echo $TEMP
echo $HUMIDITY

if [ "$TEMP" == "-255.000000" ] || [ "$HUMIDITY" == "-255.000000"  ]; then
        gpioctl dirout 17
        sleep 5
        gpioctl dirin 17
        exit 11
fi

gpioctl dirout 15

curl -m 40 -d "api_key=${API_KEY}&field1=${TEMP}&field2=${HUMIDITY}" https://api.thingspeak.com/update -k

gpioctl dirin 15

