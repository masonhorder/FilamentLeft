class Sides {
  int side;
  String language;


  Sides();

  Sides.fromMap(Map<String, dynamic> data) {
    side = data['side'];
    language = data['language'];
  }

  Map<String, dynamic> toMap() {
    return {
      'side': side,
      'language': language
    };
  }
}
