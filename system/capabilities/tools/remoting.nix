{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    gnome-connections
  ];

  services.teamviewer.enable = true;
}
