/*

Login Page

On this page, an existing user can login with their
    - email
    - password

---------------------------------------------------

Once the user successfuly logs in, they will be redirected to the HomePage

If user doesn't have an account, they can go to the RegisterPage

*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jungle_memos/components/my_button.dart';
import 'package:jungle_memos/components/my_textfield.dart';
import 'package:jungle_memos/features/auth/presentation/cubits/auth_cubit.dart';


class LoginPage extends StatefulWidget {

  final void Function()? togglePages;

  const LoginPage(
    {
        super.key,
        required this.togglePages,
    });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

    // Text Controllers
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    // Login
    void login() {

        // Prepare email and password
        final String email = emailController.text;
        final String password = passwordController.text;

        // Auth Cubit
        final authCubit = context.read<AuthCubit>();

        // Ensure fields are not empty
        if(email.isNotEmpty && password.isNotEmpty){
            // Login
            authCubit.login(email, password);
        } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Please enter an email and password"),
                )
            );
        }
        
    }

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  
  // BUILD UI
  @override
  Widget build(BuildContext context) {
    
    // SCAFFOLD
    return Scaffold(
        // Body
        body: SingleChildScrollView(
          child: SafeArea(
              child: Center(
                child: Column(
                    children: [
                      
                      const SizedBox(height: 70),
          
                        // Logo
                        Icon(
                            Icons.lock,
                            size: 80,
                            color: Theme.of(context).colorScheme.primary,
                        ),
                      
                      const SizedBox(height: 40),
          
                        // Welcome Back
                        Text(
                            "Welcome Back",
                            style: GoogleFonts.openSans(fontSize: 30, color: Theme.of(context).colorScheme.inverseSurface),
                        ),
          
                        const SizedBox(height: 40,),
                
                        // Email Text Field
                        MyTextField(controller: emailController, hintText: "Email", obscureText: false),
          
                        const SizedBox(height: 15,),
          
                        // Password Text Field
                        MyTextField(controller: passwordController, hintText: "Password", obscureText: true),
          
                        // TODO Forget Password
                        
          
                        const SizedBox(height: 25,),
          
                        // Sign in Button
                        MyButton(
                          onTap: ()=> {
                            login(),
                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => const HomePage()),
                            // ),
                          }, 
                          text: "Login"
                        ),
          
                        const SizedBox(height: 15,),
          
                        // If you don't have an account, please register
                       Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Not a member?",
                              style: GoogleFonts.openSans(fontSize: 16, color: Theme.of(context).colorScheme.inversePrimary),
                            ),

                            GestureDetector(
                              onTap: widget.togglePages,
                              child: Text(
                                " Register now?",
                                style: GoogleFonts.openSans(fontSize: 16, color: Theme.of(context).colorScheme.inversePrimary, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                    ],
                ),
              ),
          
          ),
        )
    );
  }
}