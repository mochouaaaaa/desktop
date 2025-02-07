{pkgs, ...}: {
  home.packages = with pkgs; [
        # Automatically trims your branches whose tracking remote refs are merged or gone
    # It's really useful when you work on a project for a long time.
    git-trim
    gitleaks

    mihomo
    clash-verge-rev
    # DB
    # navicat-premium

    authenticator
    bitwarden-cli
    bitwarden-desktop

    wechat-uos
    qq
    (telegram-desktop.override {
      unwrapped =
        telegram-desktop.unwrapped.overrideAttrs
        (finalAttrs: previousAttrs: {
          src = fetchFromGitHub {
            owner = "kukuruzka165";
            repo = "materialgram";
            rev = "refs/tags/v5.9.0.1";
            hash = "sha256-QmXwO8Dn+ATWGwN5smxOB2kxmJZETSMbqwFoR0t3luc=";
            fetchSubmodules = true;
          };
        });
    })
    thunderbird-latest-unwrapped

    netease-cloud-music-gtk
  ];
}
