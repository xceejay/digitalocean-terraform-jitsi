#!/bin/bash


domain=${jitsi_domain}

# check whether dns propagation suceeded
#while :
#do
  #[ $? -eq 0 ] && break
#done

sleep 3m

echo 'deb https://download.jitsi.org stable/' >> /etc/apt/sources.list.d/jitsi-stable.list
wget -qO -  https://download.jitsi.org/jitsi-key.gpg.key | apt-key add -
apt-get install apt-transport-https
apt update
ufw status
ufw allow ssh
ufw allow 443/tcp
ufw allow 4443/tcp
ufw allow 10000:20000/udp
yes|ufw enable
ufw allow 5222/tcp
ufw reload

local=$(hostname -I|awk '{print $2}')
pub=$(hostname -I|awk '{print $1}')


debconf-set-selections <<< $(echo 'jitsi-videobridge jitsi-videobridge/jvb-hostname string '$domain)

apt -y install jitsi-videobridge2

#/tmp/./jvbconfigure.sh

#while :
#do
# [ "$(curl --location --request GET "apollo.domain.com/jvb/get-pass?domain=$domain")" != "notyet" ] && break
#done

pass=$(curl --location --request GET 'apollo.domain.com/jvb/get-pass?domain='"$domain"'')

nick="$(echo $RANDOM$(date -u +"%Y-%m-%dT%H:%M:%SZ") |sha224sum |awk '{print  $1}'|cut -c 1-8)"

#rm  -rf /etc/jitsi/videobridge/config
rm -rf /etc/jitsi/videobridge/sip-communicator.properties

#cp /tmp/config /etc/jitsi/videobridge/config
cp /tmp/sip-communicator.properties /etc/jitsi/videobridge/sip-communicator.properties

sed -i s/shardpassword/$pass/g /etc/jitsi/videobridge/sip-communicator.properties
sed -i s/jvbnickname/$nick/g /etc/jitsi/videobridge/sip-communicator.properties
#echo "org.jitsi.videobridge.octo.BIND_ADDRESS=$local" >> /etc/jitsi/videobridge/sip-communicator.properties
#echo "org.jitsi.videobridge.octo.PUBLIC_ADDRESS=$pub" >> /etc/jitsi/videobridge/sip-communicator.properties
sed -i s/apis=,/apis=rest,colibri/g /etc/jitsi/videobridge/config

ufw disable
systemctl restart  jitsi-videobridge2.service


