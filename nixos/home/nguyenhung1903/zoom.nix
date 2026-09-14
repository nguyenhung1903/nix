{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.zoom-us
  ];

  xdg.desktopEntries.zoom = {
    name = "Zoom";
    exec = "${pkgs.zoom-us}/bin/zoom-us --enable-gpu-rasterization --enable-zero-copy %U";
    icon = "Zoom";
    terminal = false;
    categories = [ "Network" "VideoConference" ];
  };
}
