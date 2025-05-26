import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jungle_memos/components/my_textfield.dart';
import 'package:jungle_memos/features/auth/domain/entities/app_user.dart';
import 'package:jungle_memos/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:jungle_memos/features/main_posts/domain/entities/post.dart';
import 'package:jungle_memos/features/main_posts/presentation/cubits/post_cubit.dart';
import 'package:jungle_memos/features/main_posts/presentation/cubits/post_states.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPage();
}

class _UploadPostPage extends State<UploadPostPage> {

  // Current User
  AppUser? currentUser;

  // Mobile Image Pick
  PlatformFile? imagePickedFile;

  // Text Controller for caption
  final textController = TextEditingController();


  @override
  void initState(){
    super.initState();

    getCurrentUser();
  }

  // Get Current User
  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  // Pick Image - Taken from EditProfilePage
  Future <void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if(result != null){
      setState(() {
        imagePickedFile = result.files.first;
      });
    }
  }

  // Create & Upload Post
  void uploadPost() {

    // Check both image and caption are provide,d
    if(imagePickedFile == null || textController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Both image and caption are required"))
      );
    return;
    }
 
    // Create a new post object
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUser!.username,
      userName: currentUser!.name,
      text: textController.text,
      imageUrl: '', // implemented seperately through image path: imagePickedFile?.path
      timestamp: DateTime.now(),
      likes: [],
      comments: [],
    );

    // Post Cubit
    final postCubit = context.read<PostCubit>();

    // mobile upload
    postCubit.createPost(newPost, imagePath: imagePickedFile?.path);

  }

  @override
  void dispose(){
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer <PostCubit, PostState> (
      builder: (context, state) {

        // loading or uploading
        if(state is PostLoading || state is PostUploading){
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // build upload page
        return buildUploadPage();
      }, 
      listener: (context, state) {
        if(state is PostLoaded){
          Navigator.pop(context);
        }
      }
    );

  }

  Widget buildUploadPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Post"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: uploadPost, 
            icon: const Icon(Icons.upload),
          ),


        ],
      ),

      body: Center(
        child: Column(
          children: [
            
            // image preview for mobile
            if(imagePickedFile != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: 400,
                    child: Image.file(
                      File(imagePickedFile!.path!),
                      fit: BoxFit.fitWidth
                    ),
                  ),
                ),
              
            const SizedBox(height: 2),

            // Pick Image Button
            MaterialButton(
              onPressed: pickImage, 
              color: Colors.blue,
              child: Text(
                "Pick Image",
                style: GoogleFonts.openSans(color: Theme.of(context).colorScheme.inversePrimary),
              ),
            ),

            const SizedBox(height: 10),

            // Caption Text Box
            MyTextField(
              controller: textController, 
              hintText: "Caption", 
              obscureText: false
            ),

            const SizedBox(height: 10),
            
          ],
        ),
      ),

    );
  }

}