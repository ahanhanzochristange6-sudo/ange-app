# ANGE - Instructions de compilation APK

## Prérequis

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (canal stable, version >= 3.24)
- Android Studio ou SDK Android avec Gradle
- Un appareil Android ou un émulateur (API 21+)

## Étapes

### 1. Créer le squelette Flutter (sur votre machine)

```bash
flutter create --project-name ange --org com.ange.app ange_project
cd ange_project
```

### 2. Copier les sources

Copiez le contenu de ce dossier `ange/` dans votre dossier `ange_project/` :
- `lib/` → `lib/`
- `assets/` → `assets/`
- `pubspec.yaml` → remplacez le fichier existant
- `android/app/src/main/AndroidManifest.xml` → remplacez le fichier existant
- `android/app/src/main/res/mipmap-*/ic_launcher.png` → remplacez les icônes existantes

### 3. Résolution des dépendances

```bash
flutter pub get
```

### 4. Vérifier les permissions Android (déjà incluses)

Le manifest contient :
- `READ_EXTERNAL_STORAGE`
- `READ_MEDIA_AUDIO` (Android 13+)
- `READ_MEDIA_VIDEO` (Android 13+)
- `WAKE_LOCK`, `FOREGROUND_SERVICE`

### 5. Compilation de l'APK release

```bash
flutter build apk --release
```

L'APK se trouvera dans :
```
build/app/outputs/flutter-apk/app-release.apk
```

### 6. Installation directe (optionnel)

```bash
flutter install
```

### Conseils

- Pour une taille réduite : `flutter build apk --release --split-per-abi`
- Si vous rencontrez des erreurs de `minSdkVersion`, vérifiez que `android/app/build.gradle` contient :
  ```gradle
  android {
      defaultConfig {
          minSdkVersion 21
      }
  }
  ```
- Assurez-vous d'accorder les permissions de stockage à l'application lors du premier lancement.
