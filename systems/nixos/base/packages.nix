{pkgs, ...}: {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    qemu_kvm
    virt-manager
    virt-viewer
    libvirt
    bridge-utils # 如果需要桥接网络
    dnsmasq # 如果需要使用 dnsmasq 管理网络
    iptables # 防火墙规则
    ebtables # 网桥规则
    iproute2 # 网络工具
    swtpm # 用于虚拟 TPM 设备（可选）

    # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    neovim
    just # justfile

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    tcpdump # network sniffer
    lsof # list open files

    # ebpf related tools
    # https://github.com/bpftrace/bpftrace
    #bpftrace # powerful tracing tool
    bpftop # monitor BPF programs
    bpfmon # BPF based visual packet rate monitor

    bc
    # system monitoring
    rpm
    dpkg
    sysstat
    iotop
    iftop
    btop
    nmon
    sysbench
    grimblast
    ags

    # system tools
    psmisc # killall/pstree/prtstat/fuser/...
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    hdparm # for disk performance, command
    dmidecode # a tool that reads information about your system's hardware from the BIOS according to the SMBIOS/DMI standard
    parted

    #  export env
    clang
    cmake
    llvmPackages.libcxx
    xz.dev
    tcl-9_0
    (tcl-8_5.overrideAttrs (oldAttrs: rec {
      configureFlags =
        oldAttrs.configureFlags
        ++ [
          "ac_cv_header_stdc=yes"
        ];
    }))

    tk-9_0.dev
    sqlite.dev
    zlib.dev
    libffi.dev
    readline.dev
    libedit.dev
    bzip2.dev
    openssl.dev
    ncurses.dev
    pkg-config
  ];

  environment.variables = with pkgs; {
    EDITOR = "nvim";
    XDG_TERMINAL = "${kitty}/bin/kitty '$@'";

    SQLITE_CLIB_PATH = "${sqlite.out}/lib/libsqlite3.so.0";

    PKG_CONFIG_PATH = lib.concatStringsSep ":" [
      "${readline.dev}/lib/pkgconfig"
      "${ncurses.dev}/lib/pkgconfig"
      "${libedit.dev}/lib/pkgconfig"
    ];

    LDFLAGS = pkgs.lib.makeLibraryPath [zlib xz sqlite tcl-9_0 tk-9_0 readline libffi bzip2 ncurses libedit openssl];

    TCL_LIBRARY = "${tcl-9_0}/lib/tcl${tcl.version}";
    TK_LIBRARY = "${tk-9_0}/lib/tk${tk.version}";

    CPPFLAGS = "-I${pkgs.zlib.dev}/include -I${pkgs.ncurses.dev}/include  -I${pkgs.tk-9_0.dev}/include -I${pkgs.xz.dev}/include -I${pkgs.sqlite.dev}/include -I${pkgs.tk-9_0.dev}/include -I${pkgs.libffi.dev}/include -I${pkgs.readline.dev}/include -I${pkgs.bzip2.dev}/include -I${pkgs.openssl.dev}/include";
    CXXFLAGS = "-I${pkgs.zlib.dev}/include -I${pkgs.ncurses.dev}/include -I${pkgs.xz.dev}/include -I${pkgs.sqlite.dev}/include -I${pkgs.tk-9_0.dev}/include -I${pkgs.readline.dev}/include -I${pkgs.bzip2.dev}/include -I${pkgs.openssl.dev}/include";
    CFLAGS = "-I${pkgs.openssl.dev}/include";
    CONFIGURE_OPTS = "-with-openssl=${pkgs.openssl.dev}";
  };

  # BCC - Tools for BPF-based Linux IO analysis, networking, monitoring, and more
  # https://github.com/iovisor/bcc
  programs.bcc.enable = true;
}
