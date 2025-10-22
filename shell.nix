let
  rev = "a7f6fb78c74c145ed8210f0ac9d6a3fb595ba92f";
  sha256 = "09xpkn3m6ckvcm5v1nvnrs37ayay3wiivnnpcrnfms90mq9m84na";

  nixPkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
    inherit sha256;
  }) { };

in
nixPkgs.mkShell (
  with nixPkgs;
  {
    packages = [
      (wrapHelm kubernetes-helm {
        plugins = [
          kubernetes-helmPlugins.helm-schema
          kubernetes-helmPlugins.helm-unittest
        ];
      })
    ];
  }
)
