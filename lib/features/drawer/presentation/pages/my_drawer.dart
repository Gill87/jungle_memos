import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jungle_memos/components/drawer_tile.dart';
import 'package:jungle_memos/features/auth/domain/entities/app_user.dart';
import 'package:jungle_memos/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:jungle_memos/features/drawer/presentation/cubits/drawer_cubit.dart';
import 'package:jungle_memos/features/drawer/presentation/cubits/drawer_state.dart';
import 'package:jungle_memos/features/main_posts/presentation/pages/upload_post_page.dart';
import 'package:jungle_memos/features/posts/presentation/pages/home_page.dart';
import 'package:jungle_memos/features/profile/presentation/pages/profile_page.dart';
import 'package:jungle_memos/features/search/presentation/pages/search_page.dart';
import 'package:jungle_memos/features/settings/pages/settings_page.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  // Cubits
  late final authCubit = context.read<AuthCubit>();
  late final drawerCubit = context.read<DrawerCubit>();

  // current user
  late AppUser? currentUser = authCubit.currentUser;

  // Variable
  String profileImageUrl = "";  
  bool hasProfilePicture = false;

  @override
  void initState() {
    setState(() {
      getProfilePic();
    });
    super.initState();
  }

  void logout() async {
    await context.read<AuthCubit>().logout();         
  }

  void getProfilePic() async {

    // Fetch picture
    await drawerCubit.fetchProfilePictureUrl(currentUser!.username);

    // Get State
    final state = drawerCubit.state;

    // Get url
    if(state is DrawerLoaded){
      profileImageUrl = state.profileImageUrl;
      if(profileImageUrl != ""){
        hasProfilePicture = true;
      }
    } 
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder <DrawerCubit, DrawerState> (
      builder:(context, state) {
        
        // Initial or Loading
        if(state is DrawerInitial || state is DrawerLoading){
          return const Center(child: CircularProgressIndicator());
        }

        // Drawer Loaded
        if(state is DrawerLoaded){
          return Drawer(
            child: SafeArea(
              child: Column(
                children: [
              
                  const SizedBox(height: 30),

                  // Logo Profile
                  hasProfilePicture
                  ? GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(username: currentUser!.username))),
                    child: CachedNetworkImage(
                        imageUrl: profileImageUrl,
                        imageBuilder: (context, imageProvider) => Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.secondary,
                            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                  )
                  : Icon(
                      Icons.person,
                      size: 100,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  
                  const SizedBox(height: 10),

                  // Divider
                  Divider(height: 10, thickness: 2, color: Theme.of(context).colorScheme.primary),

                  // Home
                  DrawerTile(
                    title: "H O M E", 
                    icon: Icons.home, 
                    onTap: () => {
                      Navigator.of(context).pop(),
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      )
                    }
                  ),

                  // Profile
                  DrawerTile(
                    title: "P R O F I L E", 
                    icon: Icons.person, 
                    onTap: () {
                      // Pop menu drawer
                      Navigator.of(context).pop();

                      // Get current user id
                      final user = context.read<AuthCubit>().currentUser;
                      String? username = user!.username;

                      // Navigate to profile page
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(username: username)));
                    },
                  ),
              
                  // Search
                  DrawerTile(
                    title: "S E A R C H", 
                    icon: Icons.search, 
                    onTap: () => {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage())),
                    },
                  ),
              
              
                  // Post Button
                  DrawerTile(
                    title: "P O S T", 
                    icon: Icons.post_add, 
                    onTap: () => {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const UploadPostPage()))
                    },
                  ),
              
                  // Settings
                  DrawerTile(
                    title: "S E T T I N G S", 
                    icon: Icons.settings, 
                    onTap: () => {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage())),
                    },
                  ),
              
                  const Spacer(),

                    // Logout tile
                  DrawerTile(
                    title: "L O G O U T", 
                    icon: Icons.logout, 
                    onTap: () => {
                      Navigator.of(context).pop(),
                      logout(),
                      // Navigator.pushReplacement(
                        // context,
                        // MaterialPageRoute(builder: (context) => const HomePage()),
                      // ),
                    }
                  ),
                ],
              )
            )
          
          );
        }

        // Error
        return const Center(child: Text("Can't load drawer"));
      },
    );
  }
}