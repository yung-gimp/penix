{
  config,
  lib,
  ...
}: let
  cfg = config.cm.hyprland;
in {
  wayland.windowManager.hyprland.settings = lib.mkIf cfg.enable {
    monitor = [
      "desc:ASUSTek COMPUTER INC VG32VQ1B S9LMTF038670, 2560x1440@165, 0x0, 1"
      "desc:ASUSTek COMPUTER INC ASUS VG32VQ1B 0x0003A472, 2560x1440@90, 2560x-1120, 1, transform, 3"
      "desc:Samsung Electric Company SAMSUNG 0x01000E00, 3840x2160@60, 0x0, 3"
    ];
    workspace = [
      "1, monitor:desc:ASUSTek COMPUTER INC VG32VQ1B S9LMTF038670, default:true"
      "2, monitor:desc:ASUSTek COMPUTER INC VG32VQ1B S9LMTF038670"
      "3, monitor:desc:ASUSTek COMPUTER INC VG32VQ1B S9LMTF038670"
      "4, monitor:desc:ASUSTek COMPUTER INC VG32VQ1B S9LMTF038670"
      "5, monitor:desc:ASUSTek COMPUTER INC ASUS VG32VQ1B 0x0003A472, default:true"
      "6, monitor:desc:ASUSTek COMPUTER INC ASUS VG32VQ1B 0x0003A472"
      "7, monitor:desc:ASUSTek COMPUTER INC ASUS VG32VQ1B 0x0003A472"
      "8, monitor:desc:ASUSTek COMPUTER INC ASUS VG32VQ1B 0x0003A472"
    ];
  };
}
