let
  rev = "da6dc0e7b26060f2f71ce3ef7088fb56ee44fa36";
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
      k3d
      kubeconform
      kubectl
      nixfmt-rfc-style
      nodejs_24
      unixtools.watch
    ];
  }
)
