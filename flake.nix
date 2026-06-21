{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flakelight.url = "github:nix-community/flakelight";

    preservation.url = "github:nix-community/preservation";
  };

  outputs = { flakelight, ... }@inputs: {
    flakelight ./. {
      systems = [ "x86_64-linux" "aarch64-linux" ];
      inherit inputs;
  };
}

