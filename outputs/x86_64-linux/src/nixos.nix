{
  # NOTE: the args not used in this file CAN NOT be removed!
  # because haumea pass argument lazily,
  # and these arguments are used in the functions like `mylib.nixosSystem`, `mylib.colmenaSystem`, etc.
  inputs,
  lib,
  myvars,
  mylib,
  system,
  genSpecialArgs,
  ...
} @ args: let
  name = "mochou";
  base-modules = {
    nixos-modules =
      map mylib.relativeToRoot ["hosts/nixos" "modules/nixos/desktop.nix"]
      ++ [inputs.honkai-railway-grub-theme.nixosModules.${system}.default];

    home-modules =
      map mylib.relativeToRoot ["home/linux/gui.nix"]
      ++ [
        inputs.nix-flatpak.homeManagerModules.nix-flatpak
        inputs.xremap-flake.homeManagerModules.default
      ];
  };

  modules-hyprland = {
    nixos-modules =
      [{modules.desktop.wayland.enable = true;}]
      ++ base-modules.nixos-modules;
    home-modules =
      [{modules.desktop.hyprland.enable = true;}]
      ++ base-modules.home-modules;
  };
in {
  nixosConfigurations = {
    # host with hyprland compositor
    "${name}" = mylib.nixosSystem (modules-hyprland // args);
  };

  # generate iso image for hosts with desktop environment
  packages = {
    "${name}" = inputs.self.nixosConfigurations."${name}".config.formats.iso;
  };
}
