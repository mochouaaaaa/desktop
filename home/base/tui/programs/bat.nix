{pkgs, ...}: {
  programs = {
    bat = {
      enable = true;
      package = pkgs.bat;
      extraPackages = with pkgs.bat-extras; [batdiff batman batgrep batwatch];
      themes = {
        catppuccin-mocha = let
          catppuccinMochaTheme = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "699f60fc8ec434574ca7451b444b880430319941";
            sha256 = "sha256-6fWoCH90IGumAMc4buLRWL0N61op+AuMNN9CAR9/OdI=";
          };
        in {
          src = catppuccinMochaTheme + "/themes";
          file = "Catppuccin Mocha.tmTheme"; # 文件名包含空格，需要注意
        };
      };
      config = {
        theme = "Catppuccin Mocha"; # 设置使用 catppuccin-mocha 主题
        pager = "less -FRX";
      };
    };
  };
}
