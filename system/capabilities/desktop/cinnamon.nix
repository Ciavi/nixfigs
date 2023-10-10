{ config, pkgs, inputs, ... }:

{
  # Enable X11
  services.xserver = {
    enable = true;

    # Enable Cinnamon
    desktopManager.cinnamon.enable = true;

    # Enable LightDM
    displayManager.lightdm.enable = true;
  };
}
