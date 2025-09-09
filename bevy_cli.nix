{
  lib,
  rustPlatform,
  fetchFromGitHub,

  pkg-config,
  openssl,

  # Required during the checkPhase
  llvmPackages,
}:
rustPlatform.buildRustPackage rec {
  pname = "bevy_cli";
  version = "cli-v0.1.0-alpha.1";
  src = fetchFromGitHub {
    owner = "TheBevyFlock";
    repo = "bevy_cli";
    rev = version;
    sha256 = "sha256-v7BcmrG3/Ep+W5GkyKRD1kJ1nUxpxYlGGW3SNKh0U+8=";
  };
  cargoHash = "sha256-QrW0daIjuFQ6Khl+3sTKM0FPGz6lMiRXw0RKXGZIHC0=";
  nativeBuildInputs = [
    pkg-config
    openssl
  ] ++ lib.optional doCheck llvmPackages.bintools;
  # Disabled since check takes really long.
  doCheck = false;
  # postFixup = ''
  #   wrapProgram "$out"/bin/bevy" \
  #     --set 
  # '';
  PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";
  meta = {
    description = "A Bevy CLI tool and linter.";
    homepage = "https://github.com/TheBevyFlock/bevy_cli";
    license = with lib.licenses; [ mit asl20 ];
    maintainers = [];
  };
}
