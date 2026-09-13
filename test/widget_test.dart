import 'package:downz/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the download form', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Bring the file\nto you.'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Start download'), findsOneWidget);

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
  });
}
