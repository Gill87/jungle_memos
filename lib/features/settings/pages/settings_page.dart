import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jungle_memos/themes/theme_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});


  // BUILD UI
  @override
  Widget build(BuildContext context) {

    // Theme Cubit
    final themeCubit = context.watch<ThemeCubit>();

    // if dark mode
    bool isDarkMode = themeCubit.isDarkMode;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: GoogleFonts.openSans(color: Theme.of(context).colorScheme.inversePrimary),
        ),
      ),

      body: Column(
        children: [
          // Dark Mode Tile
          ListTile(
            title: Text("Dark Mode", style: GoogleFonts.openSans(color: Theme.of(context).colorScheme.primary)),
            trailing: CupertinoSwitch(
              value: isDarkMode, 
              onChanged: (value) {
                themeCubit.toggleTheme();
              }
            ),
          )
        ],
      ),

    );
  }
}