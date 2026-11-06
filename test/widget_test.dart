import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Initial smoke test', (WidgetTester tester) async {
    expect(find.byType(Container), findsNothing);
  });
}
