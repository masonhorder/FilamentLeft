class MainDataSettings{
  var id;
  bool active;



  MainDataSettings();

  MainDataSettings.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    active = data['active'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'active': active,
    };
  }
}