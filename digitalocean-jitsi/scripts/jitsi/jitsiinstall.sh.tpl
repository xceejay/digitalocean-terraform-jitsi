#!/bin/bash
set +e
export DEBIAN_FRONTEND=noninteractive
app_id=domain
app_secret=5EBFFE148C696542D7B52F1024EB0055
domain=${jitsi_domain}
ufw disable
# apt-get update
# apt-get -y upgrade

# hehe

#    curl --location --request GET "apollo.domain.com/jvb/set-pass?domain=$domain&password=notyet"

# check whether dns propagation suceeded
#checkpropagation(){
#while :
#do
# ping -c 1 $domain
# [ $? -eq 0 ] && break
#done
#}



openfirewallports(){
# open all necesarry ports

  yes|ufw enable
    ufw allow 10000:20000/udp
    ufw allow https
    ufw allow ssh
    ufw allow 433
    ufw allow 433/tcp
    ufw allow 5222/tcp
    ufw allow 5223/tcp
    ufw allow 4443/tcp
    ufw allow 5369/tcp
    ufw allow 8888/tcp
    ufw allow 5347/tcp
    ufw allow 443/tcp
    ufw allow 22/tcp
    ufw allow 5347/udp
    ufw allow 5347
    ufw allow 5222
    ufw allow 8080
    ufw allow 8888
}


installprosody(){
# install prosody
  echo deb http://packages.prosody.im/debian $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list
    wget https://prosody.im/files/prosody-debian-packages.key -O- | sudo apt-key add -
    apt-get update
    apt-get -y install prosody
}


installjitsi(){
# install jitsi meet
  wget https://download.jitsi.org/jitsi-key.gpg.key
    apt-key add jitsi-key.gpg.key
    echo 'deb https://download.jitsi.org stable/' > /etc/apt/sources.list.d/jitsi-stable.list
    apt-get update
    debconf-set-selections <<< $(echo 'jitsi-videobridge jitsi-videobridge/jvb-hostname string '$domain)
    debconf-set-selections <<< 'jitsi-meet-web-config   jitsi-meet/cert-choice  select  "Generate a new self-signed certificate"';
  apt-get -y install jitsi-meet
    echo joelkofiamoako@gmail.com |/usr/share/jitsi-meet/scripts/install-letsencrypt-cert.sh
}

# get jvb pass and set it
setpass(){
  pass="$(grep PASSWORD /etc/jitsi/videobridge/sip-communicator.properties |awk -F '='  '{ print $2 }')"
curl --location --request GET 'apollo.domain.com/jvb/set-pass?domain='"$domain"'&password='"$pass"''


}




# install jitsi web tokens
installtokens(){


while :
  do

    apt-get -y install luarocks
      apt-get -y install libssl1.0-dev
      apt-get -y install liblua5.2-dev

      debconf-set-selections <<< $(echo jitsi-meet-tokens 'jitsi-meet-tokens/appid string '$app_id)
      debconf-set-selections <<< $(echo jitsi-meet-tokens 'jitsi-meet-tokens/appsecret string '$app_secret)

      luarocks install luacrypto
      apt-get -y install jitsi-meet-tokens
# service prosody stop
# cd /usr/lib/prosody/modules
# mv mod_posix.lua mod_posix.old
# wget https://raw.githubusercontent.com/bjc/prosody/master/plugins/mod_posix.lua
# service prosody start
      apt-get -y purge jitsi-meet-tokens
      debconf-set-selections <<< $(echo jitsi-meet-tokens 'jitsi-meet-tokens/appid string '$app_id)
      debconf-set-selections <<< $(echo jitsi-meet-tokens 'jitsi-meet-tokens/appsecret string '$app_secret)
      apt-get -y install jitsi-meet-tokens
      luarocks remove --force lua-cjson 
      luarocks install lua-cjson 2.1.0-1

      break

      done

}
 local=$(hostname -I|awk '{print $2}')
 pub=$(hostname -I|awk '{print $1}')

checkpropagation
installprosody
installjitsi
setpass
echo "org.jitsi.videobridge.xmpp.user.shard.DISABLE_CERTIFICATE_VERIFICATION=true" >> /etc/jitsi/videobridge/sip-communicator.properties
#echo "org.jitsi.videobridge.octo.BIND_PORT=4096" >> /etc/jitsi/videobridge/sip-communicator.properties
#echo "org.jitsi.videobridge.octo.BIND_ADDRESS=$local" >> /etc/jitsi/videobridge/sip-communicator.properties
#echo "org.jitsi.videobridge.octo.PUBLIC_ADDRESS=$pub" >> /etc/jitsi/videobridge/sip-communicator.properties
#echo "org.jitsi.videobridge.REGION=world" >> /etc/jitsi/videobridge/sip-communicator.properties


#echo "org.jitsi.videobridge.PUBSUB_NODE=sharedStatsNode" >> /etc/jitsi/videobridge/sip-communicator.properties





#sed -i s/=muc/=pubsub/g /etc/jitsi/videobridge/sip-communicator.properties
sed -i s/localhost/$domain/g /etc/jitsi/videobridge/sip-communicator.properties
sed -i s/apis=,/apis=rest,colibri/g /etc/jitsi/videobridge/config
apt-get -y install sshpass
. /tmp/jitsiconfigure.sh
chmod 0755  /etc/jitsi/jicofo/sip-communicator.properties
installtokens
#openfirewallports
systemctl restart prosody.service jicofo.service jitsi-videobridge2.service
apt-get -y install prometheus
apt-get -y install prometheus-node-exporter

curl --location --request GET "apollo.domain.com/notify?domain=$domain"
