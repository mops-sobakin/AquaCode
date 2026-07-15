import 'package:flutter_test/flutter_test.dart';
import 'package:aqua_code/app.dart';

void main() {
  testWidgets('Aqua Code app should render', (WidgetTester tester) async {
    await tester.pumpWidget(const AquaCodeApp());
    expect(find.text('Aqua Code'), findsOneWidget);
  });
}
