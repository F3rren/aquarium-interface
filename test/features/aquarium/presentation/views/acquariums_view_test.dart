import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:acquariumfe/core/l10n/app_localizations.dart';
import 'package:acquariumfe/core/widgets/skeleton_loader.dart';
import 'package:acquariumfe/core/widgets/empty_state.dart';
import 'package:acquariumfe/features/aquarium/presentation/views/acquariums_view.dart';
import 'package:acquariumfe/features/aquarium/presentation/providers/aquarium_providers.dart';
import 'package:acquariumfe/core/utils/exceptions.dart';

// ── Test notifier stubs ───────────────────────────────────────────────────────
// Extend [Aquariums] (the real notifier class) so that [overrideWith]
// type-checks correctly.

/// Stays in loading forever.
class _LoadingAquariums extends Aquariums {
  @override
  Future<List<AquariumWithParams>> build() =>
      Completer<List<AquariumWithParams>>().future;
}

/// Immediately resolves to empty list.
class _EmptyAquariums extends Aquariums {
  @override
  Future<List<AquariumWithParams>> build() async => [];
}

/// Immediately throws NetworkException.
class _ErrorAquariums extends Aquariums {
  @override
  Future<List<AquariumWithParams>> build() async =>
      throw NetworkException('no internet');
}

// ── Widget wrapper ────────────────────────────────────────────────────────────

Widget _wrap(Widget child, {List<Override> overrides = const []}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: child,
    ),
  );
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('AquariumView — loading state', () {
    testWidgets('shows skeleton loaders while fetching', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AquariumView(),
          overrides: [
            aquariumsProvider.overrideWith(_LoadingAquariums.new),
          ],
        ),
      );

      await tester.pump(); // one frame — still loading

      expect(find.byType(AquariumCardSkeleton), findsWidgets);
    });
  });

  group('AquariumView — empty state', () {
    testWidgets('shows EmptyState when list is empty', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AquariumView(),
          overrides: [
            aquariumsProvider.overrideWith(_EmptyAquariums.new),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(EmptyState), findsOneWidget);
    });
  });

  group('AquariumView — error state', () {
    testWidgets('shows an ElevatedButton retry on fetch failure', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AquariumView(),
          overrides: [
            aquariumsProvider.overrideWith(_ErrorAquariums.new),
          ],
        ),
      );

      await tester.pumpAndSettle();

      // Error state renders an ElevatedButton.icon with a retry label.
      // Use a subtype-tolerant predicate: ElevatedButton.icon can return a
      // private _ElevatedButtonWithIcon subclass on some Flutter versions,
      // which find.byType(ElevatedButton) (exact runtime-type match) misses.
      expect(
        find.byWidgetPredicate((w) => w is ElevatedButton),
        findsOneWidget,
      );
    });
  });
}
