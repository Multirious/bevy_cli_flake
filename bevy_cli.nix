{
  srcInput,

  lib,
  rustPlatform,

  pkg-config,
  openssl,

  # Required during the checkPhase
  llvmPackages,
}:
rustPlatform.buildRustPackage rec {
  name = "bevy_cli";
  src = srcInput;
  cargoLock.lockFile = "${srcInput}/Cargo.lock";
  nativeBuildInputs = [
    pkg-config
    openssl
  ] ++ lib.optional doCheck llvmPackages.bintools;
  # Disabled since check takes really long.
  doCheck = false;
  PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";
  meta = {
    description = "A Bevy CLI tool and linter.";
    homepage = "https://github.com/TheBevyFlock/bevy_cli";
    license = with lib.licenses; [ mit asl20 ];
    maintainers = [];
  };
}
