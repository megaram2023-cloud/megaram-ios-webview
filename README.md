# MegaRam iOS WebView

Proyecto WebView iOS para incidencias.

- Codigo: `setup/ios-webview`
- Build cloud: `codemagic.yaml`

## Build IPA (sin Mac)

1. Conectar repo en Codemagic.
2. Ejecutar workflow `ios_webview_ipa`.
3. Configurar firma iOS con Apple Developer.
4. Descargar IPA desde Artifacts.

## Opcion sin Apple Developer de pago

Hay workflow de GitHub Actions en `.github/workflows/ios-ipa-unsigned.yml`.
Genera `MegaRamIncidencias-unsigned.ipa` como artifact.
Ese IPA se puede instalar desde Windows con Sideloadly o AltStore (firmando con tu Apple ID personal).
