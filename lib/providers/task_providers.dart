import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task.dart';

/// Filtres applicables à la liste des échéances.
enum TaskFilter {
  toutes,
  aFaire,
  faites,
  enRetard,
}

/// Gestionnaire d'état de la sélection de filtre.
class FilterNotifier extends Notifier<TaskFilter> {
  @override
  TaskFilter build() => TaskFilter.toutes;

  void setFilter(TaskFilter filter) {
    state = filter;
  }
}

/// Fournisseur du filtre actif.
final filterProvider =
    NotifierProvider<FilterNotifier, TaskFilter>(FilterNotifier.new);

/// Gestionnaire d'état de la collection des tâches.
class TachesNotifier extends Notifier<List<Task>> {
  @override
  List<Task> build() {
    final now = DateTime.now();
    return [
      Task(
        id: '1',
        titre: 'Rendu TP Dart',
        cours: 'Mobile',
        echeance: now.add(const Duration(days: 1)),
        description: 'Modèles en Dart pur et tests unitaires',
        terminee: false,
      ),
      Task(
        id: '2',
        titre: 'Projet Flutter',
        cours: 'Mobile',
        echeance: now.add(const Duration(days: 4, hours: 3)),
        description: 'Architecture, navigation et gestion d\'état avec Riverpod',
        terminee: false,
      ),
      Task(
        id: '3',
        titre: 'Examen UX',
        cours: 'UXUI',
        echeance: now.subtract(const Duration(days: 1)),
        description: 'Wireframes, ergonomie et conformité accessibilité',
        terminee: false,
      ),
      Task(
        id: '4',
        titre: 'Configuration Android Studio',
        cours: 'Mobile',
        echeance: now.subtract(const Duration(days: 3)),
        description: 'Installation du SDK et validation avec flutter doctor',
        terminee: true,
      ),
    ];
  }

  void ajouter(Task task) {
    state = [...state, task];
  }

  void basculer(String id) {
    state = [
      for (final task in state)
        if (task.id == id) task.copyWith(terminee: !task.terminee) else task,
    ];
  }

  void supprimer(String id) {
    state = state.where((task) => task.id != id).toList();
  }
}

/// Fournisseur principal de la liste des tâches.
final tachesProvider =
    NotifierProvider<TachesNotifier, List<Task>>(TachesNotifier.new);

/// Fournisseur dérivé : tâches non terminées.
final tachesAFaireProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(tachesProvider);
  return tasks.where((t) => !t.terminee).toList();
});

/// Fournisseur dérivé : tâches terminées.
final tachesFaitesProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(tachesProvider);
  return tasks.where((t) => t.terminee).toList();
});

/// Fournisseur dérivé : tâches en retard.
final tachesEnRetardProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(tachesProvider);
  final now = DateTime.now();
  return tasks.where((t) => !t.terminee && t.echeance.isBefore(now)).toList();
});

/// Fournisseur dérivé filtrant selon le filtre sélectionné.
final filteredTasksProvider = Provider<List<Task>>((ref) {
  final filter = ref.watch(filterProvider);
  final tasks = ref.watch(tachesProvider);
  final now = DateTime.now();

  switch (filter) {
    case TaskFilter.aFaire:
      return tasks.where((t) => !t.terminee).toList();
    case TaskFilter.faites:
      return tasks.where((t) => t.terminee).toList();
    case TaskFilter.enRetard:
      return tasks
          .where((t) => !t.terminee && t.echeance.isBefore(now))
          .toList();
    case TaskFilter.toutes:
      return tasks;
  }
});

/// Fournisseur d'une tâche identifiée par son identifiant.
final taskByIdProvider = Provider.family<Task?, String>((ref, id) {
  final tasks = ref.watch(tachesProvider);
  try {
    return tasks.firstWhere((task) => task.id == id);
  } catch (_) {
    return null;
  }
});

