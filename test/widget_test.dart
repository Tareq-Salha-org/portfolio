import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salha_portfolio/core/data/portfolio_data.dart';
import 'package:salha_portfolio/main.dart';

void main() {
  setUp(() {
    // PortfolioData keeps static state for the whole session; reset it so
    // every test starts from the pristine unloaded state. The asset loader is
    // swapped for a synchronous file read — deterministic under the
    // fake-async test zone, unlike the real asset channel.
    PortfolioData.resetForTesting();
    final json = File('assets/data/portfolio_data.json').readAsStringSync();
    PortfolioData.assetLoader = () async => json;
  });

  testWidgets('App shows a loading gate, then the portfolio', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SalhaPortfolio());

    // The very first frame is the branded loading gate — never an empty
    // portfolio. The JSON bootstrap is kicked off from the app root.
    expect(find.text('Loading portfolio'), findsOneWidget);

    // Let the async load complete and the gate swap to the portfolio.
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
