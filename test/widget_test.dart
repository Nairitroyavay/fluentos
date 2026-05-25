import 'package:fluentos_app/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('shows splash and transitions to fake auth', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: FluentOSApp()));

    expect(find.text('FluentOS'), findsOneWidget);
    expect(find.text('Speak one language fluently at a time.'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();

    expect(find.text('Start with your voice.'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });
}
