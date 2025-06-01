import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jungle_memos/features/profile/domain/entities/profile_user.dart';
import 'package:jungle_memos/features/search/domain/search_repo.dart';

class FirebaseSearchRepo implements SearchRepo {
  @override
  Future<List<ProfileUser?>> searchUsers(String query) async {
    try {
      final result = await FirebaseFirestore.instance.collection("users").get();

      // Convert query to lowercase
      final lowerQuery = query.toLowerCase();

      return result.docs
          .map((doc) => ProfileUser.fromJson(doc.data()))
          .where((user) => user.name.toLowerCase().contains(lowerQuery))
          .toList();
    } catch (e) {
      throw Exception("Error searching users: $e");
    }
  }
}