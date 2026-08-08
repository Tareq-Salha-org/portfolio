import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salha_portfolio/core/data/portfolio_data.dart';
import 'package:salha_portfolio/main.dart';

void main() {
  setUp(() {
    // PortfolioData keeps static state for the whole session; reset it so
    // every test starts from the pristine unloaded state.
    PortfolioData.resetForTesting();
  });

  testWidgets('App shows a loading gate, then the portfolio', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SalhaPortfolio());

    // The very first frame is the branded loading gate — never an empty
    // portfolio. The JSON bootstrap is kicked off from the app root.
    expect(find.text('Loading portfolio'), findsOneWidget);

    // The asset fetch is real async I/O, which must run inside runAsync in
    // the fake-async test zone. Joins the load already started in initState.
    await tester.runAsync(() => PortfolioData.load());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Tareq Fareed Salha'), findsWidgets);

    // Tear the tree down and let the visibility-detector polling timer fire
    // so no timers remain pending at the end of the test.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 600));
  });

  testWidgets('Portfolio content renders without interaction', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SalhaPortfolio());
    await tester.runAsync(() => PortfolioData.load());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Content parsed straight from portfolio_data.json is on screen — the
    // name and a project name that ships with the JSON.
    expect(find.text('Tareq Fareed Salha'), findsWidgets);
    expect(find.text('York Educational Platform'), findsWidgets);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 600));
  });
}
