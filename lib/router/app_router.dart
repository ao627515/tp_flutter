import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/connexion_screen.dart';
import '../screens/cours_screen.dart';
import '../screens/detail_tache_screen.dart';
import '../screens/echeances_screen.dart';
import '../screens/nouvelle_tache_screen.dart';
import '../screens/profil_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

/// Configuration des routes de l'application CampusFlow.
final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/taches',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const ConnexionScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/taches',
          builder: (context, state) => const EcheancesScreen(),
        ),
        GoRoute(
          path: '/cours',
          builder: (context, state) => const CoursScreen(),
        ),
        GoRoute(
          path: '/profil',
          builder: (context, state) => const ProfilScreen(),
        ),
      ],
    ),
    // Les routes secondaires sont déclarées avec priorité pour les chemins statiques.
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/taches/nouvelle',
      builder: (context, state) => const NouvelleTacheScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/taches/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return DetailTacheScreen(id: id);
      },
    ),
  ],
);

/// Coquille de navigation contenant la barre inférieure Material 3.
class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({
    super.key,
    required this.child,
  });

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/cours')) {
      return 1;
    }
    if (location.startsWith('/profil')) {
      return 2;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/taches');
        break;
      case 1:
        context.go('/cours');
        break;
      case 2:
        context.go('/profil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.check_box_outlined),
            selectedIcon: Icon(Icons.check_box),
            label: 'Échéances',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'Cours',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

