import 'package:acquariumfe/main.dart';
import 'package:acquariumfe/routes/routes_name.dart';
import 'package:acquariumfe/views/aquarium/add_aquarium.dart';
import 'package:acquariumfe/views/aquarium/aquarium_details.dart';
import 'package:acquariumfe/views/aquarium/delete_aquarium.dart';
import 'package:acquariumfe/views/aquarium/edit_aquarium.dart';
import 'package:acquariumfe/views/maintenance/maintenance_view.dart';
import 'package:flutter/material.dart';

class AppRouter {
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
