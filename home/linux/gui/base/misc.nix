{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    # GUI apps
    # e-book viewer(.epub/.mobi/...)
    # do not support .pdf
    foliate

    # remote desktop(rdp connect)
    remmina
    freerdp # required by remmina

    # misc
    # flameshot
    (flameshot.overrideAttrs (oldAttrs: rec {
      name = "flameshot-with-grim"; # 修改包名，避免冲突
      buildInputs =
        oldAttrs.buildInputs
        ++ [grim slurp]; # 确保 grim 和 slurp 是构建依赖
      cmakeFlags =
        oldAttrs.cmakeFlags
        ++ lib.optionals stdenv.hostPlatform.isLinux
        ["-DUSE_WAYLAND_GRIM=ON"]; # 启用 USE_WAYLAND_GRIM
    }))
    ventoy # multi-boot usb creator
  ];

  # GitHub CLI tool
  programs.gh = {enable = true;};
}
