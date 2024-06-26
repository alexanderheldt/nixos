{ pkgs, lib, config, ... }:
let
  enabled = config.mod.zsh.enable;
in
{
  options = {
    mod.zsh = {
      enable = lib.mkEnableOption "enable zsh module";
    };
  };

  config = lib.mkIf enabled {
    home-manager.users.alex = {
      programs.zsh = {
        enable = true;

        autosuggestion.enable = true;
        enableCompletion = true;
        defaultKeymap = "viins";

        history = {
          ignoreDups = true;
          size = 100000;
          save = 100000;
        };

        plugins = [
          {
            name = "powerlevel10k";
            src = pkgs.zsh-powerlevel10k;
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          }
          {
            name = "zsh-syntax-highlighting";
            src = pkgs.zsh-syntax-highlighting;
          }
          {
            name = "zsh-autosuggestions";
            src = pkgs.zsh-autosuggestions;
          }
          {
            name = "zsh-syntax-completions";
            src = pkgs.zsh-completions;
          }
          {
            name = "powerlevel10k-config";
            src = ./p10k-config;
            file = "p10k.zsh";
          }
        ];

        initExtra = lib.strings.concatStringsSep "\n" [
          "export KEYTIMEOUT=1"
          "bindkey -v '^?' backward-delete-char"
          "bindkey '^a' beginning-of-line"
          "bindkey '^e' end-of-line"
          ''
            function prompt_in_nix_shell() {
              if [[ -n "$IN_NIX_SHELL" ]]; then
                p10k segment -f yellow -t "nix";
              fi
            }
          ''
          ''
            function prompt_in_direnv() {
              if [[ -n "$DIRENV_DIR" ]]; then
                p10k segment -f yellow -t "direnv"
              fi
            }
          ''
        ];
      };
    };

    users.users.alex.shell = pkgs.zsh;

    programs.zsh.enable = true;
    environment.pathsToLink = [ "/share/zsh" ];
  };
}
