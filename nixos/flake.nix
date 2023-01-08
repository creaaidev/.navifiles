{
  description = "My simple NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;

      sshKeys = [
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILW5ZVdVaKMVlau1wp/JGJpdpE6JUxJ07DEYHi9qOLC8 crea@tsukuyomi"
	"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJcUMSSFZQheROdhFVmIUwBTbAVBv9YUm/Ib3ED3O0gv crea@pasokon"
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDYNGP+7GKcUpccWNOAxn5VSDVTzgNkcYisHLEHKpahj crea@fuujin"
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINKtzQZmcfn9DS+s8Wx034OaMHthFXrrG/JQyMl2rLXx u0_a225@localhost"
      ];

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
	overlays = [ overlay-unstable ];
      };

      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };

    in
    {
      homeConfigurations = {
	crea = home-manager.lib.homeManagerConfiguration {
	  # pkgs = nixpkgs.legacyPackages.${system};
    	  inherit pkgs;

	  modules = [
      ./users/crea/home.nix
      {
        home = {
          username = "crea";
          homeDirectory = "/home/crea";
          stateVersion = "22.05";
        };
      }
    ];
	};
      };

      nixosConfigurations = {
	ebisu = lib.nixosSystem {
          inherit system pkgs;

          specialArgs = { inherit sshKeys; };
          modules = [ ./hosts/ebisu/configuration.nix ];
        };

	tsukuyomi = lib.nixosSystem {
          inherit system pkgs;

          specialArgs = { inherit sshKeys; };
          modules = [ ./hosts/tsukuyomi/configuration.nix ];
        };

	fuujin = lib.nixosSystem {
          inherit system pkgs;

          specialArgs = { inherit sshKeys; };
          modules = [ ./hosts/fuujin/configuration.nix ];
        };
      };
    };
}

