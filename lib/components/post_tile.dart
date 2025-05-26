import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jungle_memos/components/comment_box.dart';
import 'package:jungle_memos/features/auth/domain/entities/app_user.dart';
import 'package:jungle_memos/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:jungle_memos/features/main_posts/domain/entities/comment.dart';
import 'package:jungle_memos/features/main_posts/domain/entities/post.dart';
import 'package:jungle_memos/features/main_posts/presentation/cubits/post_cubit.dart';
import 'package:jungle_memos/features/profile/domain/entities/profile_user.dart';
import 'package:jungle_memos/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:jungle_memos/features/profile/presentation/pages/profile_page.dart';

class PostTile extends StatefulWidget {

  final Post post;
  final void Function()? onDeletePressed;

  const PostTile(
    {
      super.key,
      required this.post,
      required this.onDeletePressed,
    }
  );


  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {

  // cubits
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  bool isOwnPost = false;

  // current user
  AppUser? currentUser;

  // post user
  ProfileUser? postUser;

  // Text controller for comment
  TextEditingController commentTextController = TextEditingController();

  // Months
  List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

  // on startup
  @override
  void initState() {
    super.initState();

    getCurrentUser();
    fetchPostUser();
  }

  void getCurrentUser(){
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (currentUser!.username == widget.post.userId);
  }

  Future <void> fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId.toString());
    if(fetchedUser != null){
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

  // If user clicks like button
  void toggleLikePost(){

    // Current like status
    final isLiked = widget.post.likes.contains(currentUser!.username);


    // Optimistically like & update UI locally
    setState(() {
      if(isLiked){
        widget.post.likes.remove(currentUser!.username);
      } else {
        widget.post.likes.add(currentUser!.username);
      }  
    });

    // Update like
    postCubit.toggleLikePost(widget.post.id, currentUser!.username).catchError((error){
      // if error, revert back to original values
      if(isLiked){
        widget.post.likes.add(currentUser!.username);
      } else {
        widget.post.likes.remove(currentUser!.username);
      }  
    });

  }

  // Open new comment box for user to type comment
  void openNewCommentBox(){

    // Bottom Screen Pop-up
    showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      builder: (content) => 
        CommentBox(commentTextController: commentTextController, addComment: addComment, post: widget.post),
    );

  }
  
  // Add comment
  void addComment(){
    final newComment = Comment(
      commentId: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.post.id,
      userId: currentUser!.username,
      userName: currentUser!.name,
      text: commentTextController.text,
      timestamp: DateTime.now(),
    );

    // add comment using cubit
    if(commentTextController.text.isNotEmpty){
      postCubit.addComment(widget.post.id, newComment);
    }
  }

  // Confirm delete post
  void showOptionsForDeletion(){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text("Delete Post?"),
        actions: [

          // Cancel Button
          TextButton(
            onPressed: () => Navigator.of(context).pop(), 
            child: const Text("Cancel"),
          ),

          // Delete Button
          TextButton(
            onPressed: () => {
              widget.onDeletePressed!(),
              Navigator.of(context).pop(),
            },
            child: const Text("Delete"),
          ), 
        ],

      ),
    );
  }

  // Dispose
  @override
  void dispose() {
    commentTextController.dispose();
    super.dispose();
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [

          // Top Row of Tile
          GestureDetector(
            onTap: () => Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => ProfilePage(
                  username: widget.post.userId,
                )
              )
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
              
                  // profile pic
                  postUser?.profileImageUrl != null 
                  ? CachedNetworkImage(
                      imageUrl: postUser!.profileImageUrl,
                      errorWidget: (context, url, error) => const Icon(Icons.person),
                      imageBuilder:(context, imageProvider) => Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover, 
                          )
                        ),
                      ),
                    )
                  : const Icon(Icons.person),
              
                  const SizedBox(width: 10),
                  
                  // Name
                  Text(
                    widget.post.userName,
                    style: GoogleFonts.openSans(fontSize: 16, color: Theme.of(context).colorScheme.inversePrimary),
                  ),
              
                  const Spacer(),
              
                  // Delete button
                  if(isOwnPost)
                    GestureDetector(
                      onTap: showOptionsForDeletion,
                      child: const Icon(Icons.delete),
                    )
              
                ],
              ),
            ),
          ),
      
          // Main Image
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 430,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const SizedBox(height: 430),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          
          // Caption
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),

            child: Row(
              children: [
                Text(
                  widget.post.userName,
                  style: GoogleFonts.openSans(fontSize: 18, color: Theme.of(context).colorScheme.inversePrimary, fontWeight: FontWeight.bold),
            
                ),
            
                const SizedBox(width: 10),
                
                Text(
                  widget.post.text,
                  style: GoogleFonts.openSans(fontSize: 18, color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ],
            ),
          ),

          // Bottom Buttons
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [

                // Like Button
                GestureDetector(
                  onTap: toggleLikePost,
                  child: Icon(
                    widget.post.likes.contains(currentUser!.username) 
                      ? Icons.favorite
                      : Icons.favorite_border, color: Colors.red,
                  )
                ),

                const SizedBox(width: 5),

                // Like Count
                Text(
                  widget.post.likes.length.toString(),
                  style: GoogleFonts.openSans(fontSize: 14),
                ),
            
                const SizedBox(width: 30,),

                // Comment
                GestureDetector(
                  onTap: openNewCommentBox,
                  child: const Icon(Icons.comment)
                ),


                const SizedBox(width: 5),

                // Comment Count
                Text(widget.post.comments.length.toString()),
            
                const Spacer(),
            
                // Timestamp
                Text(
                  "${widget.post.timestamp.day} ${months[widget.post.timestamp.month - 1]} ${widget.post.timestamp.year}",
                  style: GoogleFonts.openSans(fontSize: 14, color: Theme.of(context).colorScheme.inversePrimary, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}