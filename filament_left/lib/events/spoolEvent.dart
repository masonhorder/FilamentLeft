import 'package:filament_left/models/spool.dart';

abstract class SpoolEvent {}



class UpdateSpool extends SpoolEvent {
  Spool newSpool;
  int spoolIndex;

  UpdateSpool(int index, Spool spool) {
    newSpool = spool;
    spoolIndex = index;
  }
}



class SetSpools extends SpoolEvent {
  List<Spool> spoolList;

  SetSpools(List<Spool> spools) {
    spoolList = spools;
  }
}




class AddSpool extends SpoolEvent {
  Spool newSpool;

  AddSpool(Spool spool) {
    newSpool = spool;
  }
}




class DeleteSpool extends SpoolEvent {
  int spoolIndex;

  DeleteSpool(int index) {
    spoolIndex = index;
  }
}
