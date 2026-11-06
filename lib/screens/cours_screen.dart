import 'package:flutter/material.dart';

/// Écran présentant la liste des cours suivis.
class CoursScreen extends StatelessWidget {
  const CoursScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cours = [
      {
        'code': 'MOB',
        'titre': 'Programmation Mobile',
        'enseignant': 'M. COMPAORE',
      },
      {
        'code': 'UXUI',
        'titre': 'Design UX & Wireframes',
        'enseignant': 'Université Aube Nouvelle',
      },
      {
        'code': 'RES',
        'titre': 'Réseaux & Sécurité',
        'enseignant': 'Dr. KABORE',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes cours'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: cours.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final item = cours[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text(item['code'] ?? ''),
              ),
              title: Text(item['titre'] ?? ''),
              subtitle: Text(item['enseignant'] ?? ''),
            ),
          );
        },
      ),
    );
  }
}

