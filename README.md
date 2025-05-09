# VPS-Nix

Nix configurations for VPS systems.

## Sops

Generate an age key with

```sh
mkdir -p ~/.config/sops/age
# User
nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt"
```

Derive the public key

```sh
# User
nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt
# Machine
nix-shell -p ssh-to-age --run 'cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age'
```

sudo install -m700 -d /root/.ssh
sudo install -m600 ~/.ssh/id_ed25519{,.pub} /root/.ssh/

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

## TODO

- Close of NGINX services from the public web, either through firewall or by setting trusted nginx IPs?
- Fix use of sudo git
- Fix tailscale auth key

