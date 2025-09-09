{
  srcInput,

  rustPlatform,
  makeWrapper,
  rust-bin,
  lib,
}:
rustPlatform.buildRustPackage {
  name = "bevy_lint";
  src = srcInput;
  cargoLock.lockFile = "${srcInput}/Cargo.lock";
  cargoFlags = ["bevy_lint"];
  nativeBuildInputs = [
    makeWrapper
  ];
  preBuild = ''
    # Hook to exit the sub-crate before cargoInstallPostBuildHook
    postBuildExitDirHook () {
      echo "Executing postBuildExitDirHook"
      cd ..
      echo "Finished postBuildExitDirHook"
    }

    # Enter the `bevy_lint` sub-crate
    cd bevy_lint
  '';
  postBuildHooks = [
    # Exit the `bevy_lint` sub-crate
    "postBuildExitDirHook"
    # Continue as normal
    "cargoInstallPostBuildHook"
  ];
  postFixup = ''
    wrapProgram \
      "$out/bin/bevy_lint" \
      --set BEVY_LINT_SYSROOT "${rust-bin}"
  '';
  doCheck = false;
  meta = {
    description = "A Bevy linter.";
    homepage = "https://github.com/TheBevyFlock/bevy_cli";
    license = with lib.licenses; [ mit asl20 ];
    maintainers = [];
  };
}
