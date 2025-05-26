/*

Auth Page - Determine whether to show the login or register page

*/

import 'package:flutter/material.dart';
import 'package:jungle_memos/features/auth/presentation/pages/login_page.dart';
import 'package:jungle_memos/features/auth/presentation/pages/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  bool showLoginPage = true;
  
  // Toggle Pages
  void togglePages(){
    print("Auth page being called");
    setState(() {
      showLoginPage = !showLoginPage;
    });
    print("Show login page: $showLoginPage");
  }
  @override
  Widget build(BuildContext context) {
    print("in auth page");

    if(showLoginPage){
      print("show login page");
      return LoginPage(
        togglePages: togglePages,
      );
    } else {
      return RegisterPage(
        togglePages: togglePages,
      );
    }
  }
}

