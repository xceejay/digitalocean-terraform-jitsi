
variable "pvt_key" {
  default="/home/joel/.ssh/id_rsa"

}


variable "pub_key" {
  default="/home/joel/.ssh/id_rsa.pub"
}


variable "cluster" {
  type= string
  default="xx1"
}


variable "jvbcnt"{
default= 2
}

variable "jibcnt"{
default= 0
}
