/// Named route configuration for the ReefLife app.
///
/// [AppRouter.generateRoute] maps route name strings (from [RouteNames]) to
/// their corresponding screen widgets, forwarding typed arguments as needed.
library;

import 'package:acquariumfe/main.dart';
import 'package:acquariumfe/core/routing/routes_name.dart';
import 'package:acquariumfe/features/aquarium/presentation/views/add_aquarium.dart';
import 'package:acquariumfe/features/aquarium/presentation/views/aquarium_details.dart';
import 'package:acquariumfe/features/aquarium/presentation/views/delete_aquarium.dart';
import 'package:acquariumfe/features/aquarium/presentation/views/edit_aquarium.dart';
import 'package:acquariumfe/features/maintenance/presentation/views/maintenance_view.dart';
import 'package:flutter/material.dart';

/// Central route factory used by [MaterialApp.onGenerateRoute].
///
/// All named navigation calls go through here. Arguments are cast from
/// [RouteSettings.arguments]; unknown routes fall back to [HomePage].
class AppRouter {
  /// Generates a [Route] for the given [settings].
  ///
  /// Supported routes and their expected argument types:
  /// | Route name                  | Argument type |
  /// |-----------------------------|---------------|
  /// | [RouteNames.details]        | `int?` aquariumId |
  /// | [RouteNames.addAquarium]    | none |
  /// | [RouteNames.editAquarium]   | none |
  /// | [RouteNames.deleteAquarium] | none |
  /// | [RouteNames.maintenance]    | `int?` aquariumId |
  /// | (default)                   | none — shows [HomePage] |
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.details:
        final aquariumId = settings.arguments as int?;
        return MaterialPageRoute(
          builder: (_) => AquariumDetails(aquariumId: aquariumId),
        );

      case RouteNames.addAquarium:
        return MaterialPageRoute(builder: (_) => const AddAquarium());

      case RouteNames.editAquarium:
        return MaterialPageRoute(builder: (_) => const EditAquarium());

      case RouteNames.deleteAquarium:
        return MaterialPageRoute(builder: (_) => const DeleteAquarium());

      case RouteNames.maintenance:
        final aquariumId = settings.arguments as int?;
        return MaterialPageRoute(
          builder: (_) => MaintenanceView(aquariumId: aquariumId),
        );

      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}
