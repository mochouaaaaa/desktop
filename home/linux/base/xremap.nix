{
  services.xremap = {
    enable = true;
    withWlroots = true;
    watch = true;
    # debug = true;
    config = {
      modmap = [
        {
          name = "Global";
          remap = {"CapsLock" = "Esc";}; # globally remap CapsLock to Esc
        }
      ];
      keymap = [
        {
          name = "Replace Super/Command With Ctrl";
          exact_match = true;
          application.not = ["kitty"];
          remap = {
            "SUPER-c" = "C-c";
            "SUPER-v" = "C-v";
            "SUPER-x" = "C-x";
            "SUPER-w" = "C-w";
            "SUPER-a" = "C-a";
            "SUPER-z" = "C-z";
            "SUPER-t" = "C-t";
            "SUPER-f" = "C-f";
            "SUPER-r" = "C-r";
          };
        }
      ];
    };
  };
}
