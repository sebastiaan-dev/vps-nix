{
    description = "NixOS configuration";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
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

    outputs = { self, nixpkgs, disko, home-manager, sops-nix, ... }@inputs: 
    let 
        lib = nixpkgs.lib;
        common = [ ./modules/common/configuration.nix ];
    in {
        nixosConfigurations = {
            remulus = lib.nixosSystem {
                modules = common ++ [
                    ./modules/famesystems/remulus/configuration.nix
                ];
            };
            romulus = lib.nixosSystem {
                modules = common ++ [
                    ./modules/famesystems/romulus/configuration.nix
                ];
            };
            net-worker-1 = lib.nixosSystem {
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
                    ./modules/oracle/net-worker-1/configuration.nix
                    ./modules/common/dns/dns.nix
                    ./modules/common/tailscale.nix
                    ./modules/common/step-ca/step-ca.nix
                ];
            };
            net-worker-2 = lib.nixosSystem {
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
                    ./modules/oracle/net-worker-2/configuration.nix
                ];
            };
        };
    };
}
