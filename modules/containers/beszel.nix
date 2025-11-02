{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.containers.beszel;
in {
  options.home-lab.containers.beszel = {
    enable = lib.mkEnableOption "enables beszel";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8090;
      description = "Port to expose beszel on";
      example = 8090;
    };

    listen = lib.mkOption {
      type = lib.types.str;
      default = "/beszel_socket";
      description = "Host or path to listen on";
      example = "/beszel_socket";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      beszel = {
        image = "ghcr.io/henrygd/beszel/beszel:0.15.3";
        environment = {TZ = config.time.timeZone;};
        ports = ["${toString cfg.port}:8090/tcp"];
        volumes = [
          "beszel-data:/beszel_data:rw"
          "beszel-socket:${cfg.listen}:rw"
        ];
      };
      beszel-agent = {
        image = "ghcr.io/henrygd/beszel/beszel-agent-nvidia:0.15.3";
        extraOptions = [
          "--device"
          "nvidia.com/gpu=all"
          "--network=host"
        ];
        environment = {
          TZ = config.time.timeZone;
          LISTEN = "${cfg.listen}";
          KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDgCS2cI5e7I7vNI+M7ZRjBrAHqev3+kb16gG3JXPGP7";
        };
        volumes = [
          "beszel-agent-data:/var/lib/beszel-agent:rw"
          "beszel-socket:${cfg.listen}:rw"
          "/var/run/podman/podman.sock:/var/run/docker.sock:ro"
        ];
      };
    };

    services.caddy = {
      virtualHosts."beszel-test.${config.home-lab.domain}" = {
        useACMEHost = "${config.home-lab.domain}";
        extraConfig = ''
          request_body {
            max_size 10MB
          }

          reverse_proxy http://127.0.0.1:${toString cfg.port} {
            transport http {
              read_timeout 360s
            }
          }
        '';
      };
    };
  };
}
