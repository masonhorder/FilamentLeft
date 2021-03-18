import 'package:filament_left/events/measureEvent.dart';
import 'package:filament_left/models/measure.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MeasureBloc extends Bloc<MeasureEvent, List<Measure>> {
  MeasureBloc(List<Measure> initialState) : super(List<Measure>());

  // @override
  // List<Food> get initialState => List<Food>();

  @override
  Stream<List<Measure>> mapEventToState(MeasureEvent event) async* {
    if (event is SetMeasures) {
      yield event.measureList;
    } else if (event is AddMeasure) {
      List<Measure> newState = List.from(state);
      if (event.newMeasure != null) {
        newState.add(event.newMeasure);
      }
      yield newState;
    } else if (event is DeleteMeasure) {
      List<Measure> newState = List.from(state);
      newState.removeAt(event.measureIndex);
      yield newState;
    } else if (event is UpdateMeasure) {
      List<Measure> newState = List.from(state);
      newState[event.measureIndex] = event.newMeasure;
      yield newState;
    }
  }
}
