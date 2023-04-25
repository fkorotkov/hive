{
  lib,
  buildNpmPackage,
  sources,
  cypress,
  zip,
}:
buildNpmPackage {
  pname = "mainsail";

  inherit (sources.mainsail-raw) version src;

  npmDepsHash = "sha256-244N6lCTLvaHttJmcnWOqQrN6OXjzOM1Xkt+nmpBHyw=";

  # convert to native
  nativeBuildInputs = [
    cypress
    zip
  ];

  prePatch = ''
    export CYPRESS_INSTALL_BINARY=0
    export CYPRESS_RUN_BINARY=${cypress}/bin/Cypress
  '';

  installPhase = ''
    mkdir -p $out/share/mainsail
    rm dist/mainsail.zip
    cp -r dist $out/share/mainsail/htdocs
  '';

  meta = with lib; {
    description = "Klipper web interface";
    homepage = "https://docs.mainsail.xyz";
    license = licenses.gpl3Only;
  };
}
