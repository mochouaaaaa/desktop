{pkgs, ...}: let
  # fcitx5Theme = pkgs.fetchFromGitHub {
  #   owner = "catppuccin";
  #   repo = "fcitx5";
  #   rev = "main";
  #   sha256 = "sha256-1IqFVTEY6z8yNjpi5C+wahMN1kpt0OJATy5echjPXmc=";
  # };
  fcitx5Config = pkgs.fetchFromGitHub {
    owner = "Mintimate";
    repo = "oh-my-rime";
    rev = "main";
    sha256 = "sha256-kD7XJrjyVg28tROqzXPsJgf6DUpmYrQJBf6W2kgA32k=";
  };

  cleanedFcitx5Config =
    pkgs.runCommand "cleaned-fcitx5-config" {
      buildInputs = [pkgs.coreutils];
    } ''
      mkdir -p $out

      find ${fcitx5Config} -name "*.yaml" \
          -not -name "README*.yaml" \
          -not -name "*terra*.yaml" \
          -not -name "*wubi*.yaml" \
          -not -name "*ibus*.yaml" \
          -not -name "*double_pinyin*.yaml" \
          -not -name "*t9*.yaml" \
          -exec cp -r -t $out {} +

      cp -r ${fcitx5Config}/dicts $out/
      cp -r ${fcitx5Config}/lua $out/
      cp -r ${fcitx5Config}/opencc $out/
      cp -r ${fcitx5Config}/plum $out/
      cp -r ${fcitx5Config}/preview $out/
      cp -r ${fcitx5Config}/tools $out/

    '';
in {
  home.file = {
    ".local/share/fcitx5/rime" = {
      source = cleanedFcitx5Config;
      recursive = true;
    };
    # ".local/share/fcitx5/themes" = {
    #   source = "${fcitx5Theme}/src";
    #   recursive = true;
    # };

    ".local/share/fcitx5/rime/fcitx5.custom.yaml" = {
      source = ./fcitx5.custom.yaml;
      force = true;
    };
    ".local/share/fcitx5/rime/default.custom.yaml" = {
      source = ./default.custom.yaml;
      force = true;
    };
  };

  xdg.configFile = {
    "fcitx5/profile" = {
      source = ./profile;
      force = true;
    };
    "fcitx5/conf/classicui.conf" = {
      source = ./classicui.conf;
      force = true;
    };
    "fcitx5/conf/rime.conf" = {
      source = ./rime.conf;
      force = true;
    };
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      # librime
      fcitx5-rime
      fcitx5-lua
      fcitx5-configtool
      fcitx5-chinese-addons
      fcitx5-gtk
    ];
  };

  # home.packages = with pkgs; [ librime ];

  # home.sessionVariables = {
  #   QT_IM_MODULE = pkgs.lib.mkForce "fcitx5";
  #   GTK_IM_MODULE = pkgs.lib.mkForce "fcitx5";
  #   XMODIFIERS = pkgs.lib.mkForce "@im=fcitx5";
  # };
}
