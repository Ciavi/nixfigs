{
  description = "NixFigs - Ciavi's sweet config files";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, aagl, home-manager, ... }@inputs:
  let
    inherit (self) outputs;
  in
  {
    nixosConfigurations = {
      bird = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        modules = [
          ./system/bird.nix
        ];
      };
    };

    homeConfigurations = {
      "ciavi@bird" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        extraSpecialArgs = { inherit inputs outputs; };
        modules = [
          ./home/bird.nix
        ];
      };
    };
  };
}