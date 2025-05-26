abstract class StorageRepo {

  // Upload profile pic on mobile
  Future <String?> uploadProfileImageMobile(String path, String fileName);

  Future <String?> uploadPostImageMobile(String path, String fileName);
}