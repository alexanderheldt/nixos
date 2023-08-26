{ home-manger, pkgs, ... }:
{
  home-manager.users.alex = {
    programs.tmux = {
      enable = true;

      baseIndex = 1;
      keyMode = "vi";

      # Allow vi mode to be enabled instantly
      escapeTime = 0;

      plugins = [ pkgs.tmuxPlugins.sensible ];

      extraConfig = ''
        set -g renumber-windows on

        # https://old.reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
        set -g default-terminal "xterm-256color"
        set -ga terminal-overrides ",*256col*:Tc"
        set -ga terminal-overrides "*:Ss=\E[%p1%d q:Se=\E[ q"
        set-environment -g COLORTERM "truecolor" 

        set-option -g allow-rename off

        # Status line colors
        set -g status-fg '#f9c22b'
        set -g status-bg '#303030'

        # Remove date/time etc. on the right side
        set -g status-right ""

        # Status window colors
        set -g window-status-current-style bg='#3a3a3a',fg='#f9c22b'
        set -g window-status-current-style bg='#3a3a3a',fg='#f9c22b'
        set -g window-status-style bg='#303030',fg='#767676'

        set -g pane-border-style fg='#3a3a3a'
        set -g pane-active-border-style fg='#f9c22b'

        bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded"

        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"

        # Move panes shortcuts
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        # Resize panes
        bind -r H resize-pane -L 10
        bind -r J resize-pane -D 10
        bind -r K resize-pane -U 10
        bind -r L resize-pane -R 10

        # Move windows
        bind -r Left swap-window -t -1 \; select-window -t -1
        bind -r Right swap-window -t +1 \; select-window -t +1
      '';
    };
  };
}
