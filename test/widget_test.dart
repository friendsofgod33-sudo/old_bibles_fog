// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:old_bibles/main.dart';

void main() {
  testWidgets('Reader screen shows core controls', (WidgetTester tester) async {
    await tester.pumpWidget(const OldBiblesApp());

    expect(find.text('Old Bibles Reader'), findsOneWidget);
    expect(find.text('Read Chapter'), findsOneWidget);
    expect(find.text('Translation'), findsOneWidget);
  });
}
