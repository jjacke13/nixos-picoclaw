{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "picoclaw";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "sipeed";
    repo = "picoclaw";
    rev = "v${version}";
    hash = "sha256-CSAUlCe/g22rzbOx3xNTMFRIOwp/+ezCMRCjNRcQeZ0=";
  };

  vendorHash = "sha256-ocLRiFZs2OnKM7C2/cUafpC8LIRCLybXG0ln8n9ZXr4=";

  # Relax Go version requirement (upstream requires 1.25.8, nixpkgs has 1.25.7)
  # Copy workspace for go:embed directive (moved to onboard subpackage in v0.2.0)
  postPatch = ''
    sed -i 's/go 1.25.8/go 1.25.7/' go.mod
    cp -r workspace cmd/picoclaw/internal/onboard/
    # Remove Matrix channel (requires libolm which is insecure in nixpkgs)
    rm pkg/gateway/channel_matrix.go
  '';

  overrideModAttrs = _: {
    env.GOFLAGS = "-mod=mod";
  };

  # Static build without CGo (disables Matrix/libolm which is insecure in nixpkgs)
  env.CGO_ENABLED = 0;

  subPackages = [ "cmd/picoclaw" ];
  doCheck = false;

  meta = with lib; {
    description = "Ultra-lightweight AI assistant agent";
    homepage = "https://github.com/sipeed/picoclaw";
    license = licenses.mit;
    maintainers = [ ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
