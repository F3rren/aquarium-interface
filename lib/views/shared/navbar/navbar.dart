import 'package:acquariumfe/utils/custom_page_route.dart';
import 'package:acquariumfe/views/aquarium/add_aquarium.dart';
import 'package:acquariumfe/views/aquarium/edit_aquarium.dart';
import 'package:acquariumfe/views/aquarium/delete_aquarium.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Navbar extends StatefulWidget implements PreferredSizeWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _NavbarState extends State<Navbar> with SingleTickerProviderStateMixin {
  late AnimationController _iconController;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      // title: Text(//   'Aquarium App',
      //   style: TextStyle(
      //     fontSize: 18,
      //     fontWeight: FontWeight.w500,
      //     letterSpacing: 1.2,
      //   ),
      // ),
      backgroundColor: theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.foregroundColor,
      elevation: 0,
      centerTitle: true,
      actions: [
        PopupMenuButton<String>(
          icon: RotationTransition(
            turns: Tween<double>(
              begin: 0.0,
              end: 0.125,
            ).animate(_iconController),
            child: const FaIcon(FontAwesomeIcons.circlePlus, size: 24),
          ),
          tooltip: 'Gestisci Acquari',
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
            ),
          ),
          onOpened: () => _iconController.forward(),
          onCanceled: () => _iconController.reverse(),
          onSelected: (value) {
            _iconController.reverse();
            switch (value) {
              case 'add':
                Navigator.push(
                  context,
                  CustomPageRoute(
                    page: const AddAquarium(),
                    transitionType: PageTransitionType.slideFromBottom,
                  ),
                );
                break;
              case 'edit':
                Navigator.push(
                  context,
                  CustomPageRoute(
                    page: const EditAquarium(),
                    transitionType: PageTransitionType.fadeSlide,
                  ),
                );
                break;
              case 'delete':
                Navigator.push(
                  context,
                  CustomPageRoute(
                    page: const DeleteAquarium(),
                    transitionType: PageTransitionType.fadeSlide,
                  ),
                );
                break;
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'add',
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF34d399).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.circlePlus,
                        color: Color(0xFF34d399),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('Aggiungi Vasca',
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: 'edit',
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF60a5fa).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.pen,
                        color: Color(0xFF60a5fa),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('Modifica Vasca',
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: 'delete',
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFef4444).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.trash,
                        color: Color(0xFFef4444),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('Elimina Vasca',
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
