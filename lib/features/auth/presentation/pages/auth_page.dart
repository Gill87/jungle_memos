/*

Auth Page - Determine whether to show the login or register page

*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jungle_memos/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:jungle_memos/features/auth/presentation/cubits/auth_states.dart';
import 'package:jungle_memos/features/auth/presentation/pages/login_page.dart';
import 'package:jungle_memos/features/auth/presentation/pages/register_page.dart';
import 'package:jungle_memos/features/posts/presentation/pages/home_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomePage()),
            (route) => false,
          );
        }
      },
      child: showLoginPage
          ? LoginPage(togglePages: togglePages)
          : RegisterPage(togglePages: togglePages),
    );
  }
}


