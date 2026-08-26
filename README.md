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

## Architecture

- `lib/models/sport.dart` — sport metadata, timer defaults, and per-team rule definitions
- `lib/screens/home_screen.dart` — sport selection screen
- `lib/screens/scoreboard_screen.dart` — generic live scoreboard for time-based sports
- `lib/screens/tennis_scoreboard.dart` — tennis-specific scoring logic
- `lib/widgets/team_score_panel.dart` — responsive team panel with score + rule controls

## Getting Started

### Prerequisites

- Flutter SDK 3.x or newer
- Android Studio, VS Code, or another Flutter-compatible editor

### Install dependencies

```bash
flutter pub get
```

### Run locally

```bash
flutter run
```

### Run tests

```bash
flutter test
```

## Development Notes

This project intentionally separates sport configuration from screen logic so adding a new sport is usually just a matter of defining a new `SportConfig` entry rather than creating an entirely new screen.

For sports with distinct rulesets, such as tennis, the app uses a dedicated screen and scoring model while keeping the overall app experience consistent.

## Project Status

This project is intended as a clean, production-friendly Flutter starter for scoreboard-style applications and can be extended for real-time match tracking, persistent game state, or broader sports coverage.
