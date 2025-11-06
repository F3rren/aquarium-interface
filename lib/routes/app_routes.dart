import 'package:acquariumfe/main.dart';
import 'package:acquariumfe/routes/routes_name.dart';
import 'package:acquariumfe/view/aquarium_details.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.details:
        return MaterialPageRoute(builder: (_) => AquariumDetails());


      default:
        return MaterialPageRoute(builder: (_) => HomePage());
    }
  }
}