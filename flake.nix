{
    description = "NixOS configuration";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
        home-manager = {
            url = "github:nix-community/home-manager/release-24.11";
            # The `follows` keyword in inputs is used for inheritance.
            # Here, `inputs.nixpkgs` of home-manager is kept consistent with
            # the `inputs.nixpkgs` of the current flake,
            # to avoid problems caused by different versions of nixpkgs.
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, home-manager, ... }@inputs: 
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
                modules = common ++ [
                    home-manager.nixosModules.home-manager
                    {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.users.sebastiaan = import ./modules/home.nix;
                    }
                    ./modules/oracle/net-worker-1/configuration.nix
                    ./modules/common/dns/dns.nix
                    ./modules/common/tailscale.nix
                ];
            };
        };
    };
}