{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    waybar # the status bar
    swaybg # the wallpaper
    swaylock-effects
    wlogout # logout menu
    wl-clipboard # copying and pasting
    hyprpicker # color picker
    hypridle
    envsubst

    pkgs-unstable.hyprshot # screen shot
    grim # taking screenshots
    slurp # selecting a region to screenshot
    wf-recorder # screen recording

    swww
    wallust
    rofi-wayland
    dunst
    cliphist
    wttrbar

    yad # a fork of zenity, for creating dialogs

    # audio
    alsa-utils # provides amixer/alsamixer/...
    mpd # for playing system sounds
    mpc-cli # command-line mpd client
    ncmpcpp # a mpd client with a UI
    networkmanagerapplet # provide GUI app: nm-connection-editor
  ];

  home.file = {
    ".config/dunst" = {
      source = ./dunst;
      recursive = true;
      force = true;
    };
    ".config/waybar" = {
      source = ./waybar;
      recursive = true;
      force = true;
    };
    # ".config/wlogout" = {
    #   source = ./wlogout;
    #   recursive = true;
    # force = true;
    # };
    ".config/swaync" = {
      source = ./swaync;
      recursive = true;
      force = true;
    };
    ".config/swaylock" = {
      source = ./swaylock;
      recursive = true;
      force = true;
    };
    ".config/rofi" = {
      source = ./rofi;
      recursive = true;
      force = true;
    };
  };
}
