{
  lib,
  inputs,
  home-modules ? [],
  myvars,
  system,
  genSpecialArgs,
  specialArgs ? (genSpecialArgs system),
  ...
}: let
  inherit (inputs) nixpkgs home-manager;

  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
in {
  otherConfigurations = {
    home-manager.users."${myvars.username}" = {
      home.stateVersion = "24.11";
      imports = home-modules;
      pkgs = pkgs;
      extraSpecialArgs = specialArgs;
    };
  };
}
