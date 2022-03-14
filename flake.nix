{
  description = "circt-y things";


  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    wake-src = {
      type = "github";
      owner = "sifive";
      repo = "wake";
      ref = "v0.24.0";
      flake = false;
    };
    #circt-git-src = {
    #  type = "git";
    #  url = "https://github.com/llvm/circt";
    #  ref = "main";
    #  flake = false;
    #  submodules = true;
    #};
    circt-src = {
      type = "github";
      owner = "llvm";
      repo = "circt";
      #submodules = true;
      ref = "main";
      flake = false;
    };
    llvm-submodule-src = {
      type = "github";
      owner = "llvm";
      repo = "llvm-project";
      #submodules = true;
      #rev = "main";
      # From circt submodule
      rev = "2dc90eee46309a2dd4b9fdf0d6ecb8a519a8b0fc";
      flake = false;
    };
    nixpkgs = {
      type = "github";
      #owner = "NixOS";
      owner = "dtzWill";
      repo = "nixpkgs";
      ref = "feature/flang";
      #ref = "mast
    };
  };

  outputs = { self, nixpkgs, flake-utils, circt-src, llvm-submodule-src, wake-src }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in
        rec {
          #devShell = import ./shell.nix { inherit pkgs; };
          packages = flake-utils.lib.flattenTree ({
            hello = pkgs.hello;
            wake = pkgs.callPackage ./wake.nix { inherit wake-src; };
            # gitAndTools = pkgs.gitAndTools;
          } //
           (import ./default.nix { inherit pkgs circt-src llvm-submodule-src; })
           );
          # defaultPackage = packages.foo;
          defaultPackage = packages.circt;

          #defaultPackage = import ./build.nix { inherit self pkgs; };
        }
      );
}
