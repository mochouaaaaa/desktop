{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; (
    # -*- Data & Configuration Languages -*-#
    [
      #-- nix
      # nil
      nixd
      statix # Lints and suggestions for the nix programming language
      deadnix # Find and remove unused code in .nix source files
      alejandra # Nix Code Formatter
      nixfmt-classic
    ]
    ++
    #-*- General Purpose Languages -*-#
    [
      #-- c/c++
      # rocmPackages_5.llvm.clang-unwrapped
      cmake
      cmake-language-server
      gnumake
      checkmake
      # c/c++ compiler, required by nvim-treesitter!
      gcc
      gdb
      # c/c++ tools with clang-tools, the unwrapped version won't
      # add alias like `cc` and `c++`, so that it won't conflict with gcc
      # llvmPackages.clang-unwrapped
      clang-tools
      lldb
      vscode-extensions.vadimcn.vscode-lldb.adapter # codelldb - debugger

      #-- rust
      # we'd better use the rust-overlays for rust development
      # pkgs-unstable.rust-analyzer
      pkgs-unstable.cargo # rust package manager
      # pkgs-unstable.rustfmt
      # pkgs-unstable.clippy # rust linter
    ]
    ++ [
      # proselint # English prose linter

      #-- verilog / systemverilog
      # verible

      #-- Optional Requirements:
      # nodePackages.prettier # common code formatter
      fzf
      gdu # disk usage analyzer, required by AstroNvim
    ]
  );
}
