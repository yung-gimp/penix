{
  pkgs,
  inputs,
  ...
}:
{
  xdg.enable = true;
  home = {
    packages = with pkgs; [
      htop
      tidal-hifi
      legcord
      vlc
      feh
      xfce.thunar
      neovide
      r2modman
      qpwgraph
      alsa-scarlett-gui
      obs-studio
      xfce.tumbler
      ffmpegthumbnailer
      bluetuith
      reaper
      wineWowPackages.waylandFull
      winetricks
      pokemmo-installer
      hexchat
      prismlauncher
    ];
    file.".local/share/icons/bibata-hyprcursor" = {
      recursive = true;
      source = builtins.fetchTarball {
        url = "https://github.com/LOSEARDES77/Bibata-Cursor-hyprcursor/releases/download/1.0/hypr_Bibata-Modern-Classic.tar.gz";
        sha256 = "08q5l2sywc0s70zdn7jvr0rbzz0w8j18wmlkf2x1l64y93lbvzsj";
      };
    };
  };

  imports = [
    inputs.nvf.homeManagerModules.default
    ./hyprland
    ./programs
  ];
}
