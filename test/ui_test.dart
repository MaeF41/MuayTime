import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muay_time/screen/main_screen.dart';

import 'harness.dart';

void main() {
  testWidgets('main screen looks good', (WidgetTester tester) async {
    loadFonts();
    await tester.pumpWidget(const MyApp());

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/main_screen.png'),
    );
  });
}
