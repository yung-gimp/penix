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
      prismlauncher
      nitrokey-app2
    ];
  };

  imports = [
    inputs.nvf.homeManagerModules.default
    ./hyprland
    ./programs
  ];
}
