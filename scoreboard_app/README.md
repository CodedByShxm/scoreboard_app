# Scoreboard App

A responsive Flutter scoreboard application for multi-sport live scoring. The app is designed for quick score entry, sport-specific rule tracking, and landscape-first gameplay displays for a real scoreboard look.

## Features

- Multi-sport scoreboard flow with configurable scoring rules
- Landscape-first layout for live game display
- Team-specific score controls with quick tap increments
- Timer/countdown support for time-based sports
- Sport-aware rule counters such as fouls, corners, blocks, penalties, and timeouts
- Responsive team panels that adapt for different device sizes and aspect ratios
- Tennis-specific scoring screen with game and set logic

## Supported Sports

- Basketball
- Soccer
- Volleyball
- Football
- Hockey
- Tennis
- Generic/custom scoreboard

## Getting Started

```bash
flutter pub get
flutter run
```

## Architecture

- `lib/models/sport.dart` — sport metadata, timer defaults, and per-team rule definitions
- `lib/screens/home_screen.dart` — sport selection screen
- `lib/screens/scoreboard_screen.dart` — generic live scoreboard for time-based sports
- `lib/screens/tennis_scoreboard.dart` — tennis-specific scoring logic
- `lib/widgets/team_score_panel.dart` — responsive team panel with score + rule controls

## Run tests

```bash
flutter test
```

## Notes

This project is intentionally built around modular sport configuration so new sports can be added by extending the data model rather than rewriting screen logic. The app is structured for future expansion into persistence, telemetry, or tournament flows.
