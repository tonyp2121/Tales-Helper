import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tales_helper/main.dart';
import 'package:tales_helper/models/game_state.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => GameState(),
        child: const TalesHelperApp(),
      ),
    );
    expect(find.text('Tales of the Arabian Nights'), findsOneWidget);
  });
}
