{pkgs, ...}: {
  # For Intel:
  /*
   options kvm_intel nested=1
  options kvm_intel emulate_invalid_guest_state=0
  options kvm ignore_msrs=1
  */
  virtualisation = {
    spiceUSBRedirection.enable = true;
    # kvm = {
    #   enable = true;
    # 启用嵌套虚拟化（可选，如果需要在虚拟机中运行虚拟机）
    # nestedVirtualisation = true;
    # };
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
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

    # for power management
    # services = {
    #   power-profiles-daemon = { enable = true; };
    #   upower.enable = true;
    # };
  };
}
