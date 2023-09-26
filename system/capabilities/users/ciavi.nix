{ config, pkgs, lib, ... }:

{
  users.users.ciavi = {
    isNormalUser = true;
    description = "ciavi";
    extraGroups = [ "docker" "networkmanager" "video" "wheel" ];
  };
}
