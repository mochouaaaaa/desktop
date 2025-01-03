{
  config,
  pkgs,
  ...
}: {
  # programs.jetbrains = {
  #   enable = true;
  #   packages = [
  #     pkgs.jetbrains.goland
  #   ];
  # };

  home.packages = with pkgs; [
    wechat-uos
    qq
    (telegram-desktop.override {
      unwrapped = telegram-desktop.unwrapped.overrideAttrs (finalAttrs: previousAttrs: {
        src = fetchFromGitHub {
          owner = "kukuruzka165";
          repo = "materialgram";
          rev = "refs/tags/v5.9.0.1";
          hash = "sha256-QmXwO8Dn+ATWGwN5smxOB2kxmJZETSMbqwFoR0t3luc=";
          fetchSubmodules = true;
        };
      });
    })

    mitmproxy # http/https proxy tool
    insomnia # REST client
    wireshark # network analyzer

    # communication

    # IDEs
    neovide
    # jetbrains.pycharm-professional
    # jetbrains.pycharm-professional
    # jetbrains.goland
    # jetbrains.datagrip

    # document
    obsidian

    # email
    thunderbird-latest-unwrapped

    # api client
    hoppscotch
  ];
}
