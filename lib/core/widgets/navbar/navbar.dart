/// Top application bar with the aquarium management popup menu.
library;

import 'package:acquariumfe/core/routing/custom_page_route.dart';
import 'package:acquariumfe/core/theme/app_semantic_colors.dart';
import 'package:acquariumfe/features/aquarium/presentation/views/add_aquarium.dart';
import 'package:acquariumfe/features/aquarium/presentation/views/edit_aquarium.dart';
import 'package:acquariumfe/features/aquarium/presentation/views/delete_aquarium.dart';
import 'package:acquariumfe/core/l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Application-level [AppBar] that implements [PreferredSizeWidget].
///
/// Contains a single popup menu (triggered by a `FontAwesomeIcons.circlePlus`
/// button) with three actions:
/// - **Add** — navigates to [AddAquarium] with a slide-from-bottom transition
/// - **Edit** — navigates to [EditAquarium] with a fade-slide transition
/// - **Delete** — navigates to [DeleteAquarium] with a fade-slide transition
///
/// The plus icon animates by rotating 45 ° while the menu is open
/// (`_iconController`), giving visual feedback that the menu is active.
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
    final l10n = AppLocalizations.of(context)!;
    final c = context.semantic;

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
                        color: c.statusOptimal.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.circlePlus,
                        color: c.statusOptimal,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(l10n.addAquarium,
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
                        color: c.statusLow.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.pen,
                        color: c.statusLow,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(l10n.editAquariumTitle,
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
                        color: c.statusError.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.trash,
                        color: c.statusError,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(l10n.deleteAquariumTitle,
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
