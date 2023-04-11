final: prev: {
  klipper = prev.klipper.overrideAttrs (o: {
    inherit (prev.sources.klipper) pname version src;

    buildInputs = [(final.python3.withPackages (p: with p; [cffi pyserial greenlet jinja2 markupsafe numpy can setuptools]))];

    postInstall = ''
      ln -sf "${final.klipper-led_effect}/lib/klipper-led_effect/led_effect.py" "$out/lib/klipper/extras/led_effect.py"
      ln -sf ${final.klipper-ercf-software}/lib/klipper-ercf-software/extras/*.py "$out/lib/klipper/extras/"
    '';
  });
}
