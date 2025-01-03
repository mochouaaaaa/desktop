{mylib, ...}: {
  imports = mylib.scanPaths ./. ++ [./jetbrains/jetbrains.nix];
}
