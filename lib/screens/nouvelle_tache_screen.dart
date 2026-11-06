import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/task.dart';
import '../providers/task_providers.dart';

/// Écran de création d'une nouvelle tâche avec formulaire validé.
class NouvelleTacheScreen extends ConsumerStatefulWidget {
  const NouvelleTacheScreen({super.key});

  @override
  ConsumerState<NouvelleTacheScreen> createState() =>
      _NouvelleTacheScreenState();
}

class _NouvelleTacheScreenState extends ConsumerState<NouvelleTacheScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _coursController = TextEditingController(text: 'Mobile');
  final _descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 2));

  @override
  void dispose() {
    _titreController.dispose();
    _coursController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _choisirDate() async {
    final nouvelleDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (nouvelleDate != null) {
      setState(() {
        _selectedDate = DateTime(
          nouvelleDate.year,
          nouvelleDate.month,
          nouvelleDate.day,
          18,
          0,
        );
      });
    }
  }

  void _enregistrer() {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        titre: _titreController.text.trim(),
        cours: _coursController.text.trim(),
        echeance: _selectedDate,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        terminee: false,
      );

      ref.read(tachesProvider.notifier).ajouter(task);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tâche ajoutée avec succès'),
          duration: Duration(seconds: 2),
        ),
      );

      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle tâche'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titreController,
                decoration: const InputDecoration(
                  labelText: 'Titre de la tâche',
                  hintText: 'Ex. : Projet Flutter',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.assignment_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Titre requis';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _coursController,
                decoration: const InputDecoration(
                  labelText: 'Cours',
                  hintText: 'Ex. : Mobile, UXUI, Réseaux',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Cours requis';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event),
                title: const Text('Date d\'échéance'),
                subtitle: Text(
                  '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                ),
                trailing: TextButton(
                  onPressed: _choisirDate,
                  child: const Text('Modifier'),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description (facultative)',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _enregistrer,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Enregistrer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

