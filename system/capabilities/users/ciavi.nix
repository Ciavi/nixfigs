{ config, pkgs, lib, ... }:

{
  users.users.ciavi = {
    isNormalUser = true;
    description = "ciavi";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
