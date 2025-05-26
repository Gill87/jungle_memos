import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jungle_memos/features/main_posts/domain/entities/comment.dart';
import 'package:jungle_memos/features/main_posts/domain/entities/post.dart';
import 'package:jungle_memos/features/main_posts/domain/repos/post_repo.dart';

class FirebasePostRepo implements PostRepo{

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CollectionReference postsCollection = FirebaseFirestore.instance.collection('posts');

  @override
  Future<void> createPost(Post post) async {
    try {

      await postsCollection.doc(post.id).set(post.toJson());


    } catch(e){
      throw Exception("Error creating post: $e");
    }


  }

  @override
  Future<void> deletePost(String postId) async {
    await postsCollection.doc(postId).delete();
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {

      // Get all posts with most recent posts at the top
      final postsSnapshot = await postsCollection.orderBy('timestamp', descending: true).get();

      // Convert from json to list of posts
      final List <Post> allPosts = postsSnapshot.docs
        .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

      return allPosts;
    } catch(e){
      throw Exception("Error fetching posts: $e");
    }
  }

  @override
  Future<List<Post>> fetchAllPostsByUserId(String userId) async {
    try {
      
      // Get by user id
      final postsSnapshot = await postsCollection.where("userId", isEqualTo: userId).get();

      // Convert from json to list of posts
      final List <Post> userPosts = postsSnapshot.docs
        .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

      // Return
      return userPosts;

    } catch(e){
      throw Exception("Error fetching posts by user: $e");
    }
  }

  @override
  Future<void> toggleLikePosts(String postId, String userId) async {
    try{

      // Get Post Document
      final postDoc = await postsCollection.doc(postId).get();

      // Make sure post doc exists
      if(postDoc.exists){

        // Convert from json to post
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        // Check if user has already liked post
        final hasLiked = post.likes.contains(userId);

        // Update like list
        if(hasLiked){
          post.likes.remove(userId);
        } else {
          post.likes.add(userId);
        }

        // Update post document with new like list
        await postsCollection.doc(postId).update({
          'likes': post.likes,
        });

      } else {
        throw Exception("Post not found");
      }

    } catch(e){
      throw Exception("Error toggling like: $e");
    }
  }

  @override
  Future<void> addComment(String postId, Comment comment) async {
    try{

      // Get post document
      final postDoc = await postsCollection.doc(postId).get();

      // Check to make sure post exists
      if(postDoc.exists){

        // Convert json to post
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        // Add the new comment
        post.comments.add(comment);

        // Update in firestore
        await postsCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()).toList()
        });

      } else {
        throw Exception("Post not found");
      }

    } catch(e){
      throw Exception("Error adding comment: $e");
    }
  }

  @override
  Future<void> deleteComment(String postId, String commentId) async {
    try{
      // Get post document
      final postDoc = await postsCollection.doc(postId).get();

      // Check to make sure post exists
      if(postDoc.exists){

        // Convert json to post
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        // Delete comment
        post.comments.removeWhere((comment) => comment.commentId == commentId);

        // Update in firestore
        await postsCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()).toList()
        });
      } else {
        throw Exception("Post not found");
      }

    } catch(e){
      throw Exception("Error deleting comment: $e");
    }
  }
}


