
resource "digitalocean_droplet" "jvb" {
  count  = var.jvbcnt
  image  = "ubuntu-18-04-x64"
  name   = join("-",[var.cluster,"jvb-${count.index}"])
  region = "nyc1"
  size   = "c-8"
  tags   = [digitalocean_tag.jvbtag.id]

  #lifecycle {
  # prevent_destroy = true
  #}


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

  provisioner "file" {

    content     = "${data.template_file.jvb_sip.rendered}"
    destination = "/tmp/sip-communicator.properties"

  }
  #provisioner "file" {

  #  content     = "${data.template_file.jvb_config.rendered}"
  #  destination = "/tmp/config"

  #}





}

resource "digitalocean_tag" "jvbtag" {
  name = "video-bridge"
}


resource "null_resource" "jvb_install" {

  count  = var.jvbcnt

  triggers = {
    jitsi_arecord_record_fqdn = null_resource.jitsi_exec.id
  }

  connection {
    host        = digitalocean_droplet.jvb[count.index].ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = "${file(var.pvt_key)}"
    timeout     = "2m"

  }


  provisioner "file" {
    source      = "/home/joel/Desktop/work/src/deploy.domain.com/digitalocean-jitsi/config/jvb/"
    destination = "/tmp/"
  }



  provisioner "file" {
    source      = "/home/joel/Desktop/work/src/deploy.domain.com/digitalocean-jitsi/scripts/jvb/"
    destination = "/tmp/"
  }




  provisioner "file" {

    content     = "${data.template_file.jvb_install.rendered}"
    destination = "/tmp/jvbinstall.sh"

  }


}


resource "null_resource" "jvb_exec" {

  count  = var.jvbcnt
  triggers = {
    jvbexec = null_resource.jvb_install[count.index].id
  }





  connection {
    host        = digitalocean_droplet.jvb[count.index].ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = "${file(var.pvt_key)}"
    timeout     = "2m"

  }




  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/jvbconfigure.sh",
      "chmod +x /tmp/jvbinstall.sh",
      "tmux new-session -d -s install 'bash /tmp/jvbinstall.sh'",
    ]
  }


}
