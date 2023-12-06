import 'package:chatapp/Document/FileScreen.dart';
import 'package:chatapp/Premission/CameraScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Chatpage/PhoneScreen.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
      options:  FirebaseOptions(
          apiKey: "AIzaSyAEIhFdluAXDjc2eOy0SCvI80A_m02mwNo",
          appId: "1:1046984787158:android:c27fcde188b5aad3eb7577",
          messagingSenderId: "1046984787158",
          projectId: "chatapp-cf843",
       storageBucket: "gs://chatapp-cf843.appspot.com"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home:FiledowloadScreen());
  }
}
