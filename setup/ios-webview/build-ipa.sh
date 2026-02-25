#!/usr/bin/env bash
set -euo pipefail

APP_SCHEME="MegaRamIncidencias"
PROJECT_NAME="MegaRamIncidenciasiOS"
CONFIGURATION="${CONFIGURATION:-Release}"
ARCHIVE_PATH="build/${APP_SCHEME}.xcarchive"
EXPORT_PATH="build/export"
EXPORT_OPTIONS_PLIST="${EXPORT_OPTIONS_PLIST:-ExportOptions.plist}"
START_URL="${1:-https://proctological-caleb-seminiferous.ngrok-free.dev/ticket.html}"

echo "[iOS] StartURL -> ${START_URL}"
/usr/libexec/PlistBuddy -c "Set :StartURL ${START_URL}" Resources/Info.plist

if ! command -v xcodegen >/dev/null 2>&1; then
  echo "[iOS] Falta xcodegen. Instala con: brew install xcodegen"
  exit 1
fi

echo "[iOS] Generando proyecto Xcode..."
xcodegen generate

if [ ! -f "${EXPORT_OPTIONS_PLIST}" ]; then
  cat > "${EXPORT_OPTIONS_PLIST}" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>method</key>
  <string>development</string>
  <key>signingStyle</key>
  <string>automatic</string>
  <key>stripSwiftSymbols</key>
  <true/>
  <key>compileBitcode</key>
  <false/>
</dict>
</plist>
PLIST
fi

echo "[iOS] Archive..."
xcodebuild \
  -project "${PROJECT_NAME}.xcodeproj" \
  -scheme "${APP_SCHEME}" \
  -configuration "${CONFIGURATION}" \
  -archivePath "${ARCHIVE_PATH}" \
  -destination "generic/platform=iOS" \
  clean archive

echo "[iOS] Export IPA..."
xcodebuild \
  -exportArchive \
  -archivePath "${ARCHIVE_PATH}" \
  -exportPath "${EXPORT_PATH}" \
  -exportOptionsPlist "${EXPORT_OPTIONS_PLIST}"

echo "[iOS] IPA generado en:"
ls -1 "${EXPORT_PATH}"/*.ipa
