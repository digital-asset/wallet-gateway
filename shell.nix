let
  rev = "a7f6fb78c74c145ed8210f0ac9d6a3fb595ba92f";
  sha256 = "09xpkn3m6ckvcm5v1nvnrs37ayay3wiivnnpcrnfms90mq9m84na";

  nixPkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
    inherit sha256;
  }) { };

  helm-unittest = import ./nix/helm-unittest.nix;
in
nixPkgs.mkShell (
  with nixPkgs;
  {
    packages = [
      (wrapHelm kubernetes-helm {
        plugins = [
          (callPackage helm-unittest { })
          kubernetes-helmPlugins.helm-schema
        ];
      })
      gnumake
      kubeconform
      nixfmt-rfc-style
      nodejs_22
      unixtools.watch
    ];
  }
)
