import 'package:flutter_test/flutter_test.dart';
import 'package:salha_portfolio/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SalhaPortfolio());
    // PortfolioData.load() is async; give it time to complete.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Tareq Fareed Salha'), findsWidgets);
  });
}
