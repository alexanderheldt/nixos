{
  stdenv,
  fetchurl,
  writeShellScriptBin,
  nix-alien,
  ...
}:
let
  version = "0.11.0";

  unpatched = stdenv.mkDerivation {
    name = "scie-pants";
    version = version;
    sourceRoot = ".";
    phases = [
      "installPhase"
      "patchPhase"
    ];

    src = fetchurl {
      url = "https://github.com/pantsbuild/scie-pants/releases/download/v${version}/scie-pants-linux-x86_64";
      sha256 = "sha256-ifP5gjTdLMXyVSKda6pPBNNcnJZ0giuqikFBk7cXgHI=";
    };

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp $src $out/bin/pants
      chmod +x $out/bin/pants

      runHook postInstall
    '';
  };
in
writeShellScriptBin "pants" ''
  export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
  ${nix-alien}/bin/nix-alien ${unpatched}/bin/pants -- "$@"
''
