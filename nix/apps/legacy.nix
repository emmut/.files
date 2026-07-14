# Bridge for apps where the legacy scripts stay the preferred install
# method (GUI apps get proper system integration from brew casks / pacman /
# official installers; keyd needs root). Nix doesn't package these — it
# orchestrates the scripts, so `home-manager switch` is still the single
# entry point for installing AND uninstalling.
#
# App modules declare `legacy.apps = [ "<app>" ]`. On switch, compared to
# the list applied last time (tracked in $XDG_STATE_HOME):
#   - newly declared apps run install/<app>.sh
#   - removed apps run uninstall/<app>.sh
# Already-applied apps are skipped, keeping switches fast; re-run an
# installer any time with `./scripts/setup.sh <app>`.
#
# Notes:
#   - Run switches in an interactive terminal: uninstall scripts ask for
#     confirmation, and install/keyd.sh uses sudo.
#   - Answering "no" to an uninstall prompt still drops the app from the
#     tracked list (the app stays installed); re-add its module or run
#     uninstall/<app>.sh by hand later.
{ config, lib, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.files";
  stateFile = "${config.xdg.stateHome}/home-manager/legacy-apps";
  declared =
    lib.concatStringsSep " " (lib.unique (lib.sort lib.lessThan config.legacy.apps));
in
{
  options.legacy.apps = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = "Apps managed via the repo's legacy install/uninstall scripts.";
  };

  config.home.activation.legacyApps =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      legacyDeclared="${declared}"
      legacyStateFile="${stateFile}"
      legacyPrevious=""
      [ -f "$legacyStateFile" ] && legacyPrevious="$(cat "$legacyStateFile")"

      for legacyApp in $legacyPrevious; do
        case " $legacyDeclared " in
          *" $legacyApp "*) ;;
          *) run ${dotfiles}/uninstall/"$legacyApp".sh ;;
        esac
      done

      for legacyApp in $legacyDeclared; do
        case " $legacyPrevious " in
          *" $legacyApp "*) ;;
          *) run ${dotfiles}/install/"$legacyApp".sh ;;
        esac
      done

      run mkdir -p "$(dirname "$legacyStateFile")"
      run bash -c "echo '$legacyDeclared' > '$legacyStateFile'"
    '';
}
