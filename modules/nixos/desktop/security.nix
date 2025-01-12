{ config, pkgs, ... }: {
  # nix.extraOptions = ''
  #   !include ${config.age.secrets.nix-access-tokens.path}
  # '';

  # security with polkit
  security.polkit = {
    enable = true;
    # adminIdentities = [ ];
  };
  # security with gnome-kering
  services.gnome.gnome-keyring.enable = false;
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.loginLimits = [{
    domain = "@users";
    item = "rtprio";
    type = "-";
    value = 1;
  }];

  # gpg agent with pinentry
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
    enableSSHSupport = false;
    settings.default-cache-ttl = 4 * 60 * 60; # 4 hours
  };
}
