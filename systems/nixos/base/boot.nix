{
  pkgs,
  lib,
  ...
}: {
  boot.loader = {
    systemd-boot = {
      # we use Git for version control, so we don't need to keep too many generations.
      configurationLimit = lib.mkDefault 15;
      # pick the highest resolution for systemd-boot's console.
      consoleMode = lib.mkDefault "max";
    };
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      extraEntries = ''
        menuentry "Windows" {
                    search --file --no-floppy --set=root /EFI/Microsoft/Boot/bootmgfw.efi
                    chainloader (''${root})/EFI/Microsoft/Boot/bootmgfw.efi
                }
        menuentry "Ubuntu24.10" {
                    insmod part_gpt
                    insmod fat
                    search --no-floppy --fs-uuid --set=root C14D-581B
                    chainloader /EFI/ubuntu/shimx64.efi
                }
      '';
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    timeout = lib.mkDefault 15; # wait for x seconds to select the boot entry
  };

  honkai-railway-grub-theme = {
    enable = true;
    # Remember
    theme = "RuanMei";
  };

  # https://dev.leiyanhui.com/nixos/kvm-qemu/
  # <https://github.com/kholia/OSX-KVM>
  # Required by AMD boxes for OSX-KVM
  boot.extraModprobeConfig = ''
    options kvm_amd nested=1
    options bt_coex_active=0 swcrypto=1 11n_disable=8
    options kvm ignore_msrs=1 report_ignored_msrs=0
  '';
}
