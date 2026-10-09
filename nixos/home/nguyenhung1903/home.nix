{ config, pkgs, ... }:

{
  home.username = "nguyenhung1903";

  home.homeDirectory = "/home/nguyenhung1903";

  home.stateVersion = "26.05";


  # --------------------------------------------------
  # Modules
  # --------------------------------------------------

  imports = [
    ./obs-nvidia.nix
    ./zoom.nix
  ];

  home.packages = [
    pkgs.google-chrome
  ];
  # --------------------------------------------------
  # Home Manager
  # --------------------------------------------------

  programs.home-manager.enable = true;
}
