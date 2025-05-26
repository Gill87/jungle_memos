/*

Profile Repository

*/

import 'package:jungle_memos/features/profile/domain/entities/profile_user.dart';

abstract class ProfileRepo {

  Future <ProfileUser?> fetchUserProfile(String username);
  Future <void> updateProfile(ProfileUser updatedProfile);
  Future <void> toggleFollow(String currentUid, String targetUid);
}