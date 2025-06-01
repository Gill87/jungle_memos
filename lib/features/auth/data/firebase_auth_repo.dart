import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jungle_memos/features/auth/domain/entities/app_user.dart';
import 'package:jungle_memos/features/auth/domain/repos/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo{

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      // Attempt Sign in
      UserCredential userCred = await firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );

     print("login in repo");

      // Fetch user document from firestore
      DocumentSnapshot userDoc = await firebaseFirestore.collection("users").doc(userCred.user!.uid).get();

      // Record User
      AppUser user = AppUser(
        username: userCred.user!.uid, 
        email: email, 
        name: userDoc['name'],
      );

      // Return user
      return user;

    } catch(e) {
      throw Exception("Login failed: $e");
    }
  }

  @override
  Future<AppUser?> registerWithEmailPassword(String name, String email, String password) async {

    try {
      // Register
      UserCredential userCred = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
      );

      // Create User
      AppUser user = AppUser(
        username: userCred.user!.uid, 
        email: email, 
        name: name,
      );

      // Save User to Cloud Firestore
      await firebaseFirestore.
      collection("users").
      doc(user.username).   // username was meant to be uid
      set(user.toJson());

      // Return user
      return user;

    } catch(e) {
      throw Exception("Register Failed: $e");
    }
  }

  @override
  Future<void> logout() async {
    try {
     await firebaseAuth.signOut();
     print("logout in repo");
    } catch(e){
      print("logout failed: $e");
      throw Exception("Logout unsuccessfull: $e");
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    // Get Person Currently Logged In
    final firebaseUser = firebaseAuth.currentUser;

    // check null
    if(firebaseUser == null){
      return null;
    } 

    // Fetch user document from firestore
    DocumentSnapshot userDoc = await firebaseFirestore.collection('users').doc(firebaseUser.uid).get();
    
    if (!userDoc.exists) {
      print("No such user document for uid");
      return null;  // Or handle however you want
    }

    return AppUser(
      username: firebaseUser.uid, 
      email: firebaseUser.email!, 
      name: userDoc['name'],
    );

  }
  
}