import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task.dart';
import '../providers/task_providers.dart';

/// Contenu détaillé d'une tâche réutilisable sur mobile et tablette.
class TaskDetailCard extends ConsumerWidget {
  final Task task;

  const TaskDetailCard({
    super.key,
    required this.task,
  });

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year à ${hour}h$minute';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isOverdue = !task.terminee && task.echeance.isBefore(DateTime.now());

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          task.titre,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration: task.terminee
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                      if (task.terminee)
                        const Chip(
                          label: Text('Terminée'),
                          avatar: Icon(Icons.check_circle, color: Colors.green),
                        )
                      else if (isOverdue)
                        Chip(
                          label: const Text('En retard'),
                          avatar: Icon(Icons.warning, color: theme.colorScheme.error),
                          backgroundColor:
                              theme.colorScheme.errorContainer.withValues(alpha: 0.4),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.school_outlined, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Cours : ${task.cours}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Échéance : ${_formatDate(task.echeance)}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  Text(
                    'Description',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    task.description?.isNotEmpty == true
                        ? task.description!
                        : 'Aucune description fournie.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              ref.read(tachesProvider.notifier).basculer(task.id);
            },
            icon: Icon(task.terminee ? Icons.undo : Icons.check),
            label: Text(
              task.terminee ? 'Marquer comme non fait' : 'Marquer comme fait',
            ),
          ),
        ],
      ),
    );
  }
}

/// Écran complet de détail d'une tâche.
class DetailTacheScreen extends ConsumerWidget {
  final String id;

  const DetailTacheScreen({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(taskByIdProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: Text(task?.titre ?? 'Détail de la tâche'),
      ),
      body: task == null
          ? const Center(child: Text('Tâche introuvable'))
          : SingleChildScrollView(
              child: TaskDetailCard(task: task),
            ),
    );
  }
}

