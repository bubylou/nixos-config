{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.navidrome;
in {
  imports = [
    (import ./common/basic.nix {
      name = "navidrome";
      port = 4533;
      inherit config lib;
    })
  ];

  config = lib.mkIf cfg.enable {
    users.users.navidrome.extraGroups = ["media"];

    services.navidrome = {
      enable = true;
      group = "media";
      settings = {
        BaseUrl = "https://${cfg.url}";
        Address = cfg.address;
        Port = cfg.port;
        MusicFolder = "/mnt/media/music";
        ExtAuth.TrustedSources = ["127.0.0.1/32"];
      };
    };
  };
}
