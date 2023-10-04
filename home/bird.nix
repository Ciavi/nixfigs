{ config, pkgs, lib, self, ... }:

{
  home = {
    username = "ciavi";
    homeDirectory = "/home/ciavi";
    stateVersion = "23.11";

    packages = with pkgs; [
      bitwarden
      bottles
      brave
      (discord.override {
        withVencord = true;
      })
      ffmpegthumbnailer
      firefox
      gimp
      htop
      inkscape
      insomnia
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
      vscode-fhs
      xfce.orage
      xfce.ristretto
    ];

    shellAliases = {
      gcw = "gcc -Wall -Wextra";
      li = "eza -la";
      lih = "eza -lah";
    };
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
      name = "phinger-cursors";
      package = pkgs.phinger-cursors;
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
        "image/*" = ["org.xfce.ristretto.desktop" "gimp.desktop"];
        "image/png" = ["org.xfce.ristretto.desktop" "gimp.desktop"];
        "image/jpeg" = ["org.xfce.ristretto.desktop" "gimp.desktop"];
        "image/svg+xml" = ["org.inkscape.Inkscape.desktop"];
        "text/*" = ["code.desktop"];
        "text/markdown" = ["obsidian.desktop" "code.desktop"];
        "audio/*" = ["vlc.desktop"];
        "video/*" = ["vlc.desktop"];
        "x-scheme-handler/http" = ["firefox.desktop" "brave-broser.desktop"];
        "x-scheme-handler/https" = ["firefox.desktop" "brave-broser.desktop"];
        "application/javascript" = ["code.desktop"];
        "application/json" = ["code.desktop"];
        "application/pdf" = ["firefox.desktop" "brave-broser.desktop"];
        "application/xhtml+xml" = ["code.desktop"];
        "application/x-httpd-php" = ["code.desktop"];
      };
    };
  };

  xsession.enable = true;
  
  programs.bash = {
    enable = true;
    enableVteIntegration = true;
    bashrcExtra = "(cat ~/.cache/wal/sequences &)\n";
  };
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
    ];
  };
  programs.powerline-go.enable = true;
  programs.home-manager.enable = true;
}
