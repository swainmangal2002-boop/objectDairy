import 'package:flutter_test/flutter_test.dart';

import 'package:mad_proj/main.dart';

void main() {
  testWidgets('ObjectDiary app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const ObjectDiaryApp());

    expect(find.text('ObjectDiary'), findsOneWidget);
  });
}