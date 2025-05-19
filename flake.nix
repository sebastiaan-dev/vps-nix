{
  # Reference
  # - https://nixos-and-flakes.thiscute.world/

  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    mac-app-util.url = "github:hraban/mac-app-util";
    catppuccin.url = "github:catppuccin/nix";
    # Disk manager
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Secret management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Private repository containing secrets
    self-secrets = {
      url = "git+ssh://git@github.com/sebastiaan-dev/nix-secrets.git?ref=main&shallow=1";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nix-darwin,
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      mac-app-util,
      catppuccin,
      disko,
      home-manager,
      sops-nix,
      ...
    }@inputs:
    let
      common = [ ./modules/common/configuration.nix ];
    in
    {
      nixosConfigurations = {
        net-worker-1 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = common ++ [
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.sebastiaan = import ./modules/home/sebastiaan.nix;
            }
            ./modules/machines/oracle/net-worker-1/configuration.nix
            ./modules/common/dns/dns.nix
            ./modules/common/tailscale.nix
            ./modules/common/step-ca/step-ca.nix
          ];
        };
        net-worker-2 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = common ++ [
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.sebastiaan = import ./modules/home/sebastiaan.nix;
            }
            ./modules/machines/oracle/net-worker-2/configuration.nix
            ./modules/common/tailscale.nix
          ];
        };
        net-storage-1 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = common ++ [
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.sebastiaan = import ./modules/home/sebastiaan.nix;
            }
            ./modules/machines/host-c/net-storage-1/configuration.nix
            # ./modules/common/tailscale.nix
          ];
        };
      };

      darwinConfigurations."Sebastiaans-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          sops-nix.darwinModules.sops
          mac-app-util.darwinModules.default
          home-manager.darwinModules.home-manager
          {
            home-manager.sharedModules = [
              mac-app-util.homeManagerModules.default
            ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            users.users.sebastiaan.home = "/Users/sebastiaan";
            home-manager.users.sebastiaan = {
              imports = [
                ./modules/home/sebastiaan-darwin.nix
                ./modules/home/shell.nix
                ./modules/home/utils.nix
                catppuccin.homeModules.catppuccin
              ];
            };
          }
          (
            { config, ... }:
            {
              # <--
              homebrew.taps = builtins.attrNames config.nix-homebrew.taps; # <--
            }
          )
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true;

              # User owning the Homebrew prefix
              user = "sebastiaan";

              # Optional: Declarative tap management
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
              };

              # Optional: Enable fully-declarative tap management
              #
              # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
              mutableTaps = false;
            };
          }
          ./modules/machines/apple/macbook-pro/configuration.nix
        ];
      };
    };
}
