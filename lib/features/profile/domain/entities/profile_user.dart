import 'package:jungle_memos/features/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser {
  final String bio; 
  final String profileImageUrl;
  final List<String> followers;
  final List<String> following;

  ProfileUser(
    {
      required super.username,
      required super.email,
      required super.name,
      required this.bio,
      required this.profileImageUrl,
      required this.followers,
      required this.following,
    }
  );

  // Method to update profile user
  ProfileUser copyWith({
      String? newBio, 
      String? newProfileImageUrl,
      List <String>? newFollowers,
      List <String>? newFollowing,
    }){

    return ProfileUser(
      username: username, 
      email: email, 
      name: name, 
      bio: newBio ?? bio, 
      profileImageUrl: newProfileImageUrl ?? profileImageUrl,
      followers: newFollowers ?? followers,
      following: newFollowing ?? following,
    );
  }

  // Convert profile user to json
  @override
  Map<String, dynamic> toJson(){
    return {
      "username": username,
      "email": email,
      "name": name, 
      "bio": bio,
      "profileImageUrl": profileImageUrl,
      "followers": followers,
      "following": following
    };
  }

  factory ProfileUser.fromJson(Map<String, dynamic> json){
    return ProfileUser(
      username: json["username"], 
      email: json["email"], 
      name: json["name"], 
      bio: json["bio"] ?? "Empty Bio", 
      profileImageUrl: json["profileImageUrl"] ?? '',
      followers: List<String>.from(json["followers"] ?? []),
      following: List<String>.from(json["following"] ?? []),
    );
  }

}