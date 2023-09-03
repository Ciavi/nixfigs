{ config, pkgs, lib, inputs, ... }:

{
  imports = [inputs.aagl.nixosModules.default];
  
  nix.settings = inputs.aagl.nixConfig;
  programs.anime-game-launcher.enable = true;
  programs.honkers-railway-launcher.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
}
