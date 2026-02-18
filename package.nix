{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "picoclaw";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "sipeed";
    repo = "picoclaw";
    rev = "v${version}";
    hash = "sha256-2q/BQmZaSh88kwquiQlWGS36MVFWWdUzsMxGp4cAMiE=";
  };

  vendorHash = "sha256-3kDU3pbcz+2cd36/bcbdU/IXTAeJosBZ+syUQqO2bls=";

  # Relax Go version requirement (upstream requires 1.25.7, nixpkgs has 1.25.6)
  # Copy workspace for go:embed directive
  postPatch = ''
    substituteInPlace go.mod --replace-fail "go 1.25.7" "go 1.25.6"
    cp -r workspace cmd/picoclaw/
  '';

  subPackages = [ "cmd/picoclaw" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    description = "Ultra-lightweight AI assistant agent";
    homepage = "https://github.com/sipeed/picoclaw";
    license = licenses.mit;
    maintainers = [ ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
