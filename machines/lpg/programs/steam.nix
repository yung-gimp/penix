{pkgs, ...}: {
  programs = {
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    gamemode = {
      enable = true;
      enableRenice = false; # handled by ananicy
    };
    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [proton-ge-bin];
      protontricks.enable = true;
      # gamescopeSession = {
      #   enable = true;
      #   args = [
      #     "-b"
      #     "-W 2560"
      #     "-H 1440"
      #     "-r 165"
      #     "--hdr-enabled"
      #   ];
      # };
      extraPackages = with pkgs; [
        gamemode
      ];
    };
  };
}
