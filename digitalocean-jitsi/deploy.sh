#!/bin/bash

print_err(){
  echo "some options require arguments"
  echo "Try ./deploy.sh --help for more information"

}

print_usage() {

  echo "OPTIONS:"
  echo "-j [NUM]"
  echo "count of video bridges"
  echo ""
  echo "-r [NUM]"
  echo "count of jibri recorders"
  echo ""
  echo "-d [URL]"
  echo "domain to be deployed "
  echo ""
  echo ""
  echo "USAGE:"
  echo "./deploy.sh -j 1 -r 2 -d jitsi.gnu.org"
  echo ""
  echo "this deploys one video bridge, 2 recorders and one jitsi server to the jitsi.gnu.org domain"
}

curdate=$(date -u +"%Y-%m-%d_%H:%M:%S:%s")

movetfstates(){

cp terraform.tfstate        tfstates/terraform.tfstate$curdate
cp terraform.tfstate.backup tfstates/terraform.tfstate.backup$curdate
rm -f terraform.tfstate
rm  -f terraform.tfstate.backup
terraform import digitalocean_domain.default domainconf.net

}

changevars(){
grep videobridges variables.tf |awk -F '=' '{print $2}'|awk '{print $1}'
grep jibris variables.tf |awk -F '=' '{print $2}'|awk '{print $1}'
}



jvbcount(){


  _
}
jibricount(){
  _

}

run(){
  terraform apply

}


arg1="$1"

while getopts ":j:r:d:" o; do
  case "$o" in
    j)
      jvb=$OPTARG
      ;;
    r)
      jibri=$OPTARG
      ;;
    d)
      domain=$OPTARG
      ;;
    *)
      ;;
  esac
done
shift $((OPTIND-1))


[ "$arg1" = "--help" ]  && print_usage
 [ "$arg1" = "--help" ] && exit 0 || [ -z "$jvb" ] || [ -z "$jibri" ]  || [ -z "$domain" ] && print_err && exit 0
#echo "s = $s"
#echo "p = $p"

