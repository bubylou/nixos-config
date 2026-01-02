{pkgs, ...}: {
  imports = [
    ../common/rclone.nix
    ./disk-config.nix
    ./hardware-configuration.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  desktop.kodi.enable = true;

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  hardware = {
    bluetooth.enable = true;

    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-compute-runtime
        intel-media-driver
        vpl-gpu-rt
      ];
    };
  };

  home-lab = {
    domain = "bubylou.com";

    bazarr.enable = true;
    beszel-agent = {
      enable = true;
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC/v5jX8oQ9lZzIgtX+b0BMJ6inyhZr/ta12w5Xs+mZg";
    };

    caddy = {
      enable = true;
      authAddress = "nas01";
      email = "bubylou@pm.me";
    };

    radarr = {
      enable = true;
      url = "radarr-4k.bubylou.com";
      address = "0.0.0.0";
      environmentFiles = [
        "/run/keys/radarr-4k-apikey"
      ];
    };

    ssh = {
      enable = true;
      users = ["buby"];
    };
  };

  services = {
    xserver.videoDrivers = ["modesetting"];
    tlp.enable = true;

    pipewire.configPackages = [
      (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/10-bluetooth-all.conf" ''
        context.modules = [{
          name = libpipewire-module-combine-stream
          args = {
            combine.mode = sink
            node.name = "bt-all"
            node.description = "bluetooth broadcast to all devices"
            combine.latency-compensate = false
            combine.props = { audio.position = [ FL FR ] }
            stream.props = {}
            stream.rules = [{
              matches = [
                {
                  node.name = "~bluez_output.*"
                  media.class = "Audio/Sink"
                }
              ]
              actions = {
                create-stream = {
                  combine.audio.position = [ FL FR ]
                  audio.position = [ FL FR ]
                }
              }
            }]
          }
        }]
      '')
    ];

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        addresses = true;
        workstation = true;
        userServices = true;
      };
    };
  };

  system.stateVersion = "25.05";
}
