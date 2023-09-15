{ config, pkgs, inputs, ... }:

{
  # Enable X11
  services.xserver = {
    enable = true;

    # Enable MATE
    desktopManager.mate.enable = true;

    # Enable LightDM
    displayManager.ligtdm.enable = true;
  };
}