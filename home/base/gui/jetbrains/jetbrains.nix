# { config
# , pkgs
# , lib
# , ...
# }:
# let
#   inherit (lib) types;
#   cfg = config.programs.jetbrains;
#   patchIDEs = builtins.map (ide: ide.overrideAttrs {
#     vmopts = ''
#       --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED
#       --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED
#       -javaagent:${pkgs.ja-netfilter}/ja-netfilter.jar=jetbrains
#     '';
#   });
# in
# {
#   options = {
#     programs.jetbrains = {
#       enable = lib.mkOption {
#         type = types.bool;
#         default = false;
#         description = "Whether to enable JetBrains via ja-netfilter crack.";
#       };
#       packages = lib.mkOption {
#         type = types.listOf types.package;
#         default = [ ];
#         description = "A list of packages need to enable ja-netfilter.";
#         example = [ pkgs.jetbrains.idea-ultimate ];
#       };
#     };
#   };
#   config = lib.mkIf (cfg.enable && cfg.packages != [ ]) {
#     programs.jetbrains-remote = {
#       enable = true;
#       ides = patchIDEs cfg.packages;
#     };
#     home.packages = (patchIDEs cfg.packages) ++ [ pkgs.ja-netfilter ];
#   };
#   # https://jetbra.in/5d84466e31722979266057664941a71893322460
# }
{ pkgs, ... }:
let
  jetbra = pkgs.fetchFromGitHub {
    owner = "WhyFeelSad";
    repo = "jetbra";
    rev = "631a187dfe45652f23a0d0b0a030abccc6c648f9";
    sha256 = "sha256-FvjwrmRE9xXkDIIkOyxVEFdycYa/t2Z0EgBueV+26BQ=";
  };

  vmoptions = ''
    --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED
    --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED

    -javaagent:${jetbra}/ja-netfilter.jar=jetbrains
    -Dawt.toolkit.name=WLToolkit
  '';
in
{
  home.packages = with pkgs; [
    # (pkgs.jetbrains.idea-ultimate.override {
    #   vmopts = vmoptions;
    # })

    (pkgs.jetbrains.goland.override {
      vmopts = vmoptions;
    })

    # (pkgs.jetbrains.gateway.override {
    #   vmopts = vmoptions;
    # })
  ];
}
