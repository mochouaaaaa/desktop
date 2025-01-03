{
  pkgs,
  config,
  ...
}: {
  # If your themes for mouse cursor, icons or windows don’t load correctly,
  # try setting them with home.pointerCursor and gtk.theme,
  # which enable a bunch of compatibility options that should make the themes load in all situations.

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  # set dpi for 4k monitor
  xresources.properties = {
    # dpi for Xorg's font
    "Xft.dpi" = 150;
    # or set a generic dpi
    "*.dpi" = 150;
  };

  # gtk's theme settings, generate files:
  #   1. ~/.gtkrc-2.0
  #   2. ~/.config/gtk-3.0/settings.ini
  #   3. ~/.config/gtk-4.0/settings.ini
  gtk = {
    enable = true;

    font = {
      name = "Monaco Nerd Font";
      package = pkgs.noto-fonts;
      size = 11;
    };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    iconTheme = {
      name = "whitesur-icon-theme";
      package = pkgs.papirus-icon-theme.override {};
    };

    theme = {
      name = "WhiteSur-dark"; # 或 "WhiteSur-light"，根据主题的具体名称调整
      package = pkgs.whitesur-gtk-theme;

      # name = "WhiteSur-dark";
      # package = pkgs.fetchzip {
      #   url = "https://github.com/vinceliuice/WhiteSur-gtk-theme/archive/refs/tags/v2.0.zip"; # 替换为正确的 URL
      #   sha256 = "sha256:SSGb7EdJN8E4N8b98VO7oFTeOmhKEo/0qhso9410ihg="; # 替换为正确的 SHA256 值
      # };
    };
  };
}
