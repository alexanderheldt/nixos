{ pkgs, ... }:

pkgs.buildGoModule {
  pname = "syb-cli";
  version = "b118cea";

  src = builtins.fetchGit {
    url = "git@github.com:soundtrackyourbrand/syb-cli.git";
    rev = "b118cea639e28eaa9d2d169cac8b801869b51bf6";
  };

  vendorHash = null; # Use `vendor` folder from source
}
