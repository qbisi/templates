{
  stdenvNoCC,
  lib,
  fetchurl,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "v2ray-rules-dat";
  version = "202604252231";

  src1 = fetchurl {
    url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/${finalAttrs.version}/geoip.dat";
    hash = "sha256-tBIMiH8sgS5fV1Ucg0F+xvZo7haZnLLGICIdDAY8zfQ=";
  };

  src2 = fetchurl {
    url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/${finalAttrs.version}/geosite.dat";
    hash = "sha256-J/ndrQMKHN3aRQW63/Jbaic1bqDLRFHr8NecFy6Wok0=";
  };

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 $src1 $out/share/v2ray/geoip.dat
    install -Dm644 $src2 $out/share/v2ray/geosite.dat

    runHook postInstall
  '';

  dontFixup = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Enhanced edition of V2Ray rules dat files";
    homepage = "https://github.com/Loyalsoldier/v2ray-rules-dat";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ qbisi ];
  };
})
