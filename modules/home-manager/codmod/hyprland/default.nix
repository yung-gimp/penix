{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.cm.hyprland;
in
{
  options.cm.hyprland.enable = lib.mkEnableOption "Enable hyprland";

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };

        xwayland = {
          enabled = true;
          force_zero_scaling = false;
          use_nearest_neighbor = true;
        };
      };
    };

    home = {
      file.".local/share/icons/bibata-hyprcursor" = {
        recursive = true;
        source = fetchTarball {
          url = "https://github.com/LOSEARDES77/Bibata-Cursor-hyprcursor/releases/download/1.0/hypr_Bibata-Modern-Classic.tar.gz";
          sha256 = "08q5l2sywc0s70zdn7jvr0rbzz0w8j18wmlkf2x1l64y93lbvzsj";
        };
      };

      packages = with pkgs; [
        playerctl
        hyprpolkitagent
      ];

      pointerCursor = {
        enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
        gtk.enable = true;
        hyprcursor = {
          enable = true;
        };
      };
    };

    programs.bash.profileExtra = ''
      if uwsm check may-start; then
        exec uwsm start hyprland-uwsm.desktop
      fi
    '';
  };
  imports = [
    ./appearance.nix
    ./binds.nix
    ./displays.nix
  ];
}
