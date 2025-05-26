import 'package:jungle_memos/features/main_posts/domain/entities/comment.dart';
import 'package:jungle_memos/features/main_posts/domain/entities/post.dart';

abstract class PostRepo {

  Future <List<Post>> fetchAllPosts();
  Future <void> createPost(Post post);
  Future <void> deletePost(String postId);
  Future <List<Post>> fetchAllPostsByUserId(String userId);
  Future <void> toggleLikePosts(String postId, String userId);
  Future <void> addComment(String postId, Comment comment);
  Future <void> deleteComment(String postId, String commentId);

}