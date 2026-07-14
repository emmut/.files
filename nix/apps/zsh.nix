# Mirrors install/zsh.sh + install/p10k.sh, plus the stowed zsh/.zshrc —
# the "tmux treatment": fully declarative, no oh-my-zsh installer, no
# git-cloned plugins, and home-manager generates ~/.zshrc.
#
# IMPORTANT: programs.zsh owns .zshrc, so a machine switching to this must
# `stow -D zsh` first (or pass `home-manager switch -b backup`). The zsh
# stow package stays for legacy machines; the stowed ~/.p10k.zsh config
# (p10k stow package) is still used and stays stowed.
{ lib, pkgs, ... }:

{
  # fzf, vivid, and zoxide are also required here; they already come from
  # fish.nix in the same profile.
  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      # zsh-autosuggestions / fast-syntax-highlighting /
      # zsh-fzf-history-search were omz custom plugins in the legacy setup;
      # here they come from nixpkgs below instead.
      plugins = [ "git" ];
    };

    autosuggestion.enable = true;

    plugins = [
      {
        # Loaded as a plugin rather than an omz custom theme clone
        # (install/p10k.sh); ZSH_THEME stays unset.
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
        file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
      }
      {
        name = "zsh-fzf-history-search";
        src = pkgs.zsh-fzf-history-search;
        file = "share/zsh-fzf-history-search/zsh-fzf-history-search.plugin.zsh";
      }
    ];

    # Ported from the stowed zsh/.zshrc (which remains for stow machines).
    initContent = lib.mkMerge [
      # p10k instant prompt must run as early as possible in .zshrc.
      (lib.mkOrder 500 ''
        # Enable Powerlevel10k instant prompt. Should stay close to the top
        # of ~/.zshrc. Console-input init code must go above this block.
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')
      ''
        # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

        # ---- FZF -----

        # Set up fzf key bindings and fuzzy completion
        eval "$(fzf --zsh)"

        export FZF_DEFAULT_OPTS=" \
        --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
        --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
        --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"

        # ---- LS Colors using vivid ----

        export LS_COLORS="$(vivid generate catppuccin-macchiato)"

        zstyle ':completion:*' list-colors "''${(@s.:.)LS_COLORS}"
        # (compinit already ran — oh-my-zsh handles it; the stowed .zshrc
        # calls it explicitly.)

        # ---- Zoxide (better cd) ----
        eval "$(zoxide init zsh)"

        alias cd="z"

        if [[ -n "$TMUX" ]]; then
          export TERM="tmux-256color"
        else
          export TERM="xterm-256color"
        fi

        export EDITOR=nvim

        export XDG_CONFIG_HOME="$HOME/.config"
      ''
    ];
  };
}
