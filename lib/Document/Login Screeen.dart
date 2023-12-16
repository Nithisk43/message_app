import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String token="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((event) {
      if(event !=null){
       print(event.notification!.title);
       print(event.notification!.body);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: ()async{
              var tokenn=await FirebaseMessaging.instance.getToken();
              setState(() {
                token=tokenn!;
              });
              print(token);
              },child:const Text("Get token")),
              Text(token),
            ElevatedButton(onPressed: (){}, child:Text("Show"))
          ],
        ),
      ),
    );
  }
}
