{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "picoclaw";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "sipeed";
    repo = "picoclaw";
    rev = "v${version}";
    hash = "sha256-CnwfnYl7hciCbgC0P/I9anGdmrzpRalutGmPAJ6H7NI=";
  };

  vendorHash = "sha256-3MjBLklUpMTcz5/tW7Lr6d4wJ1x7ylFiEZkyeJI0CUA=";

  # Copy workspace for go:embed directive (moved to onboard subpackage in v0.2.0)
  postPatch = ''
    cp -r workspace cmd/picoclaw/internal/onboard/
  '';

  # Allow go to update go.mod after version patch
  overrideModAttrs = _: {
    env.GOFLAGS = "-mod=mod";
  };

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
