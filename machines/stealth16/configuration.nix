{pkgs, ...}: {
  boot.supportedFilesystems = ["nfs"];
  fileSystems."/mnt/nfs/share" = {
    device = "nas01:/srv/share";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto"];
  };

  desktop.hyprland.enable = true;
  hardware = {
    bluetooth.enable = true;

    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidia-container-toolkit.enable = true;
    nvidia = {
      open = true;
      modesetting.enable = true;

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        amdgpuBusId = "PCI:197:0:0";
        nvidiaBusId = "PCI:195:0:0";
      };
    };
  };

  home-lab = {
    ssh = {
      enable = true;
      users = ["buby"];
    };
  };

  # For using Steam Input on Wayland
  programs.steam.extest.enable = true;

  services = {
    # xserver/wayland drivers; modesetting is required for prime offloading
    xserver.videoDrivers = ["amdgpu" "nvidia" "modesetting"];

    upower.enable = true;
    tlp.enable = true;
    mullvad-vpn.enable = true;

    greetd = {
      enable = true;
      settings = rec {
        default_session = initial_session;
        initial_session = {
          command = "${pkgs.uwsm}/bin/uwsm start hyprland-uwsm.desktop";
          user = "buby";
        };
      };
    };
  };

  system.stateVersion = "25.05";
}
