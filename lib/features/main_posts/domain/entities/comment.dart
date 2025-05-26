import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String commentId;
  final String postId;
  final String userId;
  final String userName;
  final String text;
  final DateTime timestamp;


  Comment(
    {
      required this.commentId,
      required this.postId,
      required this.userId,
      required this.userName,
      required this.text,
      required this.timestamp,
    }
  );

  // Convert comment to json
  Map<String, dynamic> toJson(){
    return {
      'commentId': commentId,
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  // Convert from json to comment
  factory Comment.fromJson(Map<String, dynamic> json){
    return Comment(
      commentId: json['commentId'],
      postId: json['postId'],
      userId: json['userId'],
      userName: json['userName'],
      text: json['text'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }
}