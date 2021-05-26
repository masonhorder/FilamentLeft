import 'package:filament_left/events/profileEvent.dart';
import 'package:filament_left/models/profiles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, List<Profile>> {
  ProfileBloc(List<Profile> initialState) : super([]);

  // @override
  // List<Food> get initialState => List<Food>();

  @override
  Stream<List<Profile>> mapEventToState(ProfileEvent event) async* {
    if (event is SetProfiles) {
      yield event.profileList;
    } else if (event is AddProfile) {
      List<Profile> newState = List.from(state);
      if (event.newProfile != null) {
        newState.add(event.newProfile);
      }
      yield newState;
    } else if (event is DeleteProfile) {
      List<Profile> newState = List.from(state);
      newState.removeAt(event.profileIndex);
      yield newState;
    } else if (event is UpdateProfile) {
      List<Profile> newState = List.from(state);
      newState[event.profileIndex] = event.newProfile;
      yield newState;
    }
  }
}