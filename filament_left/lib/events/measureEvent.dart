import 'package:filament_left/models/measure.dart';

abstract class MeasureEvent {}



class UpdateMeasure extends MeasureEvent {
  Measure newMeasure;
  int measureIndex;

  UpdateMeasure(int index, Measure measure) {
    newMeasure = measure;
    measureIndex = index;
  }
}



class SetMeasures extends MeasureEvent {
  List<Measure> measureList;

  SetMeasures(List<Measure> measures) {
    measureList = measures;
  }
}




class AddMeasure extends MeasureEvent {
  Measure newMeasure;

  AddMeasure(Measure measure) {
    newMeasure = measure;
  }
}




class DeleteMeasure extends MeasureEvent {
  int measureIndex;

  DeleteMeasure(int index) {
    measureIndex = index;
  }
}
