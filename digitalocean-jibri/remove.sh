#!/bin/bash

#echo yes | terraform destroy
#cp terraform.tfstate        tfstates/terraform.tfstate$curdate

#rm -f terraform.tfstate
#rm -f terraform.tfstate.backup

#doctl compute droplet list |  grep  -o -f active |xargs -n 1 doctl  compute droplet delete  --force


doctl  compute droplet delete  $1 --force
curl --location --request GET 'apollo.domain.com/remove-recorder?id='"$1"''
#> active
