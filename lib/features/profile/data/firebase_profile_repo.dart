import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jungle_memos/features/profile/domain/entities/profile_user.dart';
import 'package:jungle_memos/features/profile/domain/repo/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo{

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<ProfileUser?> fetchUserProfile(String username) async {
    try {
      
      // Get User document from firestore
      final userDoc = await firebaseFirestore.collection("users").doc(username).get();

      // Check if exits
      if(userDoc.exists){
        final userData = userDoc.data();

        if(userData != null){
          final followers = List<String>.from(userData["followers"] ?? []);
          final following = List<String>.from(userData["following"] ?? []);

          return ProfileUser(
            username: username, 
            email: userData["email"], 
            name: userData["name"], 
            bio: userData["bio"] ?? '', 
            profileImageUrl: userData["profileImageUrl"].toString(),
            followers: followers,
            following: following,
          );
        }
      } 

      // If not then return null
      return null;

    } catch(e){
      return null;
    }
  }

  @override
  Future<void> updateProfile(ProfileUser updatedProfile) async {
    try {
      // Convert updated profile to json so we can store in firebase
      await firebaseFirestore.collection("users").doc(updatedProfile.username).update(
        {
          'bio': updatedProfile.bio,
          'profileImageUrl': updatedProfile.profileImageUrl,
        }
      );

    } catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<void> toggleFollow(String currentUid, String targetUid) async {

    try {

      // Get user docs
      final currentUserDoc = await firebaseFirestore.collection("users").doc(currentUid).get();
      final targetUserDoc = await firebaseFirestore.collection("users").doc(targetUid).get();

      if(currentUserDoc.exists && targetUserDoc.exists){
        final currentUserData = currentUserDoc.data();
        final targetUserData = targetUserDoc.data();

        if(currentUserData != null && targetUserData != null){
          final List<String> currentFollowing = List<String>.from(currentUserData["following"] ?? []);
          
          // check if current user is already following the target user
          if(currentFollowing.contains(targetUid)) {

            // unfollow by removing targetUid from current user's following list
            await firebaseFirestore.collection("users").doc(currentUid).update(
              {
                'following': FieldValue.arrayRemove([targetUid])
              }
            );
            
            // unfollow by removing currentUser from target user's followers list
            await firebaseFirestore.collection("users").doc(targetUid).update(
              {
                'followers': FieldValue.arrayRemove([currentUid])
              }
            );

          } else {

            // follow by adding target Uid to current user's following list
            await firebaseFirestore.collection("users").doc(currentUid).update(
              {
                'following': FieldValue.arrayUnion([targetUid])
              }
            );

            // follow by adding current Uid to target user's followers list
            await firebaseFirestore.collection("users").doc(targetUid).update(
              {
                'followers': FieldValue.arrayUnion([currentUid])
              }
            );

          }
        }
      }

    } catch(e){
      throw Exception("Could not follow/unfollow");
    }   
  }
}