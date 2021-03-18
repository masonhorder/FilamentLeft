import 'package:filament_left/models/optIn.dart';

abstract class OptInEvent {}



class UpdateOptIn extends OptInEvent {
  OptIn newOptIn;
  int optInIndex;

  UpdateOptIn(int index, OptIn optIn) {
    newOptIn = optIn;
    optInIndex = index;
  }
}



class SetOptIns extends OptInEvent {
  List<OptIn> optInList;

  SetOptIns(List<OptIn> optIns) {
    optInList = optIns;
  }
}




class AddOptIn extends OptInEvent {
  OptIn newOptIn;

  AddOptIn(OptIn optIn) {
    newOptIn = optIn;
  }
}




class DeleteOptIn extends OptInEvent {
  int optInIndex;

  DeleteOptIn(int index) {
    optInIndex = index;
  }
}
















