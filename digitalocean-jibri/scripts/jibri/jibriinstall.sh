#!/bin/bash


# set -e
export DEBIAN_FRONTEND=noninteractive
apt-get -y update
apt-get -y upgrade

sudo add-apt-repository ppa:jonathonf/ffmpeg-4  -y
apt-get -y update
apt-get -y install unzip
apt-get  install openjdk-8-jre-headless -y
apt-get install ffmpeg -y
apt-get install curl -y
apt-get install alsa-utils -y
apt-get install icewm -y
apt-get installl xdotool -y
apt-get install xserver-xorg-input-void -y
apt-get install xserver-xorg-video-dummy -y


useradd --create-home recordings
ufw disable
curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
apt-get -y update
apt-get -y install google-chrome-stable

mkdir -p /etc/opt/chrome/policies/managed


echo '{ "CommandLineFlagSecurityWarningsEnabled": false }' >>/etc/opt/chrome/policies/managed/managed_policies.json


CHROME_DRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`
wget -N http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P ~/
unzip ~/chromedriver_linux64.zip -d ~/
rm ~/chromedriver_linux64.zip
mv -f ~/chromedriver /usr/local/bin/chromedriver
chown root:root /usr/local/bin/chromedriver
chmod 0755 /usr/local/bin/chromedriver

wget -qO - https://download.jitsi.org/jitsi-key.gpg.key | apt-key add -
sh -c "echo 'deb https://download.jitsi.org stable/' > /etc/apt/sources.list.d/jitsi-stable.list"
apt-get -y update
apt-get install -y jibri
sudo usermod -aG adm,audio,video,plugdev jibri
systemctl enable jibri
apt-get install -y linux-image-extra-virtual
update-grub
echo "snd-aloop">>/etc/modules
modprobe snd-aloop
apt-get install awscli -y

rm /etc/jitsi/jibri/config.json
cp /tmp/config.json /etc/jitsi/jibri/config.json
cp /tmp/config.yml /home/recordings
cp /tmp/process-exporter /usr/bin
cp /tmp/process.service /etc/systemd/system
apt install -y prometheus
systemctl enable prometheus.service
systemctl enable process.service
/tmp/./chins.sh
systemctl restart jibri
cp /tmp/recordings.zip /home/recordings/
unzip /home/recordings/recordings.zip -d /home/recordings/
chmod 0755 /home/recordings/finalize.sh
echo "      - targets: ['localhost:9256']" >> /etc/prometheus/prometheus.yml

shutdown -r now



# i neet to fix the sed script for the server
# alternate of this is to copy file and replace remote file
# sed -i s/prod.xmpp.host.net/16gbtestserver.easyjitsi.com/g /etc/jitsi/jibri/config.json
# sed -i s/xmpp\\.domain/16gbtestserver.easyjitsi.com/g /etc/jitsi/jibri/config.json
# sed -i s/recorder\\.xmpp\\.domain/recorder.ddctalent.com/g /etc/jitsi/jibri/config.json
# sed -i s/auth\\.xmpp\\.domain/auth.16gbtestserver.easyjitsi.com/g /etc/jitsi/jibri/config.json
# sed  -i '26 s|: "username|: \"jibri|g' /etc/jitsi/jibri/config.json
# sed  -i '43 s|: "username|: \"recorder|g' /etc/jitsi/jibri/config.json
# sed  -i '27 s|: "password|: \"jibriauthpass|g' /etc/jitsi/jibri/config.json
# sed  -i '44 s|: "password|: \"jibrirecorderpass|g' /etc/jitsi/jibri/config.json

# sed -i 's/internal.auth.xmpp.domain/internal.auth.16gbtestserver.easyjitsi.com'/g /etc/jitsi/jibri/config.json
# sed -i 's/: "jibri-nickname/: \"jibriinstance1/g' /etc/jitsi/jibri/config.json
# sed  -i 's/: "\/path\/to\/finalize_recording.sh/: \"\/home\/recordings\/finalize.sh/g' /etc/jitsi/jibri/config.json




