#!/bin/bash


id=$(echo $RANDOM$(date -u +"%Y-%m-%dT%H:%M:%SZ") |sha224sum |awk '{print $1}'|cut -c 1-8)
sed -i s/jibriinstance[a-zA-Z0-9]*/jibriinstance"$id"/g /etc/jitsi/jibri/config.json
