{pkgs, ...}: let
  lib = pkgs.lib;
  GetMonacoNerdFont = pkgs.fetchzip {
    url = "https://github.com/thep0y/monaco-nerd-font/releases/download/v0.2.1/MonacoNerdFont.zip";
    sha256 = "sha256-Sal3Oa1H5Ng56VxTLToSjfSwsFFm0EtU3UksPa4P4+c=";
    stripRoot = false;
  };
  MonacoNerdFont = pkgs.stdenv.mkDerivation {
    name = "monaco-nerd-font";
    src = GetMonacoNerdFont;
    installPhase = ''
      mkdir -p $out/share/fonts/opentype
      cp -r $src/* $out/share/fonts/opentype
    '';
  };

  GetMonacoNerdFontMono = pkgs.fetchzip {
    url = "https://github.com/thep0y/monaco-nerd-font/releases/download/v0.2.1/MonacoNerdFontMono.zip";
    sha256 = "sha256-gu1n+GRgiCWBka01B+jrvU2a4T3u9y1/RlspOcWMErE=";
    stripRoot = false;
  };
  MonacoNerdFontMono = pkgs.stdenv.mkDerivation {
    name = "monaco-nerd-font-mono";
    src = GetMonacoNerdFontMono;
    installPhase = ''
      mkdir -p $out/share/fonts/opentype
      cp -r $src/* $out/share/fonts/opentype
    '';
  };
  # MonacoNerdFontMono = pkgs.callPackage ./fonts/build.nix {
  #   name = "monaco-nerd-font-mono";
  #   src = pkgs.fetchzip {
  #     url = "https://github.com/thep0y/monaco-nerd-font/releases/download/v0.2.1/MonacoNerdFontMono.zip";
  #     sha256 = "sha256-gu1n+GRgiCWBka01B+jrvU2a4T3u9y1/RlspOcWMErE=";
  #     stripRoot = false;
  #   };
  # };
in {
  environment.systemPackages = [MonacoNerdFont MonacoNerdFontMono];
  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;

    packages = with pkgs;
      [
        MonacoNerdFont
        MonacoNerdFontMono
        # icon fonts
        # nerdfonts
        mononoki
        material-design-icons
        font-awesome

        # Noto 系列字体是 Google 主导的，名字的含义是「没有豆腐」（no tofu），因为缺字时显示的方框或者方框被叫作 tofu
        # Noto 系列字族名只支持英文，命名规则是 Noto + Sans 或 Serif + 文字名称。
        # 其中汉字部分叫 Noto Sans/Serif CJK SC/TC/HK/JP/KR，最后一个词是地区变种。
        # noto-fonts # 大部分文字的常见样式，不包含汉字
        # noto-fonts-cjk # 汉字部分
        noto-fonts-emoji # 彩色的表情符号字体
        # noto-fonts-extra # 提供额外的字重和宽度变种

        # 思源系列字体是 Adobe 主导的。其中汉字部分被称为「思源黑体」和「思源宋体」，是由 Adobe + Google 共同开发的
        source-sans # 无衬线字体，不含汉字。字族名叫 Source Sans 3 和 Source Sans Pro，以及带字重的变体，加上 Source Sans 3 VF
        source-serif # 衬线字体，不含汉字。字族名叫 Source Code Pro，以及带字重的变体
        source-han-sans # 思源黑体
        source-han-serif # 思源宋体

        # nerd-fonts
        julia-mono
        dejavu_fonts
      ]
      ++ builtins.filter lib.attrsets.isDerivation
      (builtins.attrValues pkgs.nerd-fonts);

    # For example change:
    #    fonts.packages = [
    #      ...
    #      (pkgs.nerdfonts.override { fonts = [ "0xproto" "DroidSansMono" ]; })
    #    ]
    #  to
    #    fonts.packages = [
    #      ...
    #      pkgs.nerd-fonts._0xproto
    #      pkgs.nerd-fonts.droid-sans-mono
    #    ]
    #  or for all fonts
    #    fonts.packages = [ ... ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts)

    # user defined fonts
    # the reason there's Noto Color Emoji everywhere is to override DejaVu's
    # B&W emojis that would sometimes show instead of some Color emojis
    fontconfig.defaultFonts = {
      serif = ["Source Han Serif SC" "Source Han Serif TC" "Noto Color Emoji"];
      sansSerif = ["Source Han Sans SC" "Source Han Sans TC" "Noto Color Emoji"];
      monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };

  # https://wiki.archlinux.org/title/KMSCON
  services.kmscon = {
    # Use kmscon as the virtual console instead of gettys.
    # kmscon is a kms/dri-based userspace virtual terminal implementation.
    # It supports a richer feature set than the standard linux console VT,
    # including full unicode support, and when the video card supports drm should be much faster.
    enable = true;
    fonts = [
      {
        name = "Source Code Pro";
        package = pkgs.source-code-pro;
      }
    ];
    extraOptions = "--term xterm-256color";
    extraConfig = "font-size=12";
    # Whether to use 3D hardware acceleration to render the console.
    hwRender = true;
  };
}
