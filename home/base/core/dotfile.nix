{
  config,
  pkgs,
  myvars,
  ...
}: let
  dotfiles = "${config.home.homeDirectory}" + myvars.dotfilePath;
  filtereg = builtins.filter (f: !(builtins.substring 0 1 f == "." || builtins.match ".*\\..*" f != null));

  # 获取 links 目录中的所有文件名
  linkFiles = builtins.filter(f: builtins.match ".*\\..*" f == null) ( builtins.attrNames (builtins.readDir (dotfiles + "/zsh/links")));

  # 为每个文件创建符号链接
  homeDotfiles = builtins.listToAttrs (map (linkFile: {
      name = "." + linkFile;
      value = {source = config.lib.file.mkOutOfStoreSymlink (dotfiles + "/zsh/links/" + linkFile);};
    })
    linkFiles);

  allFiles = builtins.readDir dotfiles;
  visibleFiles = filtereg (builtins.attrNames allFiles);

  configFiles = builtins.listToAttrs (map (linkFile: {
      name = "/.config/" + linkFile;
      value = {
        source = config.lib.file.mkOutOfStoreSymlink (dotfiles + "/" + linkFile);
      };
    })
    visibleFiles);
in {
  # home.file = pkgs.lib.mkIf dotfilesExist homeDotfiles // pkgs.lib.mkIf dotfilesExist configFiles;
  home.file = homeDotfiles // configFiles;
}
