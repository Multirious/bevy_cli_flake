{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:
rustPlatform.buildRustPackage rec {
  pname = "bevy_lint";
  version = "lint-v0.4.0";
  src = fetchFromGitHub {
    owner = "TheBevyFlock";
    repo = "bevy_cli";
    rev = version;
    sha256 = "sha256-b+mmFDTDRxPXR3KLTTEF7TdK2kau8+3QfL3XE3TWrCw=";
  };
  cargoHash = "sha256-ZCd8ysFMzH6/7c/SUZ1CBrya9kvd8+s/VqF+dwYZ/7s=";
  cargoFlags = ["bevy_lint"];
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
  doCheck = false;
  meta = {
    description = "A Bevy linter.";
    homepage = "https://github.com/TheBevyFlock/bevy_cli";
    license = with lib.licenses; [ mit asl20 ];
    maintainers = [];
  };
}
