import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jungle_memos/features/main_posts/domain/entities/comment.dart';
import 'package:jungle_memos/features/main_posts/domain/entities/post.dart';
import 'package:jungle_memos/features/main_posts/domain/repos/post_repo.dart';
import 'package:jungle_memos/features/main_posts/presentation/cubits/post_states.dart';
import 'package:jungle_memos/features/storage/domain/storage_repo.dart';

class PostCubit extends Cubit <PostState> {

  final PostRepo postRepo;
  final StorageRepo storageRepo;

  PostCubit(
    {
      required this.postRepo,
      required this.storageRepo
  }) : super(PostInitial());

  // Create a new post
  Future <void> createPost(Post post, 
    {String? imagePath}) async {

      try {
        String? imageUrl;

        // Handle image upload for mobile platforms
        if(imagePath != null){
          emit(PostUploading());
          imageUrl = await storageRepo.uploadPostImageMobile(imagePath, post.id);
        } 

        // Give image url to post
        final newPost = post.copyWith(imageUrl: imageUrl);

        // create post in the backend
        postRepo.createPost(newPost);

        // Re-fetch all posts
        fetchAllPosts();

      } catch(e){
        emit(PostError("Failed to create post: $e"));
      }

  }

  // Fetch all posts
  Future <void> fetchAllPosts() async {
    try {

      emit(PostLoading());

      final posts = await postRepo.fetchAllPosts();

      emit(PostLoaded(posts));

    } catch(e){
      emit(PostError("Failed to fetch posts $e"));
    }
  }

  // Fetch posts by user id
  Future <void> fetchAllPostsByUserId(String userId) async {
    try {

      emit(PostLoading());

      final posts = await postRepo.fetchAllPostsByUserId(userId);

      emit(PostLoaded(posts));

    } catch(e){
      emit(PostError("Failed to fetch posts $e"));
    }
  }

  // Get post count
  Future <int> getNumberOfPostsByUserId(String userId) async {
    try {
      final posts = await postRepo.fetchAllPostsByUserId(userId);
      int count = posts.length;
      return count;
    } catch(e){
      throw Exception("Could not get post count: $e");
    }
  }


  // Delete post
  Future <void> deletePost(String postId) async {
    try {

      await postRepo.deletePost(postId);

    } catch(e){
      throw Exception("Could not delete post: $e");
    }

  }

  // toggle like on a post
  Future <void> toggleLikePost(String postId, String userId) async {
    try{
      await postRepo.toggleLikePosts(postId, userId);
    } catch(e){
      emit(PostError("Failed to toggle like: $e"));
    }
  }

  Future <void> addComment(String postId, Comment comment) async {
    try{
      await postRepo.addComment(postId, comment);
      fetchAllPosts();

    } catch(e){
      emit(PostError("Failed to add comment: $e"));
    }
  }

  Future <void> deleteComment(String postId, String commentId) async {
    try{

      await postRepo.deleteComment(postId, commentId);
      await fetchAllPosts();

    } catch(e){
      emit(PostError("Failed to delete comment: $e"));
    }
  }

}