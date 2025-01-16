{ config, pkgs, myvars, ... }:
let
  # jetbra = pkgs.fetchFromGitHub {
  #   owner = "WhyFeelSad";
  #   repo = "jetbra";
  #   rev = "631a187dfe45652f23a0d0b0a030abccc6c648f9";
  #   sha256 = "sha256-FvjwrmRE9xXkDIIkOyxVEFdycYa/t2Z0EgBueV+26BQ=";
  # };
  jetbrainsConfig = enable: {
    pycharm = enable && myvars.jetbrains.pycharm;
    goland = enable && myvars.jetbrains.goland;
    datagrip = enable && myvars.jetbrains.datagrip;
    clion = enable && myvars.jetbrains.clion;
  };
  isDarwin = pkgs.stdenv.isDarwin;

  initjetbrains = jetbrainsConfig (myvars.jetbrains.enable && !isDarwin);

  jetbra = pkgs.stdenv.mkDerivation {
    name = "jetbra";
    src = ./JetBrains; # 将本地路径作为源

    installPhase = ''
      mkdir -p $out
      cp -r * $out # 将所有文件复制到输出目录
    '';
  };

  vmoptions = ''
    --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED
    --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED

    -javaagent:${jetbra}/ja-netfilter.jar=jetbrains
    -Dawt.toolkit.name=WLToolkit
  '';
in {
  home.packages = with pkgs;
    [ ] ++ (lib.optionals (initjetbrains.pycharm) [
      (pkgs.jetbrains.pycharm-professional.override { vmopts = vmoptions; })
    ]) ++ (lib.optionals (initjetbrains.goland)
      [ (pkgs.jetbrains.goland.override { vmopts = vmoptions; }) ])
    ++ (lib.optionals (initjetbrains.datagrip)
      [ (pkgs.jetbrains.datagrip.override { vmopts = vmoptions; }) ])
    ++ (lib.optionals (initjetbrains.clion)
      [ (pkgs.jetbrains.clion.override { vmopts = vmoptions; }) ]);
}
