flake := "."

_default:
    just --list

update:
    sudo nix flake update --flake {{ flake }}

check:
    nix flake check

switch:
    sudo nixos-rebuild --flake {{ flake }} switch

test:
    sudo nixos-rebuild --flake {{ flake }} test

boot:
    sudo nixos-rebuild --flake {{ flake }} boot
