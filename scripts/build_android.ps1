$env:JAVA_HOME = "C:\Program Files\Microsoft\jdk-17.0.12.7-hotspot"
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"

Write-Host "--- Configurando Ambiente Java ---"
try {
    java -version
} catch {
    Write-Error "Java não encontrado mesmo após configuração."
    exit 1
}

Write-Host "`n--- Sincronizando Web Assets (Capacitor) ---"
npx cap sync android
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "`n--- Iniciando Build Android (Gradle) ---"
Set-Location android
.\gradlew assembleDebug
