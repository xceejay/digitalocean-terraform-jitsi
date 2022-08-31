#!/bin/bash
set +e
sleep 30
luarocks remove --force lua-cjson
luarocks install lua-cjson 2.0.0-1
systemctl restart prosody.service jicofo.service jitsi-videobridge2.service



