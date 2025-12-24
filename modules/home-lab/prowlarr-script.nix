{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.prowlarr;
  prowlarrBootstrap = pkgs.writeShellAppliaction "prowlarr-bootstrap" {
    name = "prowlarr-bootstrap";

    runtimeInputs = [
      pkgs.httpie
    ];

    text = ''
      appApiKey=$1
      appPort=$2
      appAddress=$3
      appName=$4

      http --ignore-stdin --check-status POST \
        "http://${cfg.address}:${toString cfg.port}/api/v1/applications" \
        X-Api-Key:$PROWLARR__AUTH__APIKEY \
        name=$appName \
        syncLevel=fullSync \
        fields[0][name]=prowlarrUrl \
        fields[0][value]=http://$appAddress:$appPort \
        fields[1][name]=baseUrl \
        fields[1][value]=http://$appName:$appPort \
        fields[2][name]=apiKey \
        fields[2][value]=$appApiKey \
        implementationName=$appName \
        implementation=$appName \
        configContract=$appName
    '';
  };
in {
  options.home-lab.prowlarr = {
    bootstrap = lib.mkEnableOption "enables prowlarr bootstrap";
  };

  config = lib.mkIf cfg.bootstrap.enable {
    systemd.services."prowlarr-bootstrap" = {
      serviceConfig.Type = "oneshot";
      path = with pkgs; [httpie];
      scriptArgs = "%I";
      script = prowlarrBootstrap;
    };
  };
}
