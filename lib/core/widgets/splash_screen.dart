/// Minimal loading screen displayed while the app initialises.
library;

import 'package:flutter/material.dart';

/// Displays the app icon centred on a plain scaffold.
///
/// Shown by the router while async initialisation (token check, aquarium load)
/// is in progress. Replaced automatically once the router resolves the initial
/// route.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset('assets/icon/app_icon.png', height: 128)),
    );
  }
}
