.PHONY: bennu-switch

bennu-switch:
	nixos-rebuild switch --flake .#bennu
