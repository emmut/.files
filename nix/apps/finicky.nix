# Mirrors install/finicky.sh (macOS-only browser router; config stays in
# the stowed finicky package). Not in nixpkgs, so the release .dmg is
# packaged here; home-manager links the .app into
# ~/Applications/Home Manager Apps. Bump version + hash to update
# (`nix hash file Finicky.dmg` prints the sha256).
{ lib, pkgs, ... }:

let
  finicky = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "finicky";
    version = "4.2.2";

    src = pkgs.fetchurl {
      url = "https://github.com/johnste/finicky/releases/download/v${finalAttrs.version}/Finicky.dmg";
      hash = "sha256-XwAgeCyQddJ0EdYIPXvoZjiR4xRshur60RjESswSII8=";
    };

    # 7zz extracts APFS dmgs, which undmg can't.
    nativeBuildInputs = [ pkgs._7zz ];

    unpackPhase = ''
      runHook preUnpack
      7zz x $src
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications
      app=$(find . -maxdepth 2 -name "Finicky.app" -print -quit)
      cp -R "$app" $out/Applications/
      runHook postInstall
    '';
  });
in
{
  home.packages = lib.optionals pkgs.stdenv.isDarwin [ finicky ];
}
