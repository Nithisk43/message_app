
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Chatpage/PhoneScreen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  void checkPermission()async{
    Map<Permission,PermissionStatus>status=
    await[
      Permission.camera,
      Permission.phone,
      Permission.contacts,
      Permission.notification,

    ].request();
    print(status);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPermission();
  }
  @override
  Widget build(BuildContext context) {
    return  PhoneScreen();
  }
}
