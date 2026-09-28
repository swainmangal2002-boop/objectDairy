import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ObjectDiary app loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Text('ObjectDiary'),
          ),
        ),
      ),
    );

    expect(find.text('ObjectDiary'), findsOneWidget);
  });
}