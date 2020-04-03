plugin_paths = { "/usr/share/jitsi-meet/prosody-plugins/" }

-- domain mapper options, must at least have domain base set to use the mapper
muc_mapper_domain_base = "groupmeet.calvary.church";

turncredentials_secret = "5FnzTEIe";

turncredentials = {
  { type = "stun", host = "groupmeet.calvary.church", port = "443" },
  { type = "turn", host = "groupmeet.calvary.church", port = "443", transport = "udp" },
  { type = "turns", host = "groupmeet.calvary.church", port = "443", transport = "tcp" }
};

cross_domain_bosh = false;
consider_bosh_secure = true;

VirtualHost "groupmeet.calvary.church"
        -- enabled = false -- Remove this line to enable this host
        authentication = "anonymous"
        -- Properties below are modified by jitsi-meet-tokens package config
        -- and authentication above is switched to "token"
        --app_id="example_app_id"
        --app_secret="example_app_secret"
        -- Assign this host a certificate for TLS, otherwise it would use the one
        -- set in the global section (if any).
        -- Note that old-style SSL on port 5223 only supports one certificate, and will always
        -- use the global one.
        ssl = {
                key = "/etc/prosody/certs/groupmeet.calvary.church.key";
                certificate = "/etc/prosody/certs/groupmeet.calvary.church.crt";
        }
        speakerstats_component = "speakerstats.groupmeet.calvary.church"
        conference_duration_component = "conferenceduration.groupmeet.calvary.church"
        -- we need bosh
        modules_enabled = {
            "bosh";
            "pubsub";
            "ping"; -- Enable mod_ping
            "speakerstats";
            "turncredentials";
            "conference_duration";
        }
        c2s_require_encryption = false

Component "conference.groupmeet.calvary.church" "muc"
    storage = "none"
    modules_enabled = {
        "muc_meeting_id";
        "muc_domain_mapper";
        -- "token_verification";
    }
    admins = { "focus@auth.groupmeet.calvary.church" }

-- internal muc component
Component "internal.auth.groupmeet.calvary.church" "muc"
    storage = "none"
    modules_enabled = {
      "ping";
    }
    admins = { "focus@auth.groupmeet.calvary.church", "jvb@auth.groupmeet.calvary.church" }

VirtualHost "auth.groupmeet.calvary.church"
    ssl = {
        key = "/etc/prosody/certs/auth.groupmeet.calvary.church.key";
        certificate = "/etc/prosody/certs/auth.groupmeet.calvary.church.crt";
    }
    authentication = "internal_plain"

Component "focus.groupmeet.calvary.church"
    component_secret = "T5JMTlAw"

Component "speakerstats.groupmeet.calvary.church" "speakerstats_component"
    muc_component = "conference.groupmeet.calvary.church"

Component "conferenceduration.groupmeet.calvary.church" "conference_duration_component"
    muc_component = "conference.groupmeet.calvary.church"
