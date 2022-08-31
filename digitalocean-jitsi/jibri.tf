
resource "digitalocean_tag" "jibritag" {
  name = "recorder"
}

resource "digitalocean_droplet" "recorder" {
  count       = var.jibcnt
  image  = "ubuntu-18-04-x64"
  name   = join("-",[var.cluster,"recorder-${count.index}"])
  region = "nyc1"
  size   = "c-2"
  tags   = [digitalocean_tag.jibritag.id]


  # lifecycle {
  # prevent_destroy = true

  # }

  ssh_keys=[

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




resource "null_resource" "jibri_install" {

  count       = var.jibcnt
  triggers = {
    jitsi_arecord_record_fqdn = digitalocean_droplet.jitsi_arecord.id
  }

  connection {
    host        = digitalocean_droplet.recorder[count.index].ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = "${file(var.pvt_key)}"
    timeout     = "2m"
  }


  provisioner "file" {
    source      = "/home/joel/Desktop/work/src/deploy.domain.com/digitalocean-jitsi/scripts/jibri/"
    destination = "/tmp/"
  }


  provisioner "file" {
    source      = "/home/joel/Desktop/work/src/deploy.domain.com/digitalocean-jitsi/config/jibri/"
    destination = "/tmp/"
  }




  provisioner "file" {
    content     = "${data.template_file.jibri.rendered}"
    destination = "/tmp/config.json"
  }




}


resource "null_resource" "jibri_exec" {

  count       = var.jibcnt

  triggers ={
    jibri_exec = null_resource.jibri_install[count.index].id
  }

  connection {
    host        = digitalocean_droplet.recorder[count.index].ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = "${file(var.pvt_key)}"
    timeout     = "2m"
  }




  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/jibriinstall.sh",
      "chmod +x /tmp/chins.sh",
      "tmux new-session -d -s jibri 'bash /tmp/jibriinstall.sh'"

    ]

  }



}

