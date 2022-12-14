{
  // NOTE: this is a *SAMPLE* config file, it will need to be configured with
  // values from your environment
  // Where recording files should be temporarily stored
  "recording_directory": "/tmp/recordings",
  // The path to the script which will be run on completed recordings
  "finalize_recording_script_path": "/home/recordings/finalize.sh",
  "xmpp_environments": [
    {
      // A friendly name for this environment which can be used
      //  for logging, stats, etc.
      "name": "prod environment",
      // The hosts of the XMPP servers to connect to as part of
      //  this environment
      "xmpp_server_hosts": ["${jitsi_domain}"],
      // The xmpp domain we'll connect to on the XMPP server
      "xmpp_domain": "${jitsi_domain}",
      // Jibri will login to the xmpp server as a privileged user
      "control_login": {
        // The domain to use for logging in
        "domain": "auth.${jitsi_domain}",
        // The credentials for logging in
        "username": "jibri",
        "password": "5EBFFE148C696542D7B52F1024EB0055"
      },
      // Using the control_login information above, Jibri will join
      //  a control muc as a means of announcing its availability
      //  to provide services for a given environment
      "control_muc": {
        "domain": "internal.auth.${jitsi_domain}",
        "room_name": "JibriBrewery",
        "nickname": "jibriinstancec4b710bb"
      },
      // All participants in a call join a muc so they can exchange
      //  information.  Jibri can be instructed to join a special muc
      //  with credentials to give it special abilities (e.g. not being
      //  displayed to other users like a normal participant)
      "call_login": {
        "domain": "recorder.domain.com",
        "username": "recorder",
        "password": "5EBFFE148C696542D7B52F1024EB0055"
      },
      // When jibri gets a request to start a service for a room, the room
      //  jid will look like:
      //  roomName@optional.prefixes.subdomain.xmpp_domain
      // We'll build the url for the call by transforming that into:
      //  https://xmpp_domain/subdomain/roomName
      // So if there are any prefixes in the jid (like jitsi meet, which
      //  has its participants join a muc at conference.xmpp_domain) then
      //  list that prefix here so it can be stripped out to generate
      //  the call url correctly
      "room_jid_domain_string_to_strip_from_start": "conference.",
      // The amount of time, in minutes, a service is allowed to continue.
      //  Once a service has been running for this long, it will be
      //  stopped (cleanly).  A value of 0 means an indefinite amount
      //  of time is allowed
      "usage_timeout": "0"
    }
  ]
}

