{
  pkgs,
  name,
  src,
  ...
}:
pkgs.stdenv.mkDerivation {
  inherit name src;
  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp -r $src/* $out/share/fonts/opentype
  '';
}
