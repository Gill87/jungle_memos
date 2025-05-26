import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField(
    {
      super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
    });

  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 15),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
      
          // Border when unselected
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
            borderRadius: BorderRadius.circular(12),
          ),
      
          // Border when selected
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(12),
          ),
      
          // Hint Text
          hintText: (hintText.isEmpty) ? "Empty Bio" : hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          fillColor: Theme.of(context).colorScheme.secondary,
          filled: true,
        ),
      
      ),
    );
  }
}