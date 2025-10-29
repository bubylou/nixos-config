{ pkgs, lib, config, ... }:
let cfg = config.home-lab.minecraft;

in
{
  options.home-lab.minecraft = {
    enable = lib.mkEnableOption "enables minecraft server";

    port = lib.mkOption {
      type = lib.types.int;
      default = 25565;
      description = "minecraft port";
      example = 25565;
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.pkgs.minecraftServers.vanilla-server;
      description = "minecraft package";
      example = pkgs.minecraftServers.vanilla-server;
    };

    difficulty = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = "minecraft difficulty";
      example = 1;
    };

    gamemode = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = "minecraft gamemode";
      example = 0;
    };

    operators = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "minecraft operators";
      example = { "Steve" = "1111111111111-2222-3333-444444444444"; };
    };

    whitelist = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "minecraft whitelist";
      example = { "Steve" = "1111111111111-2222-3333-444444444444"; };
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
          server-port = cfg.port;
          difficulty = cfg.difficulty;
          gamemode = cfg.gamemode;
          white-list = true;
        };
      };
    };
  };
}
