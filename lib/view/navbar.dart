import 'package:flutter/material.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Aquarium App'),
      backgroundColor: const Color.fromARGB(255, 126, 173, 255),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
