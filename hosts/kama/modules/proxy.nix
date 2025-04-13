{ options, config, pkgs, ... }:
let
  tunName = "tun0";
in
{
  networking.firewall.allowedTCPPorts = [ 1080 1081 1082 ];
  networking.firewall.allowedUDPPorts = [ 1080 1081 1082 ];
  networking.firewall.trustedInterfaces = [ tunName ];

  services.zapret = {
    enable = true;
    params =   [
      "--dpi-desync=fake,disorder2"
      "--dpi-desync-ttl=1"
      "--dpi-desync-autottl=2"
    ];
    whitelist = [
      "youtube.com"
      "googlevideo.com"
      "ytimg.com"
      "youtu.be"
    ];
  };

  services.sing-box = {
    enable = true;
    settings = {
      "log" = {
        "level" = "info";
        "timestamp" = true;
      };

      "dns" = {
        "servers" = [
          {
            "tag" = "local-dns";
            "address" = "127.0.0.1";
            "detour" = "direct-out";
          }
          {
            "tag" = "cloudflare-dns";
            "address" = "https://1.1.1.1/dns-query";
            "address_resolver" = "local-dns";
            "detour" = "vless-out"; 
          }
        ];
        "rules" = [
          {
            "domain" = "volga";
            "server" = "local-dns";
          }
          {
            "rule_set" = "antizapret";
            "server" = "cloudflare-dns";
          }
        ];
      };
      "inbounds" = [
        # {
        #   "tag" = "tun-in";
        #   "type" = "tun";
        #   "address" = [
        #     "172.16.0.1/30"
        #     "fd00::1/126"
        #   ];
        #   "mtu" = 1500;
        #   "auto_route" = true;
        #   "strict_route" = true;
        #   "domain_strategy" = "";
        #   "sniff" = true;
        #   "sniff_override_destination" = false;
        #   "stack" = "system";
        #   "interface_name" = tunName;
        # }
        {
          "type" = "mixed";
          "tag" = "mixed-in";
          "listen" = "::";
          "listen_port" = 1080;
          "sniff" = true;
          "domain_strategy" = "prefer_ipv4";
        }
        {
          "type" = "socks"; 
          "tag" = "socks-in";
          "listen" = "::";
          "listen_port" = 1081;
          "tcp_fast_open" = true;
          "tcp_multi_path" = true;
          "domain_strategy" = "prefer_ipv4";
        }
      ];
      "outbounds" = [
        {
          "type" = "vless";
          "tag" = "vless-out";
          "server" = { _secret = config.age.secrets.singbox_vless_server.path; };
          "server_port" = 443;
          "uuid" = { _secret = config.age.secrets.singbox_vless_uuid.path; };
          #"flow" = "xtls-rprx-vision";
          #"packet_encoding" = "tcp";
          "tls" = {
            "enabled" = true;
            "server_name" = "teamdocs.su";
            "utls" = {
              "enabled" = true;
              "fingerprint" = "chrome";
            };
            "reality" = {
              "enabled" = true;
              "public_key" = { _secret = config.age.secrets.singbox_vless_public_key.path; };
              "short_id" = { _secret = config.age.secrets.singbox_vless_short_id.path; };
            };
          };
        }
        {
          "type" = "direct";
          "tag" = "direct-out";
        }
        {
          "type" = "dns";
          "tag" = "dns-out";
        }
      ];
      "route" = {
        "rules" = [
          {
            "domain_suffix" = ".youtube.com";
            "inbound" = "mixed-in";
            "outbound" = "direct-out";
          }
          {
            "domain_suffix" = ".googlevideo.com";
            "inbound" = "mixed-in";
            "outbound" = "direct-out";
          }
          {
            "domain_suffix" = ".youtu.be";
            "inbound" = "mixed-in";
            "outbound" = "direct-out";
          }
          {
            "domain" = "readme.io";
            "outbound" = "vless-out";
          }
          {
            "domain" = "nrzr.li";
            "outbound" = "vless-out";
          }
          {
            "domain_suffix" = "cachix.org";
            "outbound" = "vless-out";
          }
          {
            "domain_suffix" = "2ch.hk";
            "outbound" = "vless-out";
          }
          {
            "domain_suffix" = "autodesk.com";
            "outbound" = "vless-out";
          }
          {
            "domain_suffix" = "printables.com";
            "outbound" = "direct-out";
          }
          {
            "domain_suffix" = "coursera.org";
            "outbound" = "vless-out";
          }
          {
            "domain_suffix" = "spotify.com";
            "outbound" = "vless-out";
          }
          {
            "domain_suffix" = ".fedorapeople.org";
            "outbound" = "vless-out";
          }
          {
            "domain_suffix" = ".yeggi.com";
            "outbound" = "vless-out";
          }
          {
            "domain_suffix" = "twitch.tv";
            "outbound" = "vless-out";
          }
          {
            "domain_suffix" = ".unpkg.com";
            "outbound" = "vless-out";
          }
          {
            "domain_suffix" = ".1e100.net";
            "outbound" = "vless-out";
          }
          {
            "domain_suffix" = ".gvt1.com";
            "outbound" = "vless-out";
          }
          {
            "domain_suffix" = ".gstatic.com";
            "outbound" = "vless-out";
          }
          {
            "domain_regex" = "^(?:[\\w-]+\\.)*beeline\\.kg";
            "outbound" = "vless-out";
          }
          {
            "domain_regex" = "^(?:[\\w-]+\\.)*edx\\.org";
            "outbound" = "vless-out";
          }
          {
            "domain_regex" = "^(?:[\\w-]+\\.)*discord\\.*";
            "outbound" = "vless-out";
          }
          {
            "domain_regex" = "^(?:[\\w-]+\\.)*unipile\\.com";
            "outbound" = "vless-out";
          }
          {
            "domain" = "discord.com";
            "outbound" = "vless-out";
          }
          {
            "domain" = "discord.gg";
            "outbound" = "vless-out";
          }
          {
            "domain_suffix" = ".discord.gg";
            "outbound" = "vless-out";
          }
          {
            "domain_suffix" = ".discord.com";
            "outbound" = "vless-out";
          }
          {
            "domain" = "myip.ru";
            "outbound" = "vless-out";
          }
          {
            "domain" = "google.dev";
            "outbound" = "vless-out";
          }
          {
            "domain_suffix" = "aistudio.google.com";
            "outbound" = "vless-out";
          }
          {
            "domain" = "gemini.google.com";
            "outbound" = "vless-out";
          }
          {
            "domain_suffix" = ".salesloop.io";
            "outbound" = "vless-out";
          }
          {
            "domain_suffix" = ".discordapp.com";
            "outbound" = "vless-out";
          }
          {
            "domain_suffix" = ".vmware.com";
            "outbound" = "vless-out";
          }
          {
            "domain" = "gemini.google.com";
            "outbound" = "vless-out";
          }
          {
            "domain_regex" = "^(?:[\\w-]+\\.)*linear\\.app";
            "outbound" = "vless-out";
          }
          {
            "domain_regex" = "^(?:[\\w-]+\\.)*digitalocean\\.com";
            "outbound" = "vless-out";
          }
          {
            "domain_regex" = "^(?:[\\w-]+\\.)*noodlemagazine\\.com";
            "outbound" = "vless-out";
          }
          {
            "domain_regex" = "^(?:[\\w-]+\\.)*rutracker\\.org";
            "outbound" = "vless-out";
          }
          {
            "domain_regex" = "^(?:[\\w-]+\\.)*sentry\\.io";
            "outbound" = "vless-out";
          }
          {
            "domain_regex" = "^(?:[\\w-]+\\.)*linkedin\\.com";
            "outbound" = "vless-out";
          }
          {
            "domain_regex" = "^(?:[\\w-]+\\.)*microsoft\\.com";
            "outbound" = "vless-out";
          }
          {
            "domain_suffix" = ".openai.com";
            "outbound" = "vless-out";
          }
          {
            "domain_regex" = "^(?:[\\w-]+\\.)*awsapps\\.com";
            "outbound" = "vless-out";
          }
          {
            "domain_regex" = "^(?:[\\w-]+\\.)*amazon\\.com";
            "outbound" = "vless-out";
          }
          {
            "domain_regex" = "^(?:[\\w-]+\\.)*nixos\\.org";
            "outbound" = "vless-out";
          }
          {
            "domain" = "chatgpt.com";
            "outbound" = "vless-out";
          }
          {
            "domain_suffix" = ".chatgpt.com";
            "outbound" = "vless-out";
          }
          {
            "domain_suffix" = ".anthropic.com";
            "outbound" = "vless-out";
          }
          {
            "domain_suffix" = ".claude.ai";
            "outbound" = "vless-out";
          }
          {
            "domain_suffix" = ".oracle.com";
            "outbound" = "vless-out";
          }
          {
            "domain_suffix" = ".trycloudflare.com";
            "outbound" = "vless-out";
          }
          {
            "domain_suffix" = ".githubusercontent.com";
            "outbound" = "vless-out";
          }
          {
            "domain_suffix" = ".cloudflare.com";
            "outbound" = "vless-out";
          }
          {
            "domain_suffix" = ".alicdn.com";
            "outbound" = "vless-out";
          }
          {
            "domain" = "cheat.sh";
            "outbound" = "vless-out";
          }
          {
            "domain" = "danieldefo.ru";
            "outbound" = "vless-out";
          }
          {
            "inbound" = "socks-in";
            "outbound" = "vless-out";
          }
          { 
            "domain" = "cloudflare-ech.com";
            "outbound" = "vless-out";
          }
          {
            "rule_set" = "antizapret";
            "outbound" = "vless-out";
          }
          {
            "domain_regex" = "^(?:[\\w-]+\\.)*binance\\.*";
            "outbound" = "direct-out";
          }
          # {
          #   "ip_is_private" = true;
          #   "outbound" = "direct-out";
          # }
        ];
        "rule_set" = [
          {
            "tag" = "antizapret";
            "type" = "remote";
            "format" = "binary";
            "url" = "https://github.com/savely-krasovsky/antizapret-sing-box/releases/latest/download/antizapret.srs";
            "download_detour" = "vless-out";
          }
        ];
        "auto_detect_interface" = true;
        "final" = "direct-out";
      };

      "experimental" = {
        "cache_file" = {
          "enabled" = true;
        };
      };
    };
  };
}