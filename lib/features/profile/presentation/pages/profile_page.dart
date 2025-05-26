import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jungle_memos/components/bio_box.dart';
import 'package:jungle_memos/components/follow_button.dart';
import 'package:jungle_memos/features/drawer/presentation/pages/my_drawer.dart';
import 'package:jungle_memos/components/post_tile.dart';
import 'package:jungle_memos/components/profile_stats.dart';
import 'package:jungle_memos/features/auth/domain/entities/app_user.dart';
import 'package:jungle_memos/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:jungle_memos/features/main_posts/presentation/cubits/post_cubit.dart';
import 'package:jungle_memos/features/main_posts/presentation/cubits/post_states.dart';
import 'package:jungle_memos/features/posts/presentation/pages/home_page.dart';
import 'package:jungle_memos/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:jungle_memos/features/profile/presentation/cubit/profile_states.dart';
import 'package:jungle_memos/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:jungle_memos/features/profile/presentation/pages/follower_page.dart';

class ProfilePage extends StatefulWidget {

  final String username;
  
  const ProfilePage({super.key, required this.username});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  // cubit
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();
  late final postCubit = context.read<PostCubit>();

  // current user
  late AppUser? currentUser = authCubit.currentUser;
  
  // posts
  int postCount = 0;

  void followButtonPressed(){
    final profileState = profileCubit.state;

    // If not loaded
    if(profileState is! ProfileLoaded){
      return;
    }

    // Loaded
    final profileUser = profileState.profileUser;
    final isFollowing = profileUser.followers.contains(currentUser!.username);

    // optimistically update UI
    setState(() {
      
      // unfollow
      if(isFollowing){
        profileUser.followers.remove(currentUser!.username);
      }

      // follow
      else {
        profileUser.followers.add(currentUser!.username);
      }
    });
    
    // perform actual toggle in cubit
    profileCubit.toggleFollow(currentUser!.username, widget.username).catchError((error){
      
      // revert update if error
      setState(() {
        
        // unfollow revert
        if(isFollowing){
          profileUser.followers.add(currentUser!.username);
        }

        // follow revert
        else {
          profileUser.followers.remove(currentUser!.username);
        }
      });

    });


  }

  // on startup
  @override
  void initState() {
    super.initState();

    // fetch user
    profileCubit.fetchUserProfile(widget.username);

    // set post count
    setPostCount();
  }

  void setPostCount() async {
    postCount = await postCubit.getNumberOfPostsByUserId(widget.username);
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {

    bool isOwnProfile = (widget.username == currentUser!.username);

    return BlocBuilder<ProfileCubit, ProfileState>(

      builder: (context, state) {

        // loaded
        if(state is ProfileLoaded){

          //  Get loaded user
          final user = state.profileUser;

          return Scaffold(

            // APP BAR
            appBar: AppBar(
              title: Center(
                child: Text(
                  user.name, 
                  style: GoogleFonts.openSans(color: Theme.of(context).colorScheme.inversePrimary)
                )
              ),

              foregroundColor: Theme.of(context).colorScheme.primary,
              actions: [

                // Show Edit button
                if(isOwnProfile)
                  IconButton(
                    icon: Icon(
                      Icons.edit, 
                      color: Theme.of(context).colorScheme.primary,
                      ),

                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfilePage(user: user),
                      ),
                    ),
                  )

                // Show Home Button
                else
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder:(context) => const HomePage()),
                    ),
                    icon: const Icon(Icons.home),
                  ),
              ],
            ),

            // BODY
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // Email 
                  Center(
                    child: Text(
                      user.email,
                      style: GoogleFonts.openSans(),
              
                    ),
                  ),
              
                  const SizedBox(height: 20),
              
                  // Profile pic
                  CachedNetworkImage(
                    imageUrl: user.profileImageUrl,
                  
                    // loading.. 
                    placeholder: (context, url) => 
                      const CircularProgressIndicator(),
                  
                    // Error, failed to load
                    errorWidget: (context, url, error) => 
                      Icon(Icons.person, size: 72, color: Theme.of(context).colorScheme.primary),
                  
                    // loaded
                    imageBuilder:(context, imageProvider) => 
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.secondary,
                          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                  ),
              
                  const SizedBox(height: 10),
              
                  // Profile stats
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ProfileStats(
                      postCount: postCount, 
                      followerCount: user.followers.length, 
                      followingCount: user.following.length,
                      onTap:() => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:(context) => FollowerPage(
                            followers: user.followers, 
                            following: user.following,
                          ),
                        )
                      ),
                    ),
                  ),
              
                  // Follow/Unfollow button
                  if (!isOwnProfile)
                    FollowButton(
                      onPressed: ()=> followButtonPressed(), 
                      isFollowing: user.followers.contains(currentUser!.username),
                    ),
              
                  const SizedBox(height: 10),
              
                  // Bio Box
                  Center(
                    child: Text(
                      "Bio", 
                      style: GoogleFonts.openSans(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  
                  const SizedBox(height: 10),
              
                  BioBox(text: user.bio),
              
                  const SizedBox(height: 10),
              
                  // Posts
                  Center(
                    child: Text(
                      "Posts", 
                      style: GoogleFonts.openSans(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  
                  const SizedBox(height: 10),
              
                 BlocBuilder<PostCubit, PostState>(
                    builder: (context, state) {
              
                      // post loaded
                      if(state is PostLoaded){
                        // filter by user id
                        final userPosts = state.posts.where(
                          (post) => (post.userId == widget.username))
                          .toList();
              
                        // Update count
                        postCount = userPosts.length;
                        
                        // If zero posts
                        if(postCount == 0){
                          return SizedBox(
                            height: 300,
                            child: Center(
                              child: Text(
                                "No posts yet",
                                style: GoogleFonts.openSans(color: Theme.of(context).colorScheme.primary, fontSize: 16),
                              )
                            ),
                          );
                        } 
                        
                        // if more than zero posts
                        else {
                          // Display
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: postCount,
                            itemBuilder: (context, index){
                              // individual post
                              final post = userPosts[index];
                
                              // return as post tile UI
                              return PostTile(
                                post: post, 
                                onDeletePressed: ()=> context.read<PostCubit>().deletePost(post.id),
                              );
                
                            }
                          );
                        }
                      }
              
                      else if(state is PostLoading){
                        return const Center(child: CircularProgressIndicator());
                      }
                      else {
                        return Center(
                          child: Text("No posts", style: GoogleFonts.openSans()),
                        );
                      }
                    
                    }
                  )
                ],
              ),
            ),

            drawer: const MyDrawer(),
          );        
        }

        // Loading...
        else if(state is ProfileLoading){
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } 

        else {
          return const Center(child: Text("No profile found"));
        }
      }
    );

  }
}