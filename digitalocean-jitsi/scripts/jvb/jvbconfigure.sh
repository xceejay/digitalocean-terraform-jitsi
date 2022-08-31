#!/bin/bash

while :
do
  [ "$(curl --location --request GET 'bev.upay.at/ajax/get_key')" != "notyet" ] && break
done

pass="$(curl --location --request GET 'bev.upay.at/ajax/get_key')"
nick="$(echo $RANDOM$(date -u +"%Y-%m-%dT%H:%M:%SZ") |sha224sum |awk '{print  $1}'|cut -c 1-8)"

#rm  -rf /etc/jitsi/videobridge/config
rm -rf /etc/jitsi/videobridge/sip-communicator.properties

#cp /tmp/config /etc/jitsi/videobridge/config
cp /tmp/sip-communicator.properties /etc/jitsi/videobridge/sip-communicator.properties


sed -i s/shardpassword/$pass/g /etc/jitsi/videobridge/sip-communicator.properties
sed -i s/jvbnickname/$nick/g /etc/jitsi/videobridge/sip-communicator.properties

curl --location --request GET 'bev.upay.at/ajax/set_key?password=notyet'
systemctl restart  jitsi-videobridge2.service


