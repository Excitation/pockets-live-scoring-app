import 'dart:convert';

/// Player model to encapsulate the player attributes
class Player {
  /// construtor of the class
  Player({
    required this.id,
    required this.firstName,
    this.middleName,
    this.lastName,
    this.imageUrl,
    this.alias = '',
    this.score = 0,
  });

  /// Create the player from the map/object
  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'] as int,
      firstName: map['first_name'] as String,
      middleName: map['middle_name'] as String?,
      lastName: map['last_name'] as String?,
      imageUrl: map['image_url'] as String?,
      alias: map['alias'] as String,
      score: map['score'] as int,
    );
  }

  /// Create the player model from the json string
  factory Player.fromJson(String source) =>
      Player.fromMap(jsonDecode(source) as Map<String, dynamic>);

  /// none player
  factory Player.none() => Player(
        id: 0,
        firstName: '',
        middleName: '',
        lastName: '',
        imageUrl: '',
      );

  /// id of the player
  final int id;

  /// first name of the player
  final String firstName;

  /// middle name of the player
  final String? middleName;

  /// last name of the player
  final String? lastName;

  /// avatar/image url of the player
  final String? imageUrl;

  /// alias of the player
  final String alias;

  /// score of the player
  final int score;

  /// Convert the player model to the json string
  String toJson() => jsonEncode(toMap());

  /// Convert the player model to the map/object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'image_url': imageUrl,
      'alias': alias,
      'score': score,
    };
  }

  /// Convert the player model to the string
  @override
  String toString() {
    // ignore: lines_longer_than_80_chars
    return 'Player(id: $id, firstName: $firstName, middleName: $middleName,lastName: $lastName, imageUrl: $imageUrl, alias: $alias, score: $score)';
  }
}
