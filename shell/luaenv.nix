{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  buildInputs = [
    pkgs.readline
    pkgs.ncurses
    pkgs.libedit
    pkgs.pkg-config # Crucial!
    pkgs.stdenv # Often needed for standard build tools
    # Add any other build dependencies your project needs here
  ];
  shellHook = ''
    export PKG_CONFIG_PATH="${pkgs.readline.dev}/lib/pkgconfig:${pkgs.ncurses.dev}/lib/pkgconfig:${pkgs.libedit.dev}/lib/pkgconfig:$PKG_CONFIG_PATH"
  '';
}
