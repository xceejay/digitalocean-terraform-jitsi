#!/bin/bash
set +e
export DEBIAN_FRONTEND=noninteractive

app_id=domain
app_secret=5EBFFE148C696542D7B52F1024EB0055




setpass(){
  pass=$(grep PASSWORD /etc/jitsi/videobridge/sip-communicator.properties |awk -F '='  '{ print $2 }')
  curl --location --request GET "bev.domain.at/ajax/set_key?password=$pass"
}
setpass




# get domain
domain=$(grep  -E --color=never -m 1 -o '([a-z0-9]*|[a-z0-9]*-[a-z0-9]*).domainconf.net' /etc/jitsi/videobridge/sip-communicator.properties)

# remove  files we dont need any longer
#rm -rf  /usr/share/jitsi-meet/libs/app.bundle.min.js
#rm -rf /usr/share/jitsi-meet/images
##rm -rf /usr/share/jitsi-meet/css/all.css
#rm -rf /usr/share/jitsi-meet/interface_config.js
#rm -rf /usr/share/jitsi-meet/favicon.ico
#rm -rf /etc/jitsi/meet/$domain-config.js
#rm -rf /etc/prosody/prosody.cfg.lua
#rm -rf /etc/jitsi/videobridge/sip-communicator.properties
#rm -rf /usr/share/jicofo/jicofo.jar
#rm -rf /etc/jitsi/jicofo/sip-communicator.properties


# copy new files to right locations
cp -fr /tmp/app.bundle.min.js /usr/share/jitsi-meet/libs
cp -fr /tmp/images/* /usr/share/jitsi-meet/images/
#cp -fr /tmp/all.css /usr/share/jitsi-meet/css/all.css
cp -fr /tmp/interface_config.js /usr/share/jitsi-meet/interface_config.js
cp -fr /tmp/favicon.ico /usr/share/jitsi-meet/favicon.ico
cp -fr /tmp/*-config.js /etc/jitsi/meet/$domain-config.js
cp -fr /tmp/prosody.cfg.lua /etc/prosody/prosody.cfg.lua
cp -fr /tmp/sip-communicator.properties /etc/jitsi/videobridge/sip-communicator.properties
sshpass -p "sshpassword" rsync -rvz -e 'ssh -o StrictHostKeyChecking=no -p 22' --progress  code@apollo.domain.com:/jar/jicofo.jar /usr/share/jicofo/jicofo.jar


#cp -r /tmp/jicofo.jar /usr/share/jicofo/jicofo.jar
cp -fr /tmp/recorder.domain.cfg.lua /etc/prosody/conf.d/recorder.domain.cfg.lua
cp -fr /tmp/sip-communicator.properties /etc/jitsi/jicofo/sip-communicator.properties
#echo 'org.jitsi.jicofo.BridgeSelector.BRIDGE_SELECTION_STRATEGY=RegionBasedBridgeSelectionStrategy' >> /etc/jitsi/jicofo/sip-communicator.properties



# register jibri
prosodyctl register jibri auth.$domain $app_secret
prosodyctl register recorder recorder.domain.com $app_secret





