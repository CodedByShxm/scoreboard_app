import 'package:flutter_test/flutter_test.dart';
import 'package:scoreboard_app/main.dart';

void main() {
  testWidgets('app loads the sports picker screen', (tester) async {
    await tester.pumpWidget(const ScoreboardApp());

    expect(find.text('Scoreboard'), findsWidgets);
    expect(find.text('Pick a sport'), findsOneWidget);
  });
}
