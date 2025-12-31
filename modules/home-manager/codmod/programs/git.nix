{
  config,
  lib,
  ...
}:
let
  cfg = config.cm.programs.git;
in
{
  options.cm.programs.git.enable = lib.mkEnableOption "Enable git";

  config = lib.mkIf cfg.enable {
    programs = {
      git = {
        enable = true;
        settings = {
          user = {
            name = "yung-gimp";
            email = "172232649+yung-gimp@users.noreply.github.com";
          };
          core.editor = "nvim";
        };
      };

      gh = {
        enable = true;
        settings.protocol = "ssh";
      };
    };
  };
}
