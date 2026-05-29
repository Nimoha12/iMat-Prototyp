// filter_selection.dart
//
// Representerar multi-select för filterpanelen utan att röra UiCategory.
// Kan användas både för huvudkategorier och underkategorier.

import '../Category/ui_categories.dart';

class FilterSelection {
  // Multi-select för huvudkategorier (Alla varor / Utvald kasse)
  final Set<UiCategory> selectedMainCategories;

  // Multi-select för underkategorier (t.ex. Rotfrukter, Bär, Pasta & Ris)
  final Set<String> selectedSubCategories;

  const FilterSelection({
    this.selectedMainCategories = const {},
    this.selectedSubCategories = const {},
  });

  // Kopia med ändringar
  FilterSelection copyWith({
    Set<UiCategory>? selectedMainCategories,
    Set<String>? selectedSubCategories,
  }) {
    return FilterSelection(
      selectedMainCategories:
          selectedMainCategories ?? this.selectedMainCategories,
      selectedSubCategories:
          selectedSubCategories ?? this.selectedSubCategories,
    );
  }

  // Lägga till huvudkategori
  FilterSelection addMain(UiCategory cat) {
    final newSet = Set<UiCategory>.from(selectedMainCategories)..add(cat);
    return copyWith(selectedMainCategories: newSet);
  }

  // Ta bort huvudkategori
  FilterSelection removeMain(UiCategory cat) {
    final newSet = Set<UiCategory>.from(selectedMainCategories)..remove(cat);
    return copyWith(selectedMainCategories: newSet);
  }

  // Toggle huvudkategori
  FilterSelection toggleMain(UiCategory cat) {
    return selectedMainCategories.contains(cat)
        ? removeMain(cat)
        : addMain(cat);
  }

  // Lägga till underkategori
  FilterSelection addSub(String sub) {
    final newSet = Set<String>.from(selectedSubCategories)..add(sub);
    return copyWith(selectedSubCategories: newSet);
  }

  // Ta bort underkategori
  FilterSelection removeSub(String sub) {
    final newSet = Set<String>.from(selectedSubCategories)..remove(sub);
    return copyWith(selectedSubCategories: newSet);
  }

  // Toggle underkategori
  FilterSelection toggleSub(String sub) {
    return selectedSubCategories.contains(sub)
        ? removeSub(sub)
        : addSub(sub);
  }

  // Rensa allt
  FilterSelection clear() {
    return const FilterSelection(
      selectedMainCategories: {},
      selectedSubCategories: {},
    );
  }
}
