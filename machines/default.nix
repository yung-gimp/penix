{
  inputs,
  lib,
  self,
  ...
}:
let
  hostsNames = lib.attrNames (
    lib.filterAttrs (n: v: v == "directory" && (builtins.readDir ./${n}) ? "default.nix") (
      builtins.readDir ./.
    )
  );

  mkHost =
    hostname:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          hostname
          self
          ;
      };
      modules = [
        ./${hostname}
        self.nixosModules.codmod
        inputs.home-manager.nixosModules.home-manager
        inputs.ff.nixosModules.freedpomFlake
        inputs.ff.nixosModules.preservation
        inputs.ff.nixosModules.home-manager
        inputs.preservation.nixosModules.preservation
        inputs.disko.nixosModules.disko
      ];
    };
in
{
  flake.nixosConfigurations = lib.genAttrs hostsNames mkHost;
}
