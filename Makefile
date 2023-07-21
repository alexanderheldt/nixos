.PHONY: pinwheel-switch

pinwheel-switch:
	nixos-rebuild switch --flake .#pinwheel
