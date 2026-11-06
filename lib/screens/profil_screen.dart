import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Écran affichant le profil de l'étudiant et les paramètres.
class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 80,
                  width: 80,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Amina',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'amina@campusflow.bf',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Chip(
              label: const Text('Master 1 Informatique'),
              backgroundColor: theme.colorScheme.secondaryContainer,
            ),
            const SizedBox(height: 24),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.school_outlined),
              title: const Text('Établissement'),
              subtitle: const Text('Université Aube Nouvelle'),
            ),
            ListTile(
              leading: const Icon(Icons.phone_android_outlined),
              title: const Text('Appareil'),
              subtitle: const Text('Android (360×800 dp)'),
            ),
            ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: const Text('Design System'),
              subtitle: const Text('CampusFlow M3 (0xFFEC3013)'),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => context.go('/login'),
              icon: const Icon(Icons.logout),
              label: const Text('Se déconnecter'),
            ),
          ],
        ),
      ),
    );
  }
}

