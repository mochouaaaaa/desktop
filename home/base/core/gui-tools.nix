{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    mitmproxy # http/https proxy tool
    insomnia # REST client
    wireshark # network analyzer

    # communication

    # document
    obsidian

    # email
    thunderbird-latest-unwrapped

    # api client
    hoppscotch
  ];
}
