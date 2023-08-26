{ home-manager, pkgs, lib, ... }:
{
  home-manager.users.alex = {
    programs.zsh = {
      enable = true;

      enableAutosuggestions = true;
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

      envExtra = lib.strings.concatStringsSep "\n" [
        "EDITOR=vim"
        "BROWSER=firefox"
      ];

      initExtra = lib.strings.concatStringsSep "\n" [
        "export KEYTIMEOUT=1"
        "bindkey -v '^?' backward-delete-char"
        "bindkey '^a' beginning-of-line"
        "bindkey '^e' end-of-line"
      ];
    };
  };

  users.users.alex.shell = pkgs.zsh;

  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];
}
