{
  pkgs,
  lib,
  nur-ryan4yin,
  ...
}: let
  package = pkgs.hyprland;
in {
  # NOTE:
  # We have to enable hyprland/i3's systemd user service in home-manager,
  # so that gammastep/wallpaper-switcher's user service can be start correctly!
  # they are all depending on hyprland/i3's user graphical-session
  wayland.windowManager.hyprland = {
    inherit package;
    enable = true;
    settings = {
      source = "${
        nur-ryan4yin.packages.${pkgs.system}.catppuccin-hyprland
      }/themes/mocha.conf";
      env = [
        "NIXOS_OZONE_WL,1" # for any ozone-based browser & electron apps to run on wayland
        "MOZ_ENABLE_WAYLAND,1" # for firefox to run on wayland
        "MOZ_WEBRENDER,1"
        # misc
        "_JAVA_AWT_WM_NONREPARENTING,1"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_QPA_PLATFORM,wayland"
        "SDL_VIDEODRIVER,wayland"
        "GDK_BACKEND,wayland"
      ];
    };
    extraConfig = builtins.readFile ../conf/hyprland/hyprland.conf;
    # gammastep/wallpaper-switcher need this to be enabled.
    systemd = {
      enable = true;
      variables = ["--all"];
    };
  };

  # NOTE: this executable is used by greetd to start a wayland session when system boot up
  # with such a vendor-no-locking script, we can switch to another wayland compositor without modifying greetd's config in NixOS module
  home.file.".wayland-session" = {
    source = "${package}/bin/Hyprland";
    executable = true;
  };

  # hyprland configs, based on https://github.com/notwidow/hyprland
  xdg.configFile = {
    "hypr" = {
      source = ../conf/hyprland;
      recursive = true;
      executable = true;
    };
    "dunst" = {
      source = ../conf/dunst;
      recursive = true;
      executable = true;
    };
    "waybar" = {
      source = ../conf/waybar;
      recursive = true;
      executable = true;
    };
    "wlogout" = {
      source = ../conf/wlogout;
      recursive = true;
      executable = true;
    };
    "swaync" = {
      source = ../conf/swaync;
      recursive = true;
    };
    "swaylock" = {
      source = ../conf/swaylock;
      recursive = true;
      executable = true;
    };
    "rofi" = {
      source = ../conf/rofi;
      recursive = true;
      executable = true;
    };
    # music player - mpd
    # "mpd" = {
    #   source = ../conf/mpd;
    #   recursive = true;
    # };
  };
}
