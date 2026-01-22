Atualizar APK Android
npm run build

npx cap sync

npx cap open android

Elefante (Sync) 🐘

Build > Build Bundle(s) / APK(s) > Build APK(s)

Antes de gerar o APK (Passo 3), no Android Studio:
Abra o arquivo build.gradle (Module :app).
Procure por:
versionCode 1 (Mude para 2, 3, 4...)
versionName "1.0" (Mude para "1.1", "1.2"...)
Sincronize (Elefante) e gere o APK.