{ config, pkgs, ... }:

let
  # Where this repo is checked out; the config links below point into it.
  dotfiles = "${config.home.homeDirectory}/.files";
in
{
  home.username = "emmut";
  home.homeDirectory =
    if pkgs.stdenv.isDarwin then "/Users/emmut" else "/home/emmut";

  # Never change this after the first switch; it pins compatibility behavior.
  home.stateVersion = "25.05";

  # Let home-manager manage itself so `home-manager` stays on PATH.
  programs.home-manager.enable = true;

  # Starter set to try in the VM. Binaries come from the Nix store with
  # identical paths on Arch and macOS (no more brew-prefix differences);
  # the stow packages in this repo keep managing all the configs.
  home.packages = with pkgs; [
    bat
    delta
    lazygit
    starship
    zoxide
    fzf
    lsd
    ripgrep
    fd
    fish
  ];

  # Fish config, replacing its stow package (unstow before switching).
  # mkOutOfStoreSymlink links straight into the repo — same live-edit
  # behavior as stow (no rebuild needed to change a config), but the link
  # itself is declared here and applied atomically. Requires the repo at
  # ~/.files. Runtime files (fish_variables, fisher plugins) keep working
  # since the linked repo dir stays writable.
  xdg.configFile."fish".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/fish/.config/fish";

  # tmux is fully declarative: home-manager generates the config
  # (~/.config/tmux/tmux.conf) and installs the plugins from nixpkgs —
  # no TPM, no prefix+I. Mirrors tmux/.tmux.conf, which remains for
  # stow-managed machines. Config edits here need a home-manager switch.
  programs.tmux = {
    enable = true;
    prefix = "C-Space";
    baseIndex = 1;
    mouse = true;
    keyMode = "vi";
    focusEvents = true;
    terminal = "xterm-256color";

    plugins = with pkgs.tmuxPlugins; [
      yank
      resurrect
      {
        plugin = catppuccin;
        # Theme options must be set before the plugin loads.
        extraConfig = ''
          set -g @catppuccin_flavor 'macchiato'
          set -g @catppuccin_window_right_separator "█ "
          set -g @catppuccin_window_number_position "left"
          set -g @catppuccin_window_middle_separator " | "
          set -g @catppuccin_window_text " #W"
          set -g @catppuccin_window_current_text " #W"
          set -g @catppuccin_status_left_separator "█"
          set -g @catppuccin_status_right_separator "█"
        '';
      }
      {
        plugin = continuum;
        extraConfig = "set -g @continuum-restore 'on'";
      }
    ];

    extraConfig = ''
      # reload config on r
      bind r source-file ~/.config/tmux/tmux.conf

      # toggle between panes
      unbind ^T
      bind ^T select-pane -t :.+

      # kill pane/window with menu prompt (navigate with j/k or arrows, confirm with enter)
      bind x display-menu -T " Kill pane? " \
        "Yes" y "kill-pane" \
        "No"  n ""
      bind X display-menu -T " Kill window? " \
        "Yes" y "kill-window" \
        "No"  n ""

      # scratchpad popup terminal (Alt+t)
      bind T display-popup -E -w 80% -h 80% -d "#{pane_current_path}" "$SHELL"

      # switch vertical and horizontal split mappings and preserve folder
      bind h split-window -v -c "#{pane_current_path}"
      bind v split-window -h -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind = split-window -v -c "#{pane_current_path}"

      # disable right click menu
      unbind -n MouseDown3Pane

      # shift arrow to switch windows
      bind -n S-Left  previous-window
      bind -n S-Right next-window

      # move window left or right
      bind-key -n C-S-Left swap-window -t -1\; select-window -t -1
      bind-key -n C-S-Right swap-window -t +1\; select-window -t +1

      # open new windows in current path
      bind c new-window -c "#{pane_current_path}"

      # renumber all windows when a window is closed
      set -g renumber-windows on

      # set the status bar position to the top
      set -g status-position top

      # https://stackoverflow.com/questions/60309665/neovim-colorscheme-does-not-look-right-when-using-nvim-inside-tmux
      set -ga terminal-overrides ",xterm-256color:Tc"

      # Shift+Enter support for Claude Code (sends Kitty protocol sequence)
      bind -n S-Enter send-keys "\e[13;2u"

      # Run fish in new panes without changing the login shell (found via
      # PATH, so it works on Linux and macOS alike).
      set -g default-command 'exec fish'

      bind-key "k" display-popup -E -w 40% "sesh connect \"$(
        sesh list -i | gum filter --limit 1 --placeholder 'Pick a sesh' --prompt='⚡'
      )\""

      bind-key -T prefix ä copy-mode

      # URL extractor popup modal
      bind-key u display-popup -E -w 40 -h 10 -d '#{pane_current_path}' \
        'tmux capture-pane -J -p | grep -oE "(https?)://.*[^>]" | sort -u | fzf --multi --bind alt-a:select-all,alt-d:deselect-all --header "Select URLs to open (Alt-a: select all, Alt-d: deselect all)" | xargs -r open'

      set -g status-right "#{E:@catppuccin_status_session}"
      set -g status-left ""
    '';
  };
}
