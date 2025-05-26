import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jungle_memos/features/profile/domain/entities/profile_user.dart';
import 'package:jungle_memos/features/profile/presentation/pages/profile_page.dart';

class UserTile extends StatelessWidget {
  final ProfileUser user;
  
  const UserTile(
    {
      super.key,
      required this.user,
    }
  );

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      titleTextStyle: GoogleFonts.openSans(color: Theme.of(context).colorScheme.inversePrimary, fontSize: 14),

      subtitle: Text(user.email),
      subtitleTextStyle: GoogleFonts.openSans(color: Theme.of(context).colorScheme.primary),

      leading: Icon(
        Icons.person,
        color: Theme.of(context).colorScheme.primary,
      ),

      trailing: Icon(
        Icons.arrow_forward,
        color: Theme.of(context).colorScheme.primary,
      ),
      
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder:(context) => ProfilePage(username: user.username)
        )
      ),
    );
  }
}