{pkgs, ...}: {
  imports = [./disk-config.nix ./hardware-configuration.nix];

  desktop.kodi.enable = true;

  hardware = {
    bluetooth.enable = true;

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
      ];
    };
  };

  home-lab = {
    ssh = {
      enable = true;
      users = ["buby"];
    };
  };

  services = {
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
