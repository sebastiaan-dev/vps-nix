{
    description = "NixOS configuration";

    inputs = {
       nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    };

    outputs = { self, nixpkgs, ... }@inputs: 
    let 
        lib = nixpkgs.lib;
    in {
        nixosConfigurations = {
            remulus = lib.nixosSystem {
                modules = [
                    ./modules/common/configuration.nix
                    ./modules/famesystems/remulus/configuration.nix
                ];
            };
            romulus = lib.nixosSystem {
                modules = [
                    ./modules/common/configuration.nix
                    ./modules/famesystems/romulus/configuration.nix
                ];
            };
        };
    };
}