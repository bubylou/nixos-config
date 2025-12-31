{
  name,
  port,
  lib,
  config,
  ...
}: {
  options.home-lab.${name} = {
    enable = lib.mkEnableOption "enables ${name} server";

    url = lib.mkOption {
      type = lib.types.str;
      default = "${name}.${config.home-lab.domain}";
      example = "example.com";
    };

    address = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = port;
      example = 443;
    };
  };
}
