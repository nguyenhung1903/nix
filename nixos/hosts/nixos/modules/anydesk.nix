
{ config, lib, pkgs, ... }:

let
  anydesk = pkgs.anydesk.overrideAttrs (old: rec {
    version = "8.0.4";

    src = pkgs.fetchurl {
      url = "https://download.anydesk.com/linux/anydesk-${version}-amd64.tar.gz";
      hash = "sha256-fg3sLcushu5zDvsBakHLP/FRqhvauICx86rlpK4YkW8=";
    };
  });
in
{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "anydesk" ];

  environment.systemPackages = [
    anydesk
  ];
}

