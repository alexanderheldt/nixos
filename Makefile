.PHONY: pinwheel-switch flake-update 

pinwheel-switch:
	nixos-rebuild switch --flake .#pinwheel

sombrero-switch:
	nixos-rebuild switch --flake .#sombrero

flake-update:
	nix flake update
