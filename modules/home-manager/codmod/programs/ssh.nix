{ config, lib, ... }:
let
  cfg = config.cm.programs.ssh;
in
{
  options.cm.programs.ssh.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "enable ssh config";
  };

  config = lib.mkIf cfg.enable {
    programs.ssh.matchBlocks = {
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
        identityFile = "~/.ssh/id_ed25519_sk";
      };
      "github.com".identityFile = "~/.ssh/id_ed25519_github";
    };
  };
}
