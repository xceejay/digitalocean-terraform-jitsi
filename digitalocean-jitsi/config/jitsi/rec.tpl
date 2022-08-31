-- internal muc component, meant to enable pools of jibri and jigasi clients
Component "internal.auth.${jitsi_domain}" "muc"
    modules_enabled = {
      "ping";
    }
    storage = "memory"
    muc_room_cache_size = 1000


VirtualHost "recorder.domain.com"
  modules_enabled = {
    "ping";
  }
  authentication = "internal_plain"
