# VPS-Nix

Nix configurations for VPS systems.

## Sops

Generate an age key with

```sh
nix shell nixpkgs#age -c age-keygen -o /var/lib/sops-nix/age/key.txt
```

Derive the public key

```sh
nix shell nixpkgs#age -c age-keygen -y /var/lib/sops-nix/age/key.txt
```

Go into the secrets directory (`secrets`) and run

```sh
sops secrets.yaml
```

## Usage

An update can be applied by executing the command below on the target machine:

```sh
sudo nixos-rebuild switch --flake .#<hostname>
```

This generates or updates the `flake.lock` file, which should be committed to the `host-<hostname>` branch afterwards.
