import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:jungle_memos/features/storage/domain/storage_repo.dart';

class FirebaseStorageRepo implements StorageRepo{

  final FirebaseStorage storage = FirebaseStorage.instance;
  
  // PROFILE
  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "profile_images");
  }

  // POSTS
  @override
  Future<String?> uploadPostImageMobile(String path, String fileName) {
        return _uploadFile(path, fileName, "post_images");

  }

  /*

    Helper Method - to upload files to storage

  */

  // Mobile platforms (files)
  Future <String?> _uploadFile(String path, String fileName, String folder) async {
    try {

      // Get file
      final file = File(path);

      // find place to store
      final storageRef = storage.ref().child('$folder/$fileName');

      // Upload
      final uploadTask = await storageRef.putFile(file);

      // Get image download url
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      // Return
      return downloadUrl;

    } catch(e){
      return null;
    }
  }


}