{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.bazarr;
in {
  imports = [
    (import ./common/basic-options.nix {
      name = "bazarr";
      port = 6767;
      inherit config lib;
    })
    (import ./common/basic-config.nix {
      name = "bazarr";
      inherit config lib;
    })
  ];

  options.home-lab.bazzarr = {
    address.default = lib.mkForce "0.0.0.0";
  };

  config = lib.mkIf cfg.enable {
    services = {
      bazarr = {
        enable = true;
        listenPort = cfg.port;
      };
    };
  };
}
