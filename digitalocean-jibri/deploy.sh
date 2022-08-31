#!/bin/bash

set -e


arg1="$1"

[ -z "$arg1" ] && unset arg1

curdate=$(date -u +"%Y-%m-%d_%H:%M:%S:%s")
unixdate="$(date +%s)"

movetfstates(){
	mv terraform.tfstate  tfstates/terraform.tfstate$curdate
}

#changedomain(){
#	sed -i "15s|= .*|=\ \"$arg1\"|" variables.tf
#}

run(){
	echo yes | terraform apply -var="domain=$arg1"

}


addtodb(){
	terraform refresh
	id1=$(terraform output|awk -F "= " '{print $2}'|sed -n 1p)
	id2=$(terraform output|awk -F "= " '{print $2}'|sed -n 2p)
	ip1=$(terraform output|awk -F "= " '{print $2}'|sed -n 3p)
	ip2=$(terraform output|awk -F "= " '{print $2}'|sed -n 4p)
	curl --location --request GET 'apollo.domain.com/add-recorder?domain='"$arg1"'&ip='"$ip1"'&id='"$id1"''
	curl --location --request GET 'apollo.domain.com/add-recorder?domain='"$arg1"'&ip='"$ip2"'&id='"$id2"''
}
echo "deploying for $arg1..."
sleep 3;
echo "deploying for $arg1..."
sleep 3; # this will actually block the request for 3 seconds
echo "$arg1 | $curdate " >> log.txt

[ -z "$arg1" ] && exit 0

#[ -e terraform.tfstate ] &&
	[ -e terraform.tfstate ]  &&  movetfstates && rm -rf terraform.tfstate
run  && addtodb
