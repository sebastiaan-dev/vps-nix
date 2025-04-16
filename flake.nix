{
    description = "NixOS configuration";

    inputs = {
       nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    };

    outputs = { self, nixpkgs, ... }@inputs: 
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
                    ./modules/oracle/net-worker-1/configuration.nix
                    ./modules/common/dns.nix
                    ./modules/common/tailscale.nix
                ];
            };
        };
    };
}