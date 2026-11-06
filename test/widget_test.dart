import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tp4/main.dart';
import 'package:tp4/models/task.dart';
import 'package:tp4/providers/task_providers.dart';

void main() {
  testWidgets('CampusFlow affiche initialement un état vide',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: CampusFlowApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Cette semaine'), findsOneWidget);
    expect(find.text('Aucune tâche correspondante'), findsOneWidget);
  });

  testWidgets('Ajouter et cocher une tâche met à jour l\'affichage et l\'état',
      (WidgetTester tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const CampusFlowApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Ajout d'une tâche via le notifier
    container.read(tachesProvider.notifier).ajouter(
          Task(
            id: '1',
            titre: 'Rendu TP Dart',
            cours: 'Mobile',
            echeance: DateTime.now().add(const Duration(days: 1)),
            terminee: false,
          ),
        );
    await tester.pumpAndSettle();

    expect(find.text('Rendu TP Dart'), findsOneWidget);

    // Coche la tâche
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();

    final task = container.read(tachesProvider).firstWhere((t) => t.id == '1');
    expect(task.terminee, true);

    // Filtrage sur "À faire" : la tâche terminée disparaît
    await tester.tap(find.text('À faire'));
    await tester.pumpAndSettle();

    expect(find.text('Rendu TP Dart'), findsNothing);
    expect(find.text('Aucune tâche correspondante'), findsOneWidget);

    // Filtrage sur "Faites" : la tâche réapparaît
    await tester.tap(find.text('Faites'));
    await tester.pumpAndSettle();

    expect(find.text('Rendu TP Dart'), findsOneWidget);
  });
}
