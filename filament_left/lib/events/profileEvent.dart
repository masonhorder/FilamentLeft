
import 'package:filament_left/models/profiles.dart';

abstract class ProfileEvent {}



class UpdateProfile extends ProfileEvent {
  Profile newProfile;
  int profileIndex;

  UpdateProfile(int index, Profile profile) {
    newProfile = profile;
    profileIndex = index;
  }
}



class SetProfiles extends ProfileEvent {
  List<Profile> profileList;

  SetProfiles(List<Profile> profiles) {
    profileList = profiles;
  }
}




class AddProfile extends ProfileEvent {
  Profile newProfile;

  AddProfile(Profile profile) {
    newProfile = profile;
  }
}




class DeleteProfile extends ProfileEvent {
  int profileIndex;

  DeleteProfile(int index) {
    profileIndex = index;
  }
}
