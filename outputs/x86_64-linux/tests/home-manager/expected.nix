{
  myvars,
  lib,
}: let
  username = myvars.username;
  hosts = ["mochou"];
in
  lib.genAttrs hosts (_: "/home/${username}")
