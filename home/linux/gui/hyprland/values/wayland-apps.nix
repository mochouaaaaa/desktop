{
  pkgs,
  nur-ryan4yin,
  ...
}: {
  home.packages = [
    # pkgs.firefox
    # pkgs.firefox-wayland
    # pkgs.nixpaks.firefox
    # pkgs.nixpaks.firefox-desktop-item
  ];

  programs = {
    firefox = {
      enable = true;
      policies = {
        ExtensionSettings = with builtins; let
          extension = shortId: uuid: {
            name = uuid;
            value = {
              install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
              installation_mode = "normal_installed";
            };
          };
        in
          listToAttrs [
            (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
            (extension "immersive-translate" "{5efceaa7-f3a2-4e59-a54b-85319448e305}")
            (extension "tampermonkey" "firefox@tampermonkey.net")
            (extension "vimium" "{d7742d87-e61d-4b78-b8a1-b469842139fa}")
            (extension "GitZip" "gitzip-firefox-addons@gitzip.org")
            (extension "ublock-origin" "uBlock0@raymondhill.net")
            (extension "imagus" "{00000f2a-7cde-4f20-83ed-434fcb420d71}")
          ];
      };
    };

    # source code: https://github.com/nix-community/home-manager/blob/master/modules/programs/chromium.nix
    google-chrome = {
      enable = true;

      # https://wiki.archlinux.org/title/Chromium#Native_Wayland_support
      commandLineArgs = [
        "--ozone-platform-hint=auto"
        "--ozone-platform=wayland"
        "--enable-features=UseOzonePlatform"
        # make it use GTK_IM_MODULE if it runs with Gtk4, so fcitx5 can work with it.
        # (only supported by chromium/chrome at this time, not electron)
        "--gtk-version=4"
        # make it use text-input-v1, which works for kwin 5.27 and weston
        "--enable-wayland-ime"

        # enable hardware acceleration - vulkan api
        # "--enable-features=Vulkan"
      ];
    };

    vscode = {
      enable = true;
      # let vscode sync and update its configuration & extensions across devices, using github account.
      userSettings = {};
      package =
        (pkgs.vscode.override {
          isInsiders = true;
          # https://wiki.archlinux.org/title/Wayland#Electron
          commandLineArgs = [
            "--ozone-platform-hint=auto"
            "--ozone-platform=wayland"
            # make it use GTK_IM_MODULE if it runs with Gtk4, so fcitx5 can work with it.
            # (only supported by chromium/chrome at this time, not electron)
            "--gtk-version=4"
            # make it use text-input-v1, which works for kwin 5.27 and weston
            "--enable-wayland-ime"

            "--password-store=gnome" # use gnome-keyring as password store
          ];
        })
        .overrideAttrs (oldAttrs: rec {
          # Use VSCode Insiders to fix crash: https://github.com/NixOS/nixpkgs/issues/246509
          src = builtins.fetchTarball {
            url = "https://update.code.visualstudio.com/latest/linux-x64/insider";
            sha256 = "sha256:04p0nynds4vgn2r7daffwxajp84dpnqx3599y5jidpxlrgn5ihq7";
          };
          version = "latest";
        });
    };
  };
}
