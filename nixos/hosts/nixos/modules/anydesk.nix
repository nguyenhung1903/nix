{ config, pkgs, inputs, ... }:

let
  pkgsStable = import inputs.nixpkgs-stable {
    system = pkgs.stdenv.hostPlatform.system;

    config = {
      allowUnfree = true;
    };
  };

in
{
  environment.systemPackages = [
    pkgsStable.anydesk
  ];
}
