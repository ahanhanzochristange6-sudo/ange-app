# ANGE — Lecteur Multimédia Ultime

**ANGE** est une application Android puissante, sombre et gaming, développée en **Flutter**, pour organiser, lire et gérer vos musiques et films locaux.

## Fonctionnalités

- **Lecteur audio** intégré (lecture, pause, seek, volume, playlist)
- **Lecteur vidéo** intégré avec avance rapide, volume, plein écran
- **Détection automatique** des musiques (via MediaStore) et vidéos (via PhotoManager)
- **Playlists personnalisées** avec image de couverture
- **Favoris** et **historique récent**
- **Barre de recherche** rapide
- **Interface sombre** premium avec accents rouge feu & or
- **Animations fluides** et design glassmorphism
- **Logo personnalisé** lion + flammes

## Structure du projet

```
lib/
  main.dart              -- Point d'entrée
  app.dart               -- MaterialApp & thème
  core/
    theme.dart           -- Couleurs & styles ANGE
  models/
    media_item.dart      -- Modèle Musique/Vidéo
    playlist_model.dart  -- Modèle Playlist
  data/
    database_helper.dart -- SQLite (playlists, favoris, récents)
  services/
    media_scanner.dart   -- Scan automatique des médias
  providers/
    media_provider.dart  -- État global & lecteur audio
  screens/               -- Tous les écrans (splash, home, lecteurs, playlists...)
  widgets/               -- Composants premium (glass card, neon button, logo lion)
assets/images/           -- Logo & icônes générés
android/app/src/main/    -- Manifest & icônes Android
```

## Compilation APK

### Prérequis
- Flutter SDK (>= 3.24)
- Android Studio / SDK Android

### Étapes

```bash
# 1. Créer le projet Flutter sur votre machine
flutter create --project-name ange --org com.ange.app ange_project
cd ange_project

# 2. Copier les fichiers du dossier ange/ dans ange_project/
#    - lib/          → lib/
#    - assets/       → assets/
#    - pubspec.yaml  → remplacer
#    - android/app/src/main/AndroidManifest.xml → remplacer
#    - android/app/src/main/res/mipmap-*/ic_launcher.png → remplacer

# 3. Résoudre les dépendances
flutter pub get

# 4. Compiler l'APK Release
flutter build apk --release
```

L'APK se trouve dans :
```
build/app/outputs/flutter-apk/app-release.apk
```

Pour une taille réduite :
```bash
flutter build apk --release --split-per-abi
```

### Permissions Android (déjà incluses)
- `READ_EXTERNAL_STORAGE`
- `READ_MEDIA_AUDIO` & `READ_MEDIA_VIDEO` (Android 13+)
- `INTERNET`, `WAKE_LOCK`, `FOREGROUND_SERVICE`

## Design

- **Fond** : Noir profond `#050505`
- **Accents** : Rouge feu `#B71C1C`, Orange `#FF6F00`, Or `#FFA000`
- **Style** : Glassmorphism, néons, dégradés, animations fade/slide
- **Logo** : Lion stylisé avec flammes, texte "ANGE" intégré

## Packages principaux

- `just_audio` — Lecteur audio puissant
- `video_player` — Lecteur vidéo natif
- `on_audio_query` — Scan musique MediaStore
- `photo_manager` — Scan vidéos
- `sqflite` — Base de données locale
- `provider` — Gestion d'état
- `image_picker` — Sélection couverture playlist
- `video_thumbnail` — Miniatures vidéos
- `animate_do`, `shimmer` — Animations premium

---

**Projet prêt à compiler.** Si vous avez besoin d'aide pour le build, consultez `BUILD_INSTRUCTIONS.md`.
