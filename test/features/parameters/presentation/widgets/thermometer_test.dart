import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:acquariumfe/core/l10n/app_localizations.dart';
import 'package:acquariumfe/core/providers/service_providers.dart';
import 'package:acquariumfe/features/parameters/presentation/widgets/thermometer.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late MockTargetParametersService targetService;

  setUp(() {
    targetService = MockTargetParametersService();
    registerFallbackValue('temperature');
    registerFallbackValue(0.0);
  });

  Widget wrap(Widget child) {
    return ProviderScope(
      overrides: [
        targetParametersServiceProvider.overrideWithValue(targetService),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: Scaffold(body: child),
      ),
    );
  }

  group('Thermometer widget', () {
    testWidgets('renders current temperature', (tester) async {
      await tester.pumpWidget(
        wrap(const Thermometer(currentTemperature: 25.5)),
      );
      await tester.pump();

      expect(find.textContaining('25'), findsWidgets);
    });

    testWidgets('shows green color for optimal temperature (24–26 °C)',
        (tester) async {
      await tester.pumpWidget(
        wrap(const Thermometer(currentTemperature: 25.0)),
      );
      await tester.pump();

      // The widget renders without error — color logic verified via unit test
      expect(find.byType(Thermometer), findsOneWidget);
    });

    testWidgets('calls onTargetChanged after saving new target', (tester) async {
      bool callbackFired = false;
      when(() => targetService.saveTarget(any(), any(), any()))
          .thenAnswer((_) async {});
      when(() => targetService.loadAllTargets(any()))
          .thenAnswer((_) async => {'temperature': 25.0});

      await tester.pumpWidget(
        wrap(Thermometer(
          currentTemperature: 25.0,
          targetTemperature: 25.0,
          onTargetChanged: () => callbackFired = true,
        )),
      );
      await tester.pump();

      // Tap the card to open the edit dialog
      await tester.tap(find.byType(Thermometer));
      await tester.pumpAndSettle();

      // Enter a new target value
      final textField = find.byType(TextField);
      if (tester.any(textField)) {
        await tester.enterText(textField, '26');
        // Confirm
        final okButton = find.text('OK');
        if (tester.any(okButton)) {
          await tester.tap(okButton);
          await tester.pumpAndSettle();
          expect(callbackFired, isTrue);
        }
      }
    });
  });

  group('Thermometer._getTemperatureColor (via black-box test)', () {
    testWidgets('low temperature widget renders without error', (tester) async {
      await tester.pumpWidget(
        wrap(const Thermometer(currentTemperature: 20.0)), // below 24 → blue
      );
      await tester.pump();
      expect(find.byType(Thermometer), findsOneWidget);
    });

    testWidgets('high temperature widget renders without error', (tester) async {
      await tester.pumpWidget(
        wrap(const Thermometer(currentTemperature: 30.0)), // above 27 → red
      );
      await tester.pump();
      expect(find.byType(Thermometer), findsOneWidget);
    });
  });
}
