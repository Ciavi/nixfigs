# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, modulesPath, nixpkgs, inputs, ... }:

{
  imports = [
      # Include the results of the hardware scan.
      ./hardware/bird-hardware.nix
      {nixpkgs.overlays = [(final: prev: {inherit inputs;})];}
      # Include capabilities.
      ./capabilities/desktop/mate.nix
      {nixpkgs.overlays = [(final: prev: {inherit inputs;})];}
      ./capabilities/entertainment/gaming.nix
      {nixpkgs.overlays = [(final: prev: {inherit inputs;})];}
      ./capabilities/tools/remoting.nix
      ./capabilities/users/ciavi.nix
    ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["ntfs"];

  networking.hostName = "bird"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n.defaultLocale = "it_IT.utf-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.utf-8";
    LC_IDENTIFICATION = "it_IT.utf-8";
    LC_MEASUREMENT = "it_IT.utf-8";
    LC_MONETARY = "it_IT.utf-8";
    LC_NAME = "it_IT.utf-8";
    LC_NUMERIC = "it_IT.utf-8";
    LC_PAPER = "it_IT.utf-8";
    LC_TELEPHONE = "it_IT.utf-8";
    LC_TIME = "it_IT.utf-8";
  };

  #Configure console keymap
  console.keyMap = "it2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     dotnet-sdk_7
     eza
     ffmpeg
     font-awesome
     gh
     git
     imagemagick
     jdk20
     mono
     mono5
     mono4
     neofetch
     pciutils
     psmisc
     python311
     python311Packages.pip
     socat
     usbutils
  ];

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
    rocm-opencl-icd
    rocm-opencl-runtime
  ];

  hardware.opengl.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.hip}"
  ];

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.upower.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
