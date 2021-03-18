import 'package:filament_left/events/optInEvent.dart';
import 'package:filament_left/models/optIn.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OptInBloc extends Bloc<OptInEvent, List<OptIn>> {
  OptInBloc(List<OptIn> initialState) : super(List<OptIn>());

  // @override
  // List<Food> get initialState => List<Food>();

  @override
  Stream<List<OptIn>> mapEventToState(OptInEvent event) async* {
    if (event is SetOptIns) {
      yield event.optInList;
    } else if (event is AddOptIn) {
      List<OptIn> newState = List.from(state);
      if (event.newOptIn != null) {
        newState.add(event.newOptIn);
      }
      yield newState;
    } else if (event is DeleteOptIn) {
      List<OptIn> newState = List.from(state);
      newState.removeAt(event.optInIndex);
      yield newState;
    } else if (event is UpdateOptIn) {
      List<OptIn> newState = List.from(state);
      newState[event.optInIndex] = event.newOptIn;
      yield newState;
    }
  }
}