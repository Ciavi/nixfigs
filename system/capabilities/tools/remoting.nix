{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    gnome-connections
    parsec-bin
  ];

  services.teamviewer.enable = true;
}
