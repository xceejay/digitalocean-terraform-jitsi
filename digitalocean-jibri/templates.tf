data "template_file" "jibri"{
  template =file("${path.module}/config/jibri/config.json.tpl")
  vars = {
    jitsi_domain=var.domain
  }

}


