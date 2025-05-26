/*

PROFILE CUBIT

*/

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jungle_memos/features/profile/domain/entities/profile_user.dart';
import 'package:jungle_memos/features/profile/domain/repo/profile_repo.dart';
import 'package:jungle_memos/features/profile/presentation/cubit/profile_states.dart';
import 'package:jungle_memos/features/storage/domain/storage_repo.dart';

class ProfileCubit extends Cubit <ProfileState>{

  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;

  ProfileCubit(
    {
      required this.profileRepo,
      required this.storageRepo,

    }
  ) : super(ProfileInitial());

  // Fetch User profile using repo -> useful for a single profile page
  Future <void> fetchUserProfile(String username) async {

    try {

      // Loading state 
      emit(ProfileLoading());

      final user = await profileRepo.fetchUserProfile(username);

      if(user != null){
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError("User not found"));
      }

    } catch(e){
      emit(ProfileError("User not found"));
    }
  }

  // return user profile given uid -> useful for loading many profiles
  Future <ProfileUser?> getUserProfile(String uid) async {
    final user = await profileRepo.fetchUserProfile(uid);
    return user;
  }

  // Update bio and/or profile picture
  Future <void> updateProfile(String username, String? newBio, String? imageMobilePath) async {
    emit(ProfileLoading());

    try{

      // Fetch Current User
      final currentUser = await profileRepo.fetchUserProfile(username);

      if(currentUser == null){
        emit(ProfileError("Failed to fetch user for profile update"));
        return;
      }

      // Profile Picture Update
      String? imageDownloadUrl;

      if(imageMobilePath != null){
        imageDownloadUrl = await storageRepo.uploadProfileImageMobile(imageMobilePath, username);
      } else {
        emit(ProfileError("Failed to upload image"));
      }

      // Update Bio
      final updatedProfile = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
        newProfileImageUrl: imageDownloadUrl ?? currentUser.profileImageUrl,
      );

      // Update in Repo
      await profileRepo.updateProfile(updatedProfile);

      // Re-Fetch the updated profile
      await fetchUserProfile(username);

    } catch(e){
      emit(ProfileError("Error updating profile: $e"));
    }
  }

  // Toggle follow/unfollow
  Future <void> toggleFollow(String currentUserId, String targetUserId) async {
    try {
      await profileRepo.toggleFollow(currentUserId, targetUserId);

    } catch(e){
      emit(ProfileError("Error toggling follow: $e"));
    }
  }

}