import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scoreboard_app/models/sport.dart';
import 'package:scoreboard_app/screens/scoreboard_screen.dart';
import 'package:scoreboard_app/screens/tennis_scoreboard.dart';

void main() {
  testWidgets('shows a countdown timer for scoreboards that use game time',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ScoreboardScreen(sport: kSports.first),
      ),
    );

    expect(find.text('12:00'), findsOneWidget);
  });

  testWidgets('does not show a timer on tennis', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TennisScoreboard(),
      ),
    );

    expect(find.text('12:00'), findsNothing);
  });

  testWidgets('shows sport-specific rule counters like fouls', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ScoreboardScreen(sport: kSports.first),
      ),
    );

    expect(find.text('FOULS'), findsWidgets);
  });
}
