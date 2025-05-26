import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jungle_memos/features/auth/domain/entities/app_user.dart';
import 'package:jungle_memos/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:jungle_memos/features/main_posts/domain/entities/comment.dart';
import 'package:jungle_memos/features/main_posts/presentation/cubits/post_cubit.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;

  const CommentTile({super.key, required this.comment});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {

  // current user
  AppUser? currentUser;
  bool isOwnPost = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser(){
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.comment.userId == currentUser!.username);
  }

  void showOptionsForDeletingComment(){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text("Delete Comment?"),
        actions: [

          // Cancel Button
          TextButton(
            onPressed: () => Navigator.of(context).pop(), 
            child: const Text("Cancel"),
          ),

          // Delete Button
          TextButton(
            onPressed: () => {
              context.read<PostCubit>().deleteComment(widget.comment.postId, widget.comment.commentId),
              Navigator.of(context).pop(),
            },
            child: const Text("Delete"),
          ), 
        ],

      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(width: 2, color: Theme.of(context).colorScheme.secondary),
          )
        ),
        child: Row(
          children: [

            // Name of user
            Text(
              widget.comment.userName,
              style: GoogleFonts.openSans(color: Theme.of(context).colorScheme.inversePrimary, fontWeight: FontWeight.bold, fontSize: 14),
            ),
        
            const SizedBox(width: 10),

            // Comment Text
            Text(
              widget.comment.text,
              style: GoogleFonts.openSans(color: Theme.of(context).colorScheme.inversePrimary, fontSize: 14),
            ),

            const Spacer(),

            // Delete Button
            if(isOwnPost)
              GestureDetector(
                onTap: showOptionsForDeletingComment,
                child: const Icon(Icons.more_horiz_rounded),
              ),
          ],
        ),
      ),
    );
  }
}