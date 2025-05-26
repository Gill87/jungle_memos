import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jungle_memos/features/drawer/domain/drawer_repo.dart';

class FirebaseDrawerRepo implements DrawerRepo{
  
  @override
  Future<String?> getProfilePicture(String uid) async {
  // Firestore
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    try{
      // Get User Doc from Firestore
      final userDoc = await firebaseFirestore.collection("users").doc(uid).get();

      // Check if it exists
      if(userDoc.exists){

        // Get User Data
        final userData = userDoc.data();

        if(userData != null){

          // Get Profile Image Url in a String
          final profileImageUrl = userData["profileImageUrl"].toString();

          // Return
          if(profileImageUrl.isNotEmpty){
            return profileImageUrl;
          } else {
            return "";
          }
        }
      } 

      return "";

    } catch(e){
      throw Exception("Error getting profile picture url: $e");
    }
  }
}