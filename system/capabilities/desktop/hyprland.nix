{ config, pkgs, inputs, ... }:

{
  # Hyprland Cachix
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  environment = {
    sessionVariables = {
      __GLX_VENDOR_LIBRARY_NAME = "amdvlk";
      GTK_USE_PORTAL = "1";
      LIBVA_DRIVER_NAME = "amdvlk";
      NIXOS_OZONE_WL = "1";
      NIXOS_XDG_OPEN_USE_PORTAL = "1";
      WLR_RENDERER = "amdvlk";

      CLUTTER_BACKEND = "wayland";
      GDK_BACKEND = "wayland,x11";
      QT_QPA_PLATFORM = "wayland;xcb";

      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";

      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_QPA_PLATFORMTHEME = "gtk3";
      QT_SCALE_FACTOR = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATOR = "1";
    };
    systemPackages = with pkgs;
    let
      xwaylandvideobridge = with pkgs; stdenv.mkDerivation rec {
        pname = "xwaylandvideobridge";
	      version = "unstable-2023-10-16";
	
        src = fetchgit {
          url = "https://github.com/KDE/xwaylandvideobridge.git";
          rev = "bc513009754a18d4901b743ee6b5a861a4353efa";
          hash = "sha256-BjcH15az11+GCLeGknCA8GvXgtakJZcJj6EIZjon0RE=";
        };
            
        nativeBuildInputs = [
          cmake
          extra-cmake-modules
          pkg-config
        ];

        buildInputs = [
          qt5.qtbase
          qt5.qtquickcontrols2
          qt5.qtx11extras
          libsForQt5.kdelibs4support
          (libsForQt5.kpipewire.overrideAttrs (oldAttrs: {
            version = "unstable-2023-10-16";
            src = fetchgit {
              url = "https://invent.kde.org/plasma/kpipewire";
              rev = "e08b7be1f2a7bdaed2291cd5dc6374d6535db1b8";
              hash = "sha256-nipZKj0NqthpexXgQCtJvA3mwWfIn58zsN6usJfm6pQ=";
            };
          }))
        ];

        dontWrapQtApps = true;
      };
    in
    [
      brightnessctl
      cliphist
      glib
      gnome.file-roller
      greetd.tuigreet
      grim
      gtk2
      gtk3
      hyprpaper
      hyprpicker
      kanshi
      libcanberra-gtk3
      libnotify
      libsForQt5.kdelibs4support
      libsForQt5.qt5.qtbase
      libsForQt5.qt5.qtquickcontrols2
      libsForQt5.qtstyleplugins
      libsForQt5.qt5.qtwayland
      libsForQt5.qt5.qtx11extras
      libva
      lxappearance
      networkmanagerapplet
      nwg-bar
      pasystray
      playerctl
      polkit_gnome
      qt6.qtwayland
      rofi-wayland
      rofimoji
      rubyPackages.glib2
      slurp
      swayidle
      swaylock-effects
      swaynotificationcenter
      swayosd
      udiskie
      waybar
      wttrbar
      xcur2png
      xwaylandvideobridge
      wdisplays
    ];
  };

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Dconf
  programs.dconf.enable = true;

  # Thunar
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  # Enabling Hyprland XDG Portal
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk];
  };

  # Enable nm-applet for connecting to networks via GUI and system tray.
  programs.nm-applet.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    font-awesome
    (nerdfonts.override { fonts = ["NerdFontsSymbolsOnly"]; })
  ];

  # Enabling greetd with tuigreet
  services.greetd = {
    enable = true;
    vt = 7;
    settings = {
      terminal = {
        vt = 7;
      };
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # Enable udisks2 to help auto-mount
  services.udisks2.enable = true;

  # Enable polkit
  security.polkit.enable = true;

  # SVG support for widgets
  services.xserver.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

  # Swaylock to work with actual password
  security.pam.services.swaylock.text = ''
    # PAM configuration file for the swaylock screen locker. By default, it includes
    # the 'login' configuration file (see /etc/pam.d/login)
    auth include login
  '';

  # Udev rules for SwayOSD
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
  '';

  systemd = {
    # Hyprland session target
    user.targets.hyprland-session = {
      description = "Hyprland session";
      bindsTo = ["graphical-session.target"];
      wants = ["graphical-session-pre.target"];
      after = ["graphical-session-pre.target"];
    };
    
    # Polkit Gnome agent service
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "Gnome policy kit authentication agent";
      wantedBy = ["hyprland-session.target"];
      wants = ["hyprland-session.target"];
      after = ["hyprland-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    # SwayOSD
    services.swayosd-libinput-backend = {
      description = "SwayOSD backend service";
      wantedBy = ["graphical.target"];
      partOf = ["graphical.target"];
      after = ["graphical.target"];
      serviceConfig = {
        Type = "dbus";
        BusName = "org.erikreider.swayosd";
        ExecStart = "${pkgs.swayosd}/bin/swayosd-libinput-backend";
        Restart = "on-failure";
      };
    };

    # Swayidle service
    user.services.swayidle = {
      description = "Idle manager for Wayland compositors";
      partOf = ["graphical-session.target"];
      wantedBy = ["hyprland-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.swayidle}/bin/swayidle -w timeout 180 '${pkgs.swaylock-effects}/bin/swaylock --clock -f' timeout 300 '${pkgs.hyprland}/bin/hyprctl \"dispatch dpms off\"' resume '${pkgs.hyprland}/bin/hyprctl \"dispatch dpms on\"'";
      };
    };
  };
}