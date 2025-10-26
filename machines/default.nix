{
  inputs,
  lib,
  self,
  ...
}: let
  hostsNames = lib.attrNames (lib.filterAttrs (n: v: v == "directory" && (builtins.readDir ./${n}) ? "default.nix") (builtins.readDir ./.));

  mkHost = hostname:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          hostname
          lib
          self
          ;
      };
      modules = [
        ./${hostname}
        self.nixosModules.codmod
        inputs.agenix.nixosModules.default
        inputs.agenix-rekey.nixosModules.default
        inputs.home-manager.nixosModules.home-manager
        inputs.ff.nixosModules.freedpomFlake
        inputs.preservation.nixosModules.preservation
      ];
    };
in {
  flake.nixosConfigurations = lib.genAttrs hostsNames mkHost;
}
