import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/task.dart';
import '../providers/task_providers.dart';
import 'detail_tache_screen.dart';

/// Écran principal présentant la liste des échéances avec filtrage et vue adaptative.
class EcheancesScreen extends ConsumerStatefulWidget {
  const EcheancesScreen({super.key});

  @override
  ConsumerState<EcheancesScreen> createState() => _EcheancesScreenState();
}

class _EcheancesScreenState extends ConsumerState<EcheancesScreen> {
  String? _selectedTaskId;

  String _formatEcheance(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays == 0 && date.day == now.day) {
      return 'aujourd\'hui';
    } else if (difference.inDays >= 0 && difference.inDays <= 1) {
      return 'demain';
    } else if (difference.inDays > 1 && difference.inDays <= 6) {
      const jours = ['lun.', 'mar.', 'mer.', 'jeu.', 'ven.', 'sam.', 'dim.'];
      return jours[date.weekday - 1];
    }

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month';
  }

  Widget _buildTaskListView({
    required List<Task> tasks,
    required bool isTablet,
  }) {
    if (tasks.isEmpty) {
      return const Center(
        child: Text('Aucune tâche correspondante'),
      );
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final isSelected = isTablet && task.id == _selectedTaskId;
        final isOverdue =
            !task.terminee && task.echeance.isBefore(DateTime.now());

        return ListTile(
          selected: isSelected,
          leading: Checkbox(
            value: task.terminee,
            onChanged: (_) {
              ref.read(tachesProvider.notifier).basculer(task.id);
            },
          ),
          title: Text(
            task.titre,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              decoration:
                  task.terminee ? TextDecoration.lineThrough : null,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text('${task.cours} · ${_formatEcheance(task.echeance)}'),
          trailing: isOverdue
              ? const Icon(Icons.error_outline, color: Colors.red, size: 20)
              : null,
          onTap: () {
            if (isTablet) {
              setState(() {
                _selectedTaskId = task.id;
              });
            } else {
              context.push('/taches/${task.id}');
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeFilter = ref.watch(filterProvider);
    final tasks = ref.watch(filteredTasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cette semaine'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/taches/nouvelle'),
        tooltip: 'Nouvelle tâche',
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SegmentedButton<TaskFilter>(
                segments: const [
                  ButtonSegment(
                    value: TaskFilter.toutes,
                    label: Text('Toutes'),
                  ),
                  ButtonSegment(
                    value: TaskFilter.aFaire,
                    label: Text('À faire'),
                  ),
                  ButtonSegment(
                    value: TaskFilter.faites,
                    label: Text('Faites'),
                  ),
                  ButtonSegment(
                    value: TaskFilter.enRetard,
                    label: Text('En retard'),
                  ),
                ],
                selected: {activeFilter},
                onSelectionChanged: (selection) {
                  ref
                      .read(filterProvider.notifier)
                      .setFilter(selection.first);
                },
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 840) {
                  final allTasks = ref.watch(tachesProvider);
                  final selectedTask = allTasks
                      .cast<Task?>()
                      .firstWhere(
                        (t) => t?.id == _selectedTaskId,
                        orElse: () => tasks.isNotEmpty ? tasks.first : null,
                      );

                  return Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildTaskListView(
                          tasks: tasks,
                          isTablet: true,
                        ),
                      ),
                      const VerticalDivider(width: 1),
                      Expanded(
                        flex: 3,
                        child: selectedTask == null
                            ? const Center(
                                child: Text('Sélectionnez une tâche pour voir son détail'),
                              )
                            : SingleChildScrollView(
                                child: TaskDetailCard(task: selectedTask),
                              ),
                      ),
                    ],
                  );
                }

                return _buildTaskListView(
                  tasks: tasks,
                  isTablet: false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

