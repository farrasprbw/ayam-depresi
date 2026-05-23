import 'package:flutter_test/flutter_test.dart';

import 'package:ayam_depresi/main.dart';

void main() {
  testWidgets('Login screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const AyamDepresiApp());

    expect(find.text('AYAM DEPRESI'), findsOneWidget);
    expect(find.text('MASUK KE\nNERAKA'), findsOneWidget);
    expect(find.text('LOGIN & PESAN'), findsOneWidget);
  });
}
