.PHONY: switch

switch:
	nixos-rebuild switch --flake '.#'
