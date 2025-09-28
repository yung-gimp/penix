{
  inputs,
  lib,
  self,
  ...
}: let
  hosts = builtins.attrNames (
    lib.attrsets.filterAttrs (_n: t: t == "directory") (builtins.readDir ./nixosConfigurations)
  );

  mkHost = hostname: let
    secretsPath = "${inputs.secrets}/${hostname}";
  in
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          hostname
          lib
          self
          secretsPath
          ;
      };
      modules = [
        {
          age.rekey = {
            masterIdentities = ["${inputs.secrets}/mykey.pub"];
            hostPubkey = builtins.readFile "${secretsPath}/host_key.pub";
            localStorageDir = secretsPath;
            storageMode = "local";
          };
        }
        inputs.agenix.nixosModules.default
        inputs.agenix-rekey.nixosModules.default
        ./nixosConfigurations/${hostname}
        inputs.home-manager.nixosModules.home-manager
        inputs.ff.nixosModules.freedpomFlake
        inputs.preservation.nixosModules.preservation
      ];
    };

  homeMods = builtins.attrNames (
    lib.attrsets.filterAttrs (_n: t: t == "directory") (builtins.readDir ./homeModules)
  );

  mkHomeMod = homeMod: {
    imports = [
      ./homeModules/${homeMod}
    ];
  };
in {
  flake = {
    nixosConfigurations = lib.genAttrs hosts mkHost;
    homeModules = lib.genAttrs homeMods mkHomeMod;
  };
}
