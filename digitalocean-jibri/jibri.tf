
resource "digitalocean_tag" "jibritag" {
  name = "recorder"
}

resource "digitalocean_droplet" "recorder" {
  count       = var.jibcnt
  image  = "ubuntu-18-04-x64"
  name   = join("-",[var.domain,"recorder"])
  region = "nyc1"
  size   = "c-2"
  tags   = [digitalocean_tag.jibritag.id]


  # lifecycle {
  # prevent_destroy = true

  # }

  ssh_keys=[

    "48:dd:35:37:1e:81:1c:62:c1:08:01:e1:3d:98:ea:af",
    "d5:31:c1:00:c9:ff:52:67:98:9a:a8:80:a3:b9:3a:e6",
    "b6:35:38:85:eb:f7:41:31:05:9d:e2:ca:31:63:f8:8d"
  ]


  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = "${file(var.pvt_key)}"
    timeout     = "2m"
  }


  provisioner "file" {
    source      = "/home/code/projects/terraform.domain.com/digitalocean-jibri/config/jibri/"
    destination = "/tmp/"
  }


  provisioner "file" {
    source      = "/home/code/projects/terraform.domain.com/digitalocean-jibri/scripts/jibri/"
    destination = "/tmp/"
  }




  provisioner "file" {
    content     = "${data.template_file.jibri.rendered}"
    destination = "/tmp/config.json"
  }


  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/jibriinstall.sh",
      "chmod +x /tmp/chins.sh",
      "chmod +x /tmp/process-exporter",
      "tmux new-session -d -s jibri 'bash /tmp/jibriinstall.sh'"

    ]

  }


}



output "id1" {

  value = "${digitalocean_droplet.recorder[0].id}"
}
output "id2" {

  value = "${digitalocean_droplet.recorder[1].id}"
}

output "ip1" {

  value = "${digitalocean_droplet.recorder[0].ipv4_address}"
}
output "ip2" {

  value = "${digitalocean_droplet.recorder[1].ipv4_address}"
}


