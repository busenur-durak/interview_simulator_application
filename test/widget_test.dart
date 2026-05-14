import 'package:flutter_test/flutter_test.dart';

import 'package:interview_simulator/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const InterviewSimulatorApp());
    await tester.pump();
  });
}
