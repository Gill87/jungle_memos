import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jungle_memos/config/firebase_options.dart';
import 'package:jungle_memos/myapp.dart';

// Guri Rating Feature maybe

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}
