{pkgs, ...}: {
  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    bat
    bottom
    cargo
    dive
    doggo
    earthly
    eza
    gcc
    git
    gnumake
    go
    jujutsu
    just
    ncdu
    nerd-fonts.mononoki
    nodejs
    ouch
    podman
    podman-compose
    python3
    ripgrep
    rsync
    tmux
    unzip
    xh
    xclip
    yazi
    yq
  ];

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userEmail = "bubylou@pm.me";
    userName = "Nicholas Malcolm";
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "helm" "kubectl"];
      theme = "robbyrussell";
    };
  };
}
