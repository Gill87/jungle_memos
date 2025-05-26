
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jungle_memos/features/auth/data/firebase_auth_repo.dart';
import 'package:jungle_memos/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:jungle_memos/features/auth/presentation/cubits/auth_states.dart';
import 'package:jungle_memos/features/auth/presentation/pages/auth_page.dart';
import 'package:jungle_memos/features/drawer/data/firebase_drawer_repo.dart';
import 'package:jungle_memos/features/drawer/presentation/cubits/drawer_cubit.dart';
import 'package:jungle_memos/features/main_posts/data/firebase_post_repo.dart';
import 'package:jungle_memos/features/main_posts/presentation/cubits/post_cubit.dart';
import 'package:jungle_memos/features/posts/presentation/pages/home_page.dart';
import 'package:jungle_memos/features/profile/data/firebase_profile_repo.dart';
import 'package:jungle_memos/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:jungle_memos/features/search/data/firebase_search_repo.dart';
import 'package:jungle_memos/features/search/presentation/cubits/search_cubit.dart';
import 'package:jungle_memos/features/storage/data/firebase_storage_repo.dart';
import 'package:jungle_memos/themes/theme_cubit.dart';

/*

APP - ROOT LEVEL

Repositories: for the database
  - firebase

Bloc providers: for state manegement
  - auth
  - profile
  - post
  - search
  - theme

Check Auth State
  - unauthenticated -> auth page
  - authenticated -> home page
*/


class MyApp extends StatelessWidget {

  final firebaseAuthRepo = FirebaseAuthRepo();
  final firebaseProfileRepo = FirebaseProfileRepo();
  final firebaseStorageRepo = FirebaseStorageRepo();
  final firebasePostRepo = FirebasePostRepo();
  final firebaseSearchRepo = FirebaseSearchRepo();
  final firebaseDrawerRepo = FirebaseDrawerRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Auth cubit
        BlocProvider<AuthCubit> (create: (context) => AuthCubit(authRepo: firebaseAuthRepo)..checkAuth()),

        // Profile cubit
        BlocProvider<ProfileCubit> (create: (context) => ProfileCubit(profileRepo: firebaseProfileRepo, storageRepo: firebaseStorageRepo)),

        // Post Cubit
        BlocProvider<PostCubit> (create: (context) => PostCubit(postRepo: firebasePostRepo, storageRepo: firebaseStorageRepo)),

        // Search Cubit
        BlocProvider<SearchCubit> (create: (context) => SearchCubit(searchRepo: firebaseSearchRepo)),

        // Theme Cubit
        BlocProvider<ThemeCubit> (create: (context) => ThemeCubit()),

        // Drawer Cubit
        BlocProvider(create: (context) => DrawerCubit(drawerRepo: firebaseDrawerRepo)),
      ], 

      // Theme Cubit, find current theme
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder:(context, currentTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: currentTheme,

        // Check Auth States, find page to send user to
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, authState) {
            print("Current state in BlocConsumer: $authState");

            // Unauthenticated
            if(authState is Unauthenticated){
              return const AuthPage();          
            } 

            // Authenticated
            if(authState is Authenticated){
              return const HomePage();
            }

            // Loading
            else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }, 
          listener: (context, authState) {
            if(authState is AuthError){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authState.message)));
            }

          },
        )),
      )
    );
  }
}
