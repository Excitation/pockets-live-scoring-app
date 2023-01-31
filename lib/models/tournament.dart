/// Tournament model
class Tournament {
  /// The constructor of the class.
  Tournament({
    required this.id,
    required this.name,
  });

  /// none tournament
  factory Tournament.none() => Tournament(
        id: 0,
        name: '',
      );

  /// Converts the json to a [Tournament] object.
  factory Tournament.fromJson(Map<String, dynamic> json) => Tournament(
        id: json['id'] as int,
        name: json['name'] as String,
      );

  /// id of the tournament.
  final int id;

  /// name of the tournament.
  final String name;

  @override
  String toString() => 'Tournament(id: $id, name: $name)';
}
