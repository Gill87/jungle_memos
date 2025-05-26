import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jungle_memos/components/my_button.dart';
import 'package:jungle_memos/components/my_textfield.dart';
import 'package:jungle_memos/features/auth/presentation/cubits/auth_cubit.dart';

class RegisterPage extends StatefulWidget {

  final void Function()? togglePages;

  const RegisterPage(
    {
        super.key,
        required this.togglePages,
    });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  // Text Controllers
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void register(){
    final String name = nameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;

    // Auth Cubit
    final authCubit = context.read<AuthCubit>();
    
    // ensure fields aren't empty
    if(email.isNotEmpty && name.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty){
      if(password == confirmPassword){
        authCubit.register(email, password, name);
      }
    } 
    
    // Fields are empty
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields")),
      );
    }
  }

  @override
  void dispose(){
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                            "Let's Create An Account",
                            style: GoogleFonts.openSans(fontSize: 30, color: Theme.of(context).colorScheme.inverseSurface),
                        ),
          
                        const SizedBox(height: 40,),
                
                        // Name Text Field
                        MyTextField(controller: nameController, hintText: "Name", obscureText: false),
          
                        const SizedBox(height: 15,),

                        // Email Text Field
                        MyTextField(controller: emailController, hintText: "Email", obscureText: false),
                        
                        const SizedBox(height: 15,),

                        // Password Text Field
                        MyTextField(controller: passwordController, hintText: "Password", obscureText: true),
                        
                        const SizedBox(height: 15,),

                        // Confirm Password Text Field
                        MyTextField(controller: confirmPasswordController, hintText: "Confirm Password", obscureText: true),                        
          
                        const SizedBox(height: 25,),
          
                        // Sign Up Button
                        MyButton(onTap: ()=>register() , text: "Sign Up"),
          
                        const SizedBox(height: 15,),
          
                        // If you don't have an account, please register
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already a member?",
                              style: GoogleFonts.openSans(fontSize: 16, color: Theme.of(context).colorScheme.inversePrimary),
                            ),

                            GestureDetector(
                              onTap: widget.togglePages,
                              child: Text(
                                " Login now?",
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