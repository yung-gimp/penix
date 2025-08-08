{lib, ...}: {
  imports = lib.map (n: ./. + /${n}) (lib.filter (n: n != "default.nix") (lib.attrNames (builtins.readDir ./.)));
  programs = {
    home-manager.enable = true;
    rofi.enable = true;
  };
}
