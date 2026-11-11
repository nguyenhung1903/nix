
{ pkgs, ... }:

{
  home.packages = [
    ((pkgs.vscode.override {
      commandLineArgs = "--locale=ja";
    }).overrideAttrs (old: {
      # Work around the old ripgrep path in nixos-26.05
      # for VS Code >= 1.122.
      postPatch = pkgs.lib.replaceStrings
        [ "resources/app/node_modules/@vscode/ripgrep/bin/rg" ]
        [ "resources/app/node_modules/@vscode/ripgrep-universal/bin/linux-x64/rg" ]
        (old.postPatch or "");
    }))
  ];
}

