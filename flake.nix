{
  description = "picoclaw - ultra-lightweight AI assistant agent";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs }:
  {
    packages = {
      x86_64-linux = {
        picoclaw = nixpkgs.legacyPackages.x86_64-linux.callPackage ./package.nix { };
        default = self.packages.x86_64-linux.picoclaw;
      };
      
      aarch64-linux = {
        picoclaw = nixpkgs.legacyPackages.x86_64-linux.callPackage ./package.nix { };
        default = self.packages.aarch64-linux.picoclaw;
      };
    };
  };
}
