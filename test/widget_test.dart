import 'package:flutter_test/flutter_test.dart';
import 'package:society/main.dart';
import 'package:society/injection_container.dart' as di;

void main() {
  testWidgets('Society App initial render smoke test', (WidgetTester tester) async {
    await di.initDependencies();
    await tester.pumpWidget(const SocietyApp());
    expect(find.byType(SocietyApp), findsOneWidget);
  });
}
