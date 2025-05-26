import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jungle_memos/components/comment_tile.dart';
import 'package:jungle_memos/components/my_textfield.dart';
import 'package:jungle_memos/features/main_posts/domain/entities/post.dart';
import 'package:jungle_memos/features/main_posts/presentation/cubits/post_cubit.dart';
import 'package:jungle_memos/features/main_posts/presentation/cubits/post_states.dart';

class CommentBox extends StatefulWidget {
  final Post post;
  final TextEditingController commentTextController;
  final void Function() addComment;

  const CommentBox(
    {
      super.key,
      required this.commentTextController,
      required this.addComment,
      required this.post,
    }
  );

  @override
  State<CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          // Comment Section
          BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
              // Loaded
              if(state is PostLoaded){

                // final individual post
                final post = state.posts.firstWhere((post) => (post.id == widget.post.id));

                if(post.comments.isNotEmpty){

                  // how many commments to show
                  int showCommentCount = post.comments.length;

                  // build comment section
                  return ListView.builder(
                    itemCount: showCommentCount,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {

                      // get individual comment
                      final comment = post.comments[index];

                      // comment tile
                      return CommentTile(comment: comment);
                    }
                  );
                } else {
                  return const Center(child: Text("No comments yet"));
                }
              }

              // Loading
              if(state is PostLoading){
                return const Center(child: CircularProgressIndicator());
              }

              // Error
              else if(state is PostError){
                return Center(child: Text(state.message));
              }

              else {
                return const Center(
                  child: Text("Something went wrong..."),
                );
              }
            }
          ),

          // Add comment button
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          
              // Text Field to comment
              Expanded(
                child: MyTextField(
                  controller: widget.commentTextController, 
                  hintText: "Add comment", 
                  obscureText: false
                ),
              ),

              // Add Button
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 5),
                child: GestureDetector(
                  onTap: ()=> {
                    widget.addComment(),
                    Navigator.of(context).pop(),
                  },
                  child: const Icon(
                    Icons.add_comment_rounded
                  )
                ),
              ),
            ],
          ),
      
        ],
      ),
    ); 
  }
}