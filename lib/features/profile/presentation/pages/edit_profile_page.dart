import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jungle_memos/components/my_textfield.dart';
import 'package:jungle_memos/features/profile/domain/entities/profile_user.dart';
import 'package:jungle_memos/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:jungle_memos/features/profile/presentation/cubit/profile_states.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;
  
  const EditProfilePage(
    {
      super.key,
      required this.user,
    }
  );

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  final bioTextController = TextEditingController();

  // mobile image picker
  PlatformFile? imagePickedFile;
  
  // Pick Image Method
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

  void updateProfile() async {

    // profile cubit
    final profileCubit = context.read <ProfileCubit>();

    // prepare images
    // final String username = widget.user.username;
    final imageMobilePath = imagePickedFile?.path;

    // prepare bio
    final String? newBio = bioTextController.text;

    // Update profile button pressed
    if(imageMobilePath != null || newBio != null){
        profileCubit.updateProfile(widget.user.username, bioTextController.text, imageMobilePath);
    } else {
      Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(

      builder: (context, state){

        // profile loading..
        if(state is ProfileLoading){
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // profile error
        else {
          return buildEditPage();
        }

      }, 

      listener: (context, state){
        if(state is ProfileLoaded){
          Navigator.of(context).pop();
        }
      }

    );
  }

  Widget buildEditPage(){
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Edit Profile")),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () => updateProfile(), 
            icon: Icon(
              Icons.upload,
              color: Theme.of(context).colorScheme.primary,
            ),

          )
        ],
      ),

      body: Column(
        children: [

          // profile picture
          Center(
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.secondary,
              ),
              clipBehavior: Clip.hardEdge,
              child: 
                // Display selected mobile image
                
                // CHECK IF NULL
                (imagePickedFile != null) 

                  // IF TRUE
                  ? Container(
                      height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        
                      child: Image.file(
                        File(imagePickedFile!.path!),
                        fit: BoxFit.cover, 
                      ),
                    )

                  // IF FALSE
                  : CachedNetworkImage(
                      imageUrl: widget.user.profileImageUrl,

                      // loading.. 
                      placeholder: (context, url) => 
                        const CircularProgressIndicator(),

                      // Error, failed to load
                      errorWidget: (context, url, error) => 
                        Icon(Icons.person, size: 72, color: Theme.of(context).colorScheme.primary),

                      // loaded
                      imageBuilder:(context, imageProvider) => 
                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.secondary,
                            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                    ),               

            ),
          ),

          const SizedBox(height: 15),

          // Pick Image Button
          Center(
            child: MaterialButton(
              onPressed: pickImage,
              color: Colors.blue,
              child: Text("Pick Image", style: GoogleFonts.openSans()),
            )
          ),

          const SizedBox(height: 10),

          // BIO
          Center(
            child: Text(
              "Bio", 
              style: GoogleFonts.openSans(color: Theme.of(context).colorScheme.inversePrimary, fontSize: 18),
            ),
          ),

          const SizedBox(height: 10),

          MyTextField(
            controller: bioTextController, 
            hintText: "New Bio", 
            obscureText: false
          ),
                          
        ],

      ),
    );

  }
}