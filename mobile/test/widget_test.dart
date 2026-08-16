import 'package:flutter_test/flutter_test.dart';
import 'package:playarena/main.dart';

void main() {
  testWidgets('PlayArena development preview loads', (tester) async {
    await tester.pumpWidget(const PlayArenaApp());
    expect(find.text('PlayArena'), findsOneWidget);
    expect(find.text('Cricket + Teen Patti'), findsOneWidget);
    expect(find.text('OPEN PLAYARENA'), findsOneWidget);
  });
}
