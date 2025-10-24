{ pkgs, lib, config, ... }:
let
  cfg = config.home-lab.minecraft;
in {
  options.home-lab.minecraft = {
    enable = lib.mkEnableOption "enables minecraft server";

    operators = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Operators list";
      example = { "Bubylou" = "1111111111111-2222-3333-444444444444"; };
    };

    whitelist = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Whitelisted players";
      example = { "Bubylou" = "1111111111111-2222-3333-444444444444"; };
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.pkgs.minecraftServers.vanilla-server;
      description = "Minecraft server package";
      example = pkgs.minecraftServers.vanilla-server;
    };
  };

  config = lib.mkIf cfg.enable {
    services.minecraft-servers = {
      enable = true;
      eula = true;

      servers.paper = {
        enable = true;
        package = cfg.package;

        operators = cfg.operators;
        whitelist = cfg.whitelist;

        serverProperties = {
          server-port = 25565;
          difficulty = 2;
          gamemode = 0;
          max-players = 10;
          motd = "Bubylou: Minecraft server";
          white-list = true;

          allow-cheats = false;
          allow-flight = false;
          allow-nether = true;
        };
      };
    };
  };
}
