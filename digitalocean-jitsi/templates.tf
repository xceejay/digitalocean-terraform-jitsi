data "template_file" "jibri"{
  template =file("${path.module}/config/jibri/config.json.tpl")
  vars = {
    jitsi_domain="${digitalocean_record.jitsi_arecord.fqdn}"
  }

}

data "template_file" "jitsi_jibri_config"{
  template =file("${path.module}/config/jitsi/rec.tpl")

  vars = {
    jitsi_domain="${digitalocean_record.jitsi_arecord.fqdn}"
  }

}


data "template_file" "jitsi_config"{
  template =file("${path.module}/config/jitsi/domain-config.js.tpl")

  vars = {
    jitsi_domain="${digitalocean_record.jitsi_arecord.fqdn}"
  }

}



data "template_file" "jvb_config"{
  template =file("${path.module}/config/jvb/jvbconfig.tpl")

  vars = {
    jitsi_domain="${digitalocean_record.jitsi_arecord.fqdn}"
  }

}

data "template_file" "jicofo_sip"{
  template =file("${path.module}/config/jitsi/jicofosip.tpl")
  vars = {
    jitsi_domain="${digitalocean_record.jitsi_arecord.fqdn}"
  }

}


data "template_file" "jvb_sip"{
  template =file("${path.module}/config/jvb/jvbsip.tpl")

  vars = {
    jitsi_domain="${digitalocean_record.jitsi_arecord.fqdn}"
  }

}


data "template_file" "jitsi_jvb_config"{
  template =file("${path.module}/config/jvb/jvbconfig.tpl")

  vars = {
    jitsi_domain="${digitalocean_record.jitsi_arecord.fqdn}"
  }

}

data "template_file" "jitsi_install"{
  template =file("${path.module}/scripts/jitsi/jitsiinstall.sh.tpl")

  vars = {
    jitsi_domain="${digitalocean_record.jitsi_arecord.fqdn}"
  }

}


data "template_file" "jvb_install"{
  template =file("${path.module}/scripts/jvb/jvbinstall.sh.tpl")

  vars = {
    jitsi_domain="${digitalocean_record.jitsi_arecord.fqdn}"
  }

}
