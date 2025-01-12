{
  config,
  pkgs,
  mylib,
  ...
}: {
  programs = {
    neovim = {
      enable = true;
      extraLuaPackages = ps: [ps.magick];
      extraPackages = [pkgs.imagemagick];
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;

      enableZshIntegration = true;
      enableBashIntegration = true;
    };
  };
}
