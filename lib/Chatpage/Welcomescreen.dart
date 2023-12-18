import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'HomeScreen.dart';

class WelcomeScreen extends StatefulWidget {
  String mail;
  String name;
  String phone;
  WelcomeScreen(
      {super.key, required this.name, required this.phone, required this.mail});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController mail = TextEditingController();
  bool loading = true;
  double progress = 0.0;
  String aadharFilePath = "";
  String filepath="";
  File? file;
  String aadhar = "";
  File? imageAadhar;
  String downloadurl = "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = TextEditingController(text: widget.name);
    mail = TextEditingController(text: widget.mail);
    phone = TextEditingController(text: widget.phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.grey,
          Colors.deepPurpleAccent,
          Colors.purpleAccent,
          Colors.purple,
          Colors.blueGrey
        ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            loading == false
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          await pickimages();
                        },
                        child: CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage(aadhar),
                        ),
                      ),
                    ],
                  ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
              width: 300,
              child: TextFormField(
                controller: name,
                keyboardType: TextInputType.text,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Name",
                    fillColor: Colors.white,
                    filled: true,
                    labelStyle:
                        const TextStyle(color: Colors.black, fontSize: 20)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
              width: 300,
              child: TextFormField(
                controller: phone,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Phone Number",
                    fillColor: Colors.white,
                    filled: true,
                    labelStyle:
                        const TextStyle(color: Colors.black, fontSize: 20)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
              width: 300,
              child: TextFormField(
                controller: mail,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Mail",
                    fillColor: Colors.white,
                    filled: true,
                    labelStyle:
                        const TextStyle(color: Colors.black, fontSize: 20)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection("new")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .set({
                    "profile":aadhar.toString(),
                    "Name": name.text,
                    "Phone": phone.text,
                    "Mail": mail.text,
                  }).then((value) {
                    mail.clear();
                    name.clear();
                    phone.clear();
                  });
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => HomeScreen()));
                },
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(100, 50),
                    backgroundColor: Colors.lightBlue,
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }

  Future pickimages() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      print("imageTemp =============? ${imageTemp}");
      aadharFilePath = basename(imageTemp.path);
      print("aadharFilePath ==========? ${aadharFilePath}");
      this.imageAadhar = imageTemp;
      // Create a storage reference from our app
      final storageRef = FirebaseStorage.instance.ref();
      // Create a reference to "mountains.jpg"
      final mountainImagesRef =
          storageRef.child("AdminAadharImage/$aadharFilePath");
      await mountainImagesRef.putFile(imageTemp);
      String aadharurl = await mountainImagesRef.getDownloadURL();
      print(aadharurl);
      setState(() {
        aadhar = aadharurl;
      });
    } on PlatformException catch (e) {
      print("FAiled to pick image:$e");
    }
  }
}
