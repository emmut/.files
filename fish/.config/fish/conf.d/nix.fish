# Nix / home-manager binaries (see nix/ and the README "Nix (experimental)"
# section). The Nix installer's own profile hook doesn't always reach fish
# when this config manages PATH, so add the profile bin dir explicitly.
if test -d ~/.nix-profile/bin
    fish_add_path --path ~/.nix-profile/bin
end
