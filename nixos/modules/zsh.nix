{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -lah";
      la = "ls -A";
      ".." = "cd ..";
      rebuild = "sudo nixos-rebuild switch";
    };

    interactiveShellInit = ''
      export EDITOR=nvim
      export VISUAL=nvim
    '';
  };

  programs.starship = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    fzf
    ripgrep
    fd
    eza
    bat
    zoxide
  ];
}
