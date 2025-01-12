{
  config,
  lib,
  pkgs,
  myvars,
  ...
}: {
  options.diskOptions = {
    enable = lib.mkEnableOption "Enable disk options";
    name = lib.mkOption {
      type = lib.types.str;
      default = "sda";
      description = "The name of the disk to configure.";
    };
    filesystem = lib.mkOption {
      type = lib.types.str;
      default = "btrfs";
      description = "The filesystem to use for the root partition.";
    };
  };
  config = {};
}
