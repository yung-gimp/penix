{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.cm.system.secrets;
in
{
  options.cm.system.secrets.enable = lib.mkEnableOption "Enable secret handling";

  config = lib.mkMerge [
    {
      age.rekey = {
        agePlugins = [ pkgs.age-plugin-fido2-hmac ];
        masterIdentities = [ "${inputs.secrets}/mykey.pub" ];
      };
    }

    (lib.mkIf cfg.enable {
      age.rekey = {
        hostPubkey = builtins.readFile "${inputs.secrets}/${config.networking.hostName}/host_key.pub";
        storageMode = "derivation";
        cacheDir = "/var/tmp/agenix-rekey/\"$UID\"";
      };
      nix.settings.extra-sandbox-paths = [ "/var/tmp/agenix-rekey" ];
      preservation.preserveAt."/nix/persist".directories = [
        {
          directory = "/var/tmp/agenix-rekey";
          mode = "1777";
        }
      ];
    })
  ];
}
