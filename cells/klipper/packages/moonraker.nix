{
  lib,
  stdenvNoCC,
  python3,
  makeWrapper,
  unstableGitUpdater,
  nixosTests,
  sources,
  ...
}: let
  pythonEnv = python3.withPackages (packages:
    with packages; [
      tornado
      pyserial-asyncio
      pillow
      lmdb
      streaming-form-data
      distro
      inotify-simple
      libnacl
      paho-mqtt
      pycurl
      zeroconf
      preprocess-cancellation
      jinja2
      dbus-next
      apprise
      libgpiod
    ]);
in
  stdenvNoCC.mkDerivation rec {
    pname = "moonraker";

    inherit (sources.moonraker) version src;

    nativeBuildInputs = [makeWrapper];

    installPhase = ''
      mkdir -p $out $out/bin $out/lib
      cp -r moonraker $out/lib

      makeWrapper ${pythonEnv}/bin/python $out/bin/moonraker \
        --add-flags "$out/lib/moonraker/moonraker.py"
    '';

    passthru = {
      updateScript = unstableGitUpdater {url = meta.homepage;};
      tests.moonraker = nixosTests.moonraker;
    };

    meta = with lib; {
      description = "API web server for Klipper";
      homepage = "https://github.com/Arksine/moonraker";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [zhaofengli];
    };
  }
