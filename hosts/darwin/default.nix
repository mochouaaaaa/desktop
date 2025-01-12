_: let
  hostname = "mochou";
in {
  networking.hostName = hostname;
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;
}
