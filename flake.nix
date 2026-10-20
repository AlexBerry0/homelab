{
  description = "Homelab Cluster Infrastructure";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: {
    nixosConfigurations = {
      sandbox = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./nix/hosts/sandbox/default.nix
        ];
      };
      sandbox-worker = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./nix/hosts/sandbox-worker/default.nix
        ];
      };
    };
  };
}
