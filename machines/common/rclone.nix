{pkgs, ...}: {
  environment.systemPackages = [pkgs.rclone];
  environment.etc."rclone-mount.conf".text = ''
    [share]
    type = sftp
    host = nas01
    user = buby
    key_file = /home/buby/.ssh/id_ed25519
  '';

  fileSystems."/mnt/media" = {
    device = "share:/srv/media";
    fsType = "rclone";
    options = [
      "nodev"
      "nofail"
      "allow_other"
      "args2env"
      "config=/etc/rclone-mount.conf"
    ];
  };
}
