# iOS WebView (IPA)

Proyecto iOS tipo WebView para abrir el formulario de incidencias.

Start URL actual:

- `https://proctological-caleb-seminiferous.ngrok-free.dev/ticket.html`

## Estado del proyecto

- Codigo Swift listo en `setup/ios-webview/Sources`
- `Info.plist` con `StartURL`
- Iconos iOS en `setup/ios-webview/Resources/Assets.xcassets/AppIcon.appiconset`
- Script local para Mac: `setup/ios-webview/build-ipa.sh`
- Build en nube listo con Codemagic: `codemagic.yaml`

## Generar IPA sin Mac (Codemagic)

1. Sube este proyecto a GitHub.
2. Entra en Codemagic y conecta el repositorio.
3. Selecciona el workflow `ios_webview_ipa` del archivo `codemagic.yaml`.
4. Conecta tu cuenta de Apple Developer en Codemagic.
5. Lanza el build y descarga el `.ipa` desde Artifacts.

## Variables que puedes cambiar

- `START_URL` en `codemagic.yaml` para apuntar a tu ngrok actual.
- `BUNDLE_ID` en `codemagic.yaml` y `setup/ios-webview/project.yml` si cambias identificador.

## Requisito clave

Para instalar en iPhone, el IPA debe ir firmado con certificados/perfiles de Apple. En la practica necesitas cuenta Apple Developer activa.
