{ config, pkgs, inputs, ... }:

{
  # Enable X11
  services.xserver = {
    enable = true;

    # Enable Gnome
    desktopManager.gnome.enable = true;

    # Enable LightDM
    displayManager.gdm.enable = true;
  };
}
