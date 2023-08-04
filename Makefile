.PHONY: pinwheel-switch flake-update 

pinwheel-switch:
	nixos-rebuild switch --flake .#pinwheel

flake-update:
	nix flake update
