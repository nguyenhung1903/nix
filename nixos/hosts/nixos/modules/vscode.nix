{ config, lib, pkgs, ... }:

let
  vscode = pkgs.vscode.overrideAttrs (old: {
    version = "1.144.0";

    src = pkgs.fetchurl {
      name = "VSCode_1.144.0_linux-x64.tar.gz";
      url = "https://update.code.visualstudio.com/1.144.0/linux-x64/stable";
      hash = "sha256-F7cqfm9ApbXc6YUPEO6hPOc0pjBStn+gIcwB5xWtTPE=";
    };

    postPatch = "";
  });
in
{
  environment.systemPackages = [ vscode ];
}
