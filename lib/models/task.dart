/// Modèle représentant une tâche académique dans CampusFlow.
class Task {
  final String id;
  final String titre;
  final String cours;
  final DateTime echeance;
  final String? description;
  final bool terminee;

  const Task({
    required this.id,
    required this.titre,
    this.cours = 'Mobile',
    required this.echeance,
    this.description,
    this.terminee = false,
  });

  Task copyWith({
    String? id,
    String? titre,
    String? cours,
    DateTime? echeance,
    String? description,
    bool? terminee,
  }) {
    return Task(
      id: id ?? this.id,
      titre: titre ?? this.titre,
      cours: cours ?? this.cours,
      echeance: echeance ?? this.echeance,
      description: description ?? this.description,
      terminee: terminee ?? this.terminee,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      titre: json['titre'] as String,
      cours: json['cours'] as String? ?? 'Mobile',
      echeance: DateTime.parse(json['echeance'] as String),
      description: json['description'] as String?,
      terminee: json['terminee'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'cours': cours,
      'echeance': echeance.toIso8601String(),
      if (description != null) 'description': description,
      'terminee': terminee,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task &&
        other.id == id &&
        other.titre == titre &&
        other.cours == cours &&
        other.echeance == echeance &&
        other.description == description &&
        other.terminee == terminee;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      titre.hashCode ^
      cours.hashCode ^
      echeance.hashCode ^
      description.hashCode ^
      terminee.hashCode;
}

