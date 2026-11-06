import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tp4/main.dart';
import 'package:tp4/providers/task_providers.dart';

void main() {
  testWidgets('CampusFlow affiche la liste des tâches et permet de filtrer',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: CampusFlowApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Cette semaine'), findsOneWidget);
    expect(find.text('Rendu TP Dart'), findsOneWidget);
    expect(find.text('Projet Flutter'), findsOneWidget);

    // Sélection du filtre "Faites"
    await tester.tap(find.text('Faites'));
    await tester.pumpAndSettle();

    expect(find.text('Configuration Android Studio'), findsOneWidget);
    expect(find.text('Rendu TP Dart'), findsNothing);

    // Retour au filtre "Toutes"
    await tester.tap(find.text('Toutes'));
    await tester.pumpAndSettle();

    expect(find.text('Rendu TP Dart'), findsOneWidget);
  });

  testWidgets('Cocher une tâche met à jour son état',
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

    final taskBefore =
        container.read(tachesProvider).firstWhere((t) => t.id == '1');
    expect(taskBefore.terminee, false);

    // Coche la première case de la liste
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();

    final taskAfter =
        container.read(tachesProvider).firstWhere((t) => t.id == '1');
    expect(taskAfter.terminee, true);
  });
}
