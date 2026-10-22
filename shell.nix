let
  rev = "da6dc0e7b26060f2f71ce3ef7088fb56ee44fa36";
  sha256 = "0hlv2n0gcpcxmjka021806iswd7mlmpq1gpnvff2mr2fmmyx2nrj";

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
