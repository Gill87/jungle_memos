import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jungle_memos/features/drawer/presentation/pages/my_drawer.dart';
import 'package:jungle_memos/components/post_tile.dart';
import 'package:jungle_memos/features/main_posts/presentation/cubits/post_cubit.dart';
import 'package:jungle_memos/features/main_posts/presentation/cubits/post_states.dart';
import 'package:jungle_memos/features/main_posts/presentation/pages/upload_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // post cubit
  late final postCubit = context.read<PostCubit>();

  // on startup
  @override
  void initState() {
    super.initState();

    fetchAllPosts();
  }

  void fetchAllPosts(){
    postCubit.fetchAllPosts();
  }

  void deletePost(String postId){
    postCubit.deletePost(postId);
    fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      // App Bar
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Home",
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () => {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const UploadPostPage()))
          },),
        ],
      ),

      drawer: const MyDrawer(),

      // BODY
      body: BlocBuilder<PostCubit, PostState> (
        builder: (context, state){

          // loading..
          if(state is PostLoading || state is PostUploading){
            return const Center(child: CircularProgressIndicator());
          }

          // loaded
          else if(state is PostLoaded){

            // Get list of all posts
            final allPosts = state.posts;

            // If list is empty
            if(allPosts.isEmpty){
              return const Center(
                child: Text("No posts available")
              );
            }

            // If not empty
            return ListView.builder(
              itemCount: allPosts.length,
              itemBuilder: (context, index){

                // Get individual post
                final post = allPosts[index];

                // Display post tile
                return PostTile(
                  post: post, 
                  onDeletePressed: () => deletePost(post.id),
                );
              }
            ); 
          }
          
          // error
          else if(state is PostError){
            return Center(
              child: Text(state.message)
            );
          } else {
            return const SizedBox();
          }
        }

      ),
    );
  }
}