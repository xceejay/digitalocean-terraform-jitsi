resource "digitalocean_tag" "jitsitag" {
  name = "jitsi-server"
}

resource "digitalocean_domain" "default" {
  lifecycle {

    prevent_destroy = true

     }



  name = "domainconf.net"


}

resource "digitalocean_record" "jitsi_arecord" {

     lifecycle {

  prevent_destroy = true
  }





  domain = digitalocean_domain.default.name
  type   = "A"
  name   = var.cluster
  value  = digitalocean_droplet.jitsi_arecord.ipv4_address
}


resource "digitalocean_droplet" "jitsi_arecord" {
  lifecycle {

     prevent_destroy = true

    }



  image  = "ubuntu-18-04-x64"
  name   = var.cluster
  region = "nyc1"
  size   = "c-32"
  tags   = [digitalocean_tag.jitsitag.id]

  ssh_keys = [
    "48:dd:35:37:1e:81:1c:62:c1:08:01:e1:3d:98:ea:af",
    "d5:31:c1:00:c9:ff:52:67:98:9a:a8:80:a3:b9:3a:e6"
  ]

  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = "${file(var.pvt_key)}"
    timeout     = "2m"
  }
}

resource "null_resource" "jitsi_install" {
  triggers = {
    jitsi_arecord_record_fqdn = digitalocean_droplet.jitsi_arecord.id
  }


  connection {
    host        = digitalocean_droplet.jitsi_arecord.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = "${file(var.pvt_key)}"
    timeout     = "3m"
  }


  provisioner "file" {
    source      = "/home/joel/Desktop/work/src/deploy.domain.com/digitalocean-jitsi/config/jitsi/"
    destination = "/tmp/"
  }

  provisioner "file" {
    source      = "/home/joel/Desktop/work/src/deploy.domain.com/digitalocean-jitsi/scripts/jitsi/"
    destination = "/tmp/"
  } 

  provisioner "file" {
    content     = "${data.template_file.jitsi_jibri_config.rendered}"
    destination = "/tmp/recorder.domain.cfg.lua"
  }

  provisioner "file" {
    content     = "${data.template_file.jitsi_config.rendered}"
    destination = "/tmp/${digitalocean_record.jitsi_arecord.fqdn}-config.js"
  }

  provisioner "file" {
    content     = "${data.template_file.jicofo_sip.rendered}"
    destination = "/tmp/sip-communicator.properties"
  }
  provisioner "file" {
    content     = "${data.template_file.jitsi_install.rendered}"
    destination = "/tmp/jitsiinstall.sh"
  }


  #provisioner "file" {
  # content     = "${data.template_file.jitsi_jvb_config.rendered}"
  #  destination = "/tmp/config"
  # }


}



resource "null_resource" "jitsi_exec" {

  triggers = {
    exec_done= null_resource.jitsi_install.id
  }


  connection {
    host        = digitalocean_droplet.jitsi_arecord.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = "${file(var.pvt_key)}"
    timeout     = "2m"
  }


  provisioner "remote-exec"{
    inline=[
      "chmod +x /tmp/jitsiinstall.sh",
      "chmod +x /tmp/jitsiconfigure.sh",
      "chmod +x /tmp/jitsifinish.sh",
      #"bash /tmp/jitsiinstall.sh",
      "tmux new-session -d -s install 'bash /tmp/jitsiinstall.sh'",
    ]


  } 
}



