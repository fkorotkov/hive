{
  lib,
  stdenvNoCC,
  sources,
}:
stdenvNoCC.mkDerivation rec {
  pname = "klipper-ercf-software";

  inherit (sources.klipper-ercf-software) version src;

  installPhase = ''
    mkdir -p $out/lib/${pname}/cfg
    cp -r ./extras $out/lib/${pname}/
    cp ./*.cfg $out/lib/${pname}/cfg/
  '';

  meta = with lib; {
    description = "ERCF MMU Software plugin for klipper";
    homepage = "https://github.com/moggieuk/ERCF-Software-V3";
    license = licenses.gpl3Only;
  };
}
