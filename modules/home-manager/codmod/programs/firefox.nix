{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.cm.programs.firefox;
in {
  options.cm.programs.firefox.enable = lib.mkEnableOption "Enable Firefox";

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      profiles.default = {
        settings = {
          "extensions.autoDisableScopes" = 0;
        };

        extensions = {
          force = true;
          packages = with inputs.firefox-addons.packages.${pkgs.system}; [
            bitwarden
            darkreader
            ublock-origin
          ];
        };
      };
    };
  };
}
