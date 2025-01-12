{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    linuxKernel.packages.linux_zen.vmware
    virt-viewer
    libvirt
    bridge-utils # 如果需要桥接网络
    dnsmasq # 如果需要使用 dnsmasq 管理网络
    iptables # 防火墙规则
    ebtables # 网桥规则
    iproute2 # 网络工具
    swtpm # 用于虚拟 TPM 设备（可选）
    # quickemu

    # This script is used to install the arm translation layer for waydroid
    # so that we can install arm apks on x86_64 waydroid
    #
    # https://github.com/casualsnek/waydroid_script
    # https://github.com/AtaraxiaSjel/nur/tree/master/pkgs/waydroid-script
    # https://wiki.archlinux.org/title/Waydroid#ARM_Apps_Incompatible
    # nur-ataraxiasjel.packages.${pkgs.system}.waydroid-script

    # Need to add [File (in the menu bar) -> Add connection] when start for the first time
    virt-manager

    # QEMU/KVM(HostCpuOnly), provides:
    # qemu-storage-daemon
    # qemu-edid
    # qemu-ga
    # qemu-pr-helper
    # qemu-nbd
    # elf2dmp
    # qemu-img
    # qemu-io
    # qemu-kvm
    # qemu-system-x86_64
    # qemu-system-aarch64
    # qemu-system-i386
    qemu_kvm

    # Install QEMU(other architectures), provides:
    #   ......
    #   qemu-loongarch64 qemu-system-loongarch64
    #   qemu-riscv64 qemu-system-riscv64 qemu-riscv32  qemu-system-riscv32
    #   qemu-system-arm qemu-arm qemu-armeb qemu-system-aarch64 qemu-aarch64 qemu-aarch64_be
    #   qemu-system-xtensa qemu-xtensa qemu-system-xtensaeb qemu-xtensaeb
    #   ......
    qemu
  ];

  # For Intel:
  /*
  options kvm_intel nested=1
  options kvm_intel emulate_invalid_guest_state=0
  options kvm ignore_msrs=1
  */
  boot.kernelModules = ["vfio-pci"];

  services.spice-vdagentd.enable = true; # 启用 Spice vdagent
  virtualisation = {
    vmware = {
      host = {
        enable = true;
        package = pkgs.vmware-workstation;
      };
      guest = {enable = true;};
    };

    virtualbox = {
      host = {
        enable = true;
        enableExtensionPack = true;
      };
      guest = {
        enable = true;
        dragAndDrop = true;
      };
    };

    docker = {
      enable = true;
      daemon.settings = {
        # enables pulling using containerd, which supports restarting from a partial pull
        # https://docs.docker.com/storage/containerd/
        "features" = {"containerd-snapshotter" = true;};
      };

      # start dockerd on boot.
      # This is required for containers which are created with the `--restart=always` flag to work.
      enableOnBoot = true;
      storageDriver = "btrfs";
    };

    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        vhostUserPackages = [pkgs.virtiofsd];
        ovmf = {
          enable = true;
          #packages = [(pkgs.unstable.OVMF.override {
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            })
            .fd
          ];
        };
      };
    };
  };
}
