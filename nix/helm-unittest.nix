{
  buildGoModule,
  fetchFromGitHub,
  lib,
  yq-go,
}:

buildGoModule rec {
  pname = "helm-unittest";
  version = "HEAD";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "6f82a998e0b5461762ca959f87f5dd344af5e4eb";
    hash = "sha256-wArRsC52ga485rpm8ns99NY/qUZ/FImK4C/L1q460HI=";
  };

  vendorHash = "sha256-dkAzmFvLbhbIYCKsk1+TfckdNkNh6OkpDabJDDSwXJM=";

  nativeBuildInputs = [ yq-go ];

  # NOTE: Remove the install and upgrade hooks.
  postPatch = ''
    sed -i '/^hooks:/,+2 d' plugin.yaml
  '';

  postInstall = ''
    install -dm755 $out/${pname}
    mv $out/bin/helm-unittest $out/${pname}/untt
    rmdir $out/bin
    install -m644 -Dt $out/${pname} plugin.yaml
  '';
}
