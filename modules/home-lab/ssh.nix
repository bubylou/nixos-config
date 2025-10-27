{ lib, config, ... }:
let cfg = config.home-lab.ssh;
in
{
  options.home-lab.ssh = {
    enable = lib.mkEnableOption "enables openssh server";

    port = lib.mkOption {
      type = lib.types.int;
      default = 22;
    };

    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "admin" ];
    };
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [ cfg.port ];

      settings = {
        PasswordAuthentication = false;
        AllowUsers = cfg.users;
        UseDns = true;
        X11Forwarding = false;
        PermitRootLogin = "no";
      };
    };
  };
}
