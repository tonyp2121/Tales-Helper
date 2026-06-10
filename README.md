# Tales of the Arabian Nights Helper

A cross-platform companion app for the storytelling board game
**Tales of the Arabian Nights** (Eric Goldberg, Z-Man Games). It replaces
pencil-and-paper bookkeeping with a touch-friendly digital tracker and an
encounter-matrix lookup, so the table can focus on the story instead of
flipping through charts.

> This is a Flutter rewrite of the original GameMaker Studio version. The
> legacy GameMaker source remains available on the
> [`legacy-gamemaker`](https://github.com/tonyp2121/Tales-Helper/tree/legacy-gamemaker)
> branch.

## Features

- **2–6 player setup** using the six canonical character colors
  (Ma'aruf, Ali Baba, Scheherazade, Zumurrud, Aladdin, Sinbad).
- **Per-player tracking** of:
  - Destiny Points and Story Points (0–20)
  - Wealth level (Beggar → Penniless → Poor → Respectable → Rich → Princely → Fabulous)
  - All 28 statuses (Accursed, Beast Form, Crippled, Lost, …)
  - All 18 quest/skill tokens
- **Automatic trade-value calculation** — land and sea trade values are derived
  from wealth, modified by relevant statuses (Crippled, Diseased, Lost) and
  tokens (Seafaring), so you never have to remember the modifiers.
- **Encounter Matrix lookup** — enter encounter number, die roll, and city
  number; the destiny bonus is applied automatically (+1 at 3 DP, +2 at 5 DP)
  and the resulting matrix letter and encounter name are displayed.
- **Dark, gold-accented Material 3 theme** designed to be readable in low
  table light.

## Tech stack

- [Flutter](https://flutter.dev) (Dart SDK `^3.11.4`), Material 3
- [`provider`](https://pub.dev/packages/provider) for state management
  (`GameState` is a single `ChangeNotifier` shared via `ChangeNotifierProvider`)
- Targets: Android, iOS, Web, Windows, macOS, Linux

## Project layout

```
lib/
├── main.dart              App entry, theme, MaterialApp
├── models/
│   ├── game_state.dart    ChangeNotifier holding all players & turn state
│   └── player.dart        Player model + derived trade values
├── screens/
│   ├── setup_screen.dart      Choose player count
│   ├── color_picker_screen.dart  Assign colors/characters
│   ├── game_screen.dart       Main per-player tracker
│   └── encounter_screen.dart  Encounter matrix lookup
├── widgets/
│   ├── player_stats.dart
│   ├── status_picker.dart
│   └── token_picker.dart
└── data/
    ├── game_constants.dart    Wealth levels, status/token names, colors
    └── encounter_data.dart    Encounter matrix (letters + names)
```

## Getting started

Prerequisites: [Flutter](https://docs.flutter.dev/get-started/install) (stable
channel, Dart SDK `^3.11.4`).

```bash
flutter pub get
flutter run                 # pick a connected device / emulator
```

Build a release artifact for a specific platform:

```bash
flutter build apk           # Android
flutter build ios           # iOS (macOS host required)
flutter build windows
flutter build web
```

Run static analysis and tests:

```bash
flutter analyze
flutter test
```

## About the game

[Tales of the Arabian Nights](https://boardgamegeek.com/boardgame/34119/tales-arabian-nights)
is a story-driven board game in which players travel the world of the
*1001 Nights*, drawing encounters from a deck and resolving them through a
matrix of paragraph references in the Book of Tales. This app is an unofficial
fan utility — it owns no game content beyond table indices needed to look up
encounters and the names of statuses, tokens, and wealth levels.
