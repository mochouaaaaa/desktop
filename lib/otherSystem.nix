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
    # 修改输出属性名
    # 直接使用 NixOS 模块或 Home Manager
    home-manager.users."${myvars.username}" = {
      home.stateVersion = "${myvars.homeVersion}";
      imports = home-modules;
      pkgs = pkgs;
      extraSpecialArgs = specialArgs;
    };
  };
}
