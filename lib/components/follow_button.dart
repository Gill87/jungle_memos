/*

  FOLLOW BUTTON

  This is a follow/unfollow button


  To use this widget you need
    - a function (toggleFollow)
    - isFollowing boolean to decide whether to show follow or unfollow

*/

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FollowButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isFollowing;

  const FollowButton(
    {
      super.key,
      required this.onPressed,
      required this.isFollowing,
    }
  );

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: MaterialButton(
          padding: const EdgeInsets.all(12),
          onPressed: onPressed,
          color: isFollowing ? Theme.of(context).colorScheme.primary : Colors.blue,
          child: Text(
            isFollowing ? "Unfollow" : "Follow",
            style: GoogleFonts.openSans(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}