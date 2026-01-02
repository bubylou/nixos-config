{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.glance;
in {
  imports = [
    (import ./common/basic.nix {
      name = "glance";
      port = 8080;
      inherit config lib;
    })
  ];

  options.home-lab.glance = {
    pages = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [
        {
          columns = [
            {
              size = "full";
              widgets = [
                {
                  type = "calendar";
                }
              ];
            }
          ];
          name = "Calendar";
        }
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      glance = {
        enable = true;

        settings = {
          inherit (cfg) pages;
          branding.hide-footer = true;

          # catppuccin mocha
          theme = {
            background-color = "240 21 15";
            contrast-multiplier = 1.2;
            primary-color = "217 92 83";
            positive-color = "115 54 76";
            negative-color = "347 70 65";
          };

          server = {
            host = cfg.address;
            inherit (cfg) port;
          };
        };
      };
    };
  };
}
