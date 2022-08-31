
variable "pvt_key" {
  default="/home/code/.ssh/id_rsa"
}
variable "pub_key" {
  default="/home/code/.ssh/id_rsa.pub"
}

variable "jibcnt"{
  default = 2 # jibris
}

variable "domain"{
  type = string
  default = "dev.domainconf.net"
}
