{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.beszel-agent;
in {
  options.home-lab.beszel-agent = {
    enable = lib.mkEnableOption "enables beszel agent only";

    key = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "ssh-ed25519 AAAA...";
    };

    listen = lib.mkOption {
      type = lib.types.str;
      default = "45876";
      example = "45876";
    };
  };

  config = lib.mkIf cfg.enable {
    services.beszel.agent = {
      enable = true;
      environment = {
        HUB_URL = "https://beszel.${config.home-lab.domain}";
        KEY = cfg.key;
        LISTEN = cfg.listen;
      };
      openFirewall = true;
    };
  };
}
