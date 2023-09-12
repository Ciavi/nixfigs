{ config, pkgs, lib, self, ... }:

{
  home = {
    username = "ciavi";
    homeDirectory = "/home/ciavi";
    stateVersion = "23.05";

    packages = with pkgs; [
      bitwarden
      bitwarden-cli
      bottles
      brave
      ffmpegthumbnailer
      firefox
      gimp
      htop
      inkscape
      kitty
      lutris
      mission-center
      obsidian
      pavucontrol
      qalculate-gtk
      spotify
      thunderbird
      upscayl
      vlc
      vscodium-fhs
      webcord-vencord
    ];
  };

  gtk = {
    enable = true;
    font.name = "Oxanium";
    theme = {
      name = "Matcha-dark-pueril";
      package = pkgs.matcha-gtk-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme.override {
        color = "green";
      };
    };
    cursorTheme = {
      name = "Qogir-ubuntu-dark";
    };

    # v3 config
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    # v4 config
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "image/*" = ["ristretto.desktop" "gimp.desktop"];
        "image/png" = ["ristretto.desktop" "gimp.desktop"];
        "image/jpeg" = ["ristretto.desktop" "gimp.desktop"];
        "image/svg+xml" = ["inkscape.desktop"];
        "text/*" = ["codium.desktop"];
        "text/markdown" = ["obsidian.desktop" "codium.desktop"];
        "audio/*" = ["vlc.desktop"];
        "video/*" = ["vlc.desktop"];
        "x-scheme-handler/http" = ["brave.desktop"];
        "x-scheme-handler/https" = ["brave.desktop"];
        "application/javascript" = ["codium.desktop"];
        "application/json" = ["codium.desktop"];
        "application/pdf" = ["brave.desktop"];
        "application/xhtml+xml" = ["codium.desktop"];
        "application/x-httpd-php" = ["codium.desktop"];
      };
    };
  };

  xsession.enable = true;
  
  programs.bash = {
    enable = true;
    enableVteIntegration = true;
    bashrcExtra = "(cat ~/.cache/wal/sequences &)\n";
  };
  programs.pywal.enable = true;

  programs.home-manager.enable = true;
}