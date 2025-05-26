class AppUser {
  final String username;
  final String email;
  final String name; 

  AppUser({
    required this.username,
    required this.email,
    required this.name,
  });

  // Converting app user to json
  Map <String, dynamic> toJson(){
    return {
      "username": username,
      "email": email,
      "name": name,
    };
  }
  // convert json to app user
  factory AppUser.fromJson(Map<String, dynamic> jsonUser){
    return AppUser(
      username: jsonUser["username"],
      email: jsonUser["email"],
      name: jsonUser["name"],
      
    );
  }

}