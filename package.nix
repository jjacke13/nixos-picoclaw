{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "picoclaw";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "sipeed";
    repo = "picoclaw";
    rev = "v${version}";
    hash = "sha256-GUtEoni8zk17jh6eWVl2dNBlvmOW1vZpk/7eLjlavTU=";
  };

  vendorHash = "sha256-lAyXXUAgYY/6uyLm2cLkm4RKdMZ+yD4DKJ3Rmyyzp9s=";

  # Relax Go version requirement (upstream requires 1.25.7, nixpkgs has 1.25.6)
  # Copy workspace for go:embed directive (moved to onboard subpackage in v0.2.0)
  postPatch = ''
    substituteInPlace go.mod --replace-fail "go 1.25.7" "go 1.25.6"
    cp -r workspace cmd/picoclaw/internal/onboard/
  '';

  subPackages = [ "cmd/picoclaw" ];

  ldflags =
    let
      internal = "github.com/sipeed/picoclaw/cmd/picoclaw/internal/version";
    in
    [
      "-s"
      "-w"
      "-X ${internal}.version=${version}"
      "-X ${internal}.gitCommit=nixbuild"
      "-X ${internal}.buildTime=1970-01-01T00:00:00Z"
    ];

  meta = with lib; {
    description = "Ultra-lightweight AI assistant agent";
    homepage = "https://github.com/sipeed/picoclaw";
    license = licenses.mit;
    maintainers = [ ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
