import 'package:filament_left/events/spoolEvent.dart';
import 'package:filament_left/models/spool.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpoolBloc extends Bloc<SpoolEvent, List<Spool>> {
  SpoolBloc(List<Spool> initialState) : super([]);

  // @override
  // List<Food> get initialState => List<Food>();

  @override
  Stream<List<Spool>> mapEventToState(SpoolEvent event) async* {
    if (event is SetSpools) {
      yield event.spoolList;
    } else if (event is AddSpool) {
      List<Spool> newState = List.from(state);
      if (event.newSpool != null) {
        newState.add(event.newSpool);
      }
      yield newState;
    } else if (event is DeleteSpool) {
      List<Spool> newState = List.from(state);
      newState.removeAt(event.spoolIndex);
      yield newState;
    } else if (event is UpdateSpool) {
      List<Spool> newState = List.from(state);
      newState[event.spoolIndex] = event.newSpool;
      yield newState;
    }
  }
}
