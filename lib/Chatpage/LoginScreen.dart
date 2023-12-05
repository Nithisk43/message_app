/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'CameraScreen.dart';
import 'HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder:(context,snapshot){
            if(snapshot.hasData){
              return CameraScreen();
            }
            return HomeScreen();
          }),
    );
  }
}*/
