import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatelessWidget {

  final void Function()? onTap;
  final String text;

  const MyButton(
    {
      super.key,
      required this.onTap,
      required this.text,
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 15, left: 15),
        child: Container(
        
          padding: const EdgeInsets.all(25),
        
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.openSans(fontSize: 20, color: Theme.of(context).colorScheme.inversePrimary),
            ),
          ),
        ),
      ),

    );
  }
}