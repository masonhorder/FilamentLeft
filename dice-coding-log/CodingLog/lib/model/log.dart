class Log {
  var id;
  int timeSpent;
  int side;
  int startTime;


  Log();

  Log.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    timeSpent = data['timeSpent'];
    startTime = data['startTime'];
    side = data['side'];

  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timeSpent': timeSpent,
      'side': side,
      'startTime': startTime
    };
  }
}
