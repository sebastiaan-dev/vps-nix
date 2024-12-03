# VPS-Nix

Nix configurations for VPS systems.

## Usage

An update can be applied by executing the command below on the target machine:

```sh
sudo nixos-rebuild switch --flake .#<hostname>
```

This generates or updates the `flake.lock` file, which should be committed to the `host-<hostname>` branch afterwards.
