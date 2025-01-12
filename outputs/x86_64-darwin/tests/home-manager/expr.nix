{
  myvars,
  lib,
  outputs,
}: let
  username = myvars.username;
  hosts = ["mochou"];
in
  lib.genAttrs hosts (name:
    outputs.darwinConfigurations.${name}.config.home-manager.users.${username}.home.homeDirectory)
