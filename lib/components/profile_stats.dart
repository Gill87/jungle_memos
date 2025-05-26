/*

  PROFILE STATS

  This will be displayed on all profile pages

  Display number of 
    - posts
    - followers
    - following

*/

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileStats extends StatelessWidget {

  final int postCount;
  final int followerCount;
  final int followingCount;
  final void Function()? onTap;

  const ProfileStats(
    {
      super.key,
      required this.postCount,
      required this.followerCount,
      required this.followingCount,
      required this.onTap,
    }
  );

  // BUILD UI
  @override
  Widget build(BuildContext context) {

    var textStyleForCount = GoogleFonts.openSans(color: Theme.of(context).colorScheme.inversePrimary, fontSize: 16);
    var textStyleForText = GoogleFonts.openSans(color: Theme.of(context).colorScheme.primary);

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        
          // Posts
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text("Posts", style: textStyleForText),
                Text(postCount.toString(), style: textStyleForCount),
              ],
            ),
          ),
      
          // Followers
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text("Followers", style: textStyleForText),
                Text(followerCount.toString(), style: textStyleForCount),
              ],
            ),
          ),
      
          // Following
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text("Following", style: textStyleForText),
                Text(followingCount.toString(), style: textStyleForCount),
              ],
            ),
          ),
      
        ],
      ),
    );
  }
}