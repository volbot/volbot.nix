{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "spek-cli";
  version = "1.0.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "SwagRGB";
    repo = "spek-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UBPBtu7t/2c+pOT3Nny4STLD3yl/RxFXtIayp8a/OJo=";
  };

  cargoHash = "sha256-ZU6GmdEpUZQtws6HP7DkPGm/bdnMCxmW1rzqKasAzKQ=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A terminal based spectogram to verify authencity of lossless audio files";
    homepage = "https://github.com/SwagRGB/spek-cli";
    changelog = "https://github.com/SwagRGB/spek-cli/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [ ];
    mainProgram = "spek-cli";
  };
})
