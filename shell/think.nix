{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    clang
    cmake
    llvmPackages.libcxx
    xz.dev
    tcl-9_0
    # (tcl-8_5.overrideAttrs (oldAttrs: rec {
    #   configureFlags = oldAttrs.configureFlags ++ [
    #     "ac_cv_header_stdc=yes"
    #   ];
    # }))
    tk-9_0.dev
    sqlite.dev
    zlib.dev
    libffi.dev
    readline.dev
    libedit.dev
    bzip2.dev
    libxcrypt
    openssl.dev
    ncurses.dev
    pkg-config
  ];

  # shellHook = ''
  #   export TCL_LIBRARY="${pkgs.tcl-9_0}/lib/tcl${pkgs.tcl.version}"
  #   export TK_LIBRARY="${pkgs.tk-9_0}/lib/tk${pkgs.tk.version}"
  # '';
}
