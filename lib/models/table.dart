/// Table model that is used to encapsulate the table data.
class Table {
  /// The constructor of the class.
  Table({
    required this.id,
    required this.name,
  });

  /// Converts the json to a [Table] object.
  factory Table.fromJson(Map<String, dynamic> json) => Table(
        id: json['id'] as int,
        name: json['name'] as String,
      );

  /// id of the table.
  final int id;

  /// name of the table.
  final String name;

  @override
  String toString() => 'Table(id: $id, name: $name)';
}
