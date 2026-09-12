{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    # Command suggestion
    autosuggestions = {
      enable = true;
    };

    # Syntax highlighting
    syntaxHighlighting = {
      enable = true;
    };

    # Useful plugins
    interactiveShellInit = ''
      # Use emacs-style key bindings
      bindkey -e

      # History configuration
      HISTFILE="$HOME/.zsh_history"
      HISTSIZE=50000
      SAVEHIST=50000

      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_SPACE
      setopt SHARE_HISTORY
      setopt APPEND_HISTORY
      setopt INC_APPEND_HISTORY

      # Better directory navigation
      setopt AUTO_CD
      setopt AUTO_PUSHD
      setopt PUSHD_IGNORE_DUPS
      setopt PUSHD_SILENT

      # Completion
      autoload -Uz compinit
      compinit

      # fzf
      if command -v fzf >/dev/null 2>&1; then
        source ${pkgs.fzf}/share/fzf/key-bindings.zsh
        source ${pkgs.fzf}/share/fzf/completion.zsh
      fi

      # zoxide
      if command -v zoxide >/dev/null 2>&1; then
        eval "$(zoxide init zsh)"
      fi
    '';

    shellAliases = {
      # ls
      ls = "eza";
      ll = "eza -lah --icons";
      la = "eza -a --icons";
      lt = "eza --tree --level=2 --icons";

      # cat
      cat = "bat";

      # NixOS
      rebuild = "sudo nixos-rebuild switch";
      rebuild-test = "sudo nixos-rebuild test";
      rebuild-boot = "sudo nixos-rebuild boot";

      # System
      update = "sudo nixos-rebuild switch --upgrade";

      # Neovim
      v = "nvim";
      vi = "nvim";
      vim = "nvim";
      
      #Lzd
      lzd = "lazydocker";
    };
  };


  programs.starship = {
    enable = true;

    settings = {
      add_newline = false;

      format = "$username$hostname$directory$git_branch$git_status$python$nodejs$rust$golang$docker_context$cmd_duration$line_break$character";

      username = {
        show_always = true;
        format = "[$user]($style) ";
      };

      hostname = {
        ssh_only = false;
        format = "[@$hostname]($style) ";
      };

      directory = {
        truncation_length = 4;
        truncate_to_repo = true;
        style = "bold cyan";
      };

      git_branch = {
        symbol = " ";
        format = "[$symbol$branch]($style) ";
        style = "bold purple";
      };

      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style = "bold red";
      };

      python = {
        symbol = " ";
        format = "[$symbol$virtualenv]($style) ";
      };

      nodejs = {
        symbol = " ";
        format = "[$symbol$version]($style) ";
      };

      golang = {
        symbol = " ";
      };

      rust = {
        symbol = " ";
      };

      docker_context = {
        symbol = " ";
      };

      cmd_duration = {
        min_time = 2000;
        format = "took [$duration]($style) ";
      };

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };


  environment.systemPackages = with pkgs; [
    eza
    bat
    ripgrep
    fd

    fzf

    zoxide

    git

    jq

    btop

    curl
    wget

    unzip
    zip

    neovim
  ];

  users.users.nguyenhung1903.shell = pkgs.zsh;

  users.users.root.shell = pkgs.zsh;

}
