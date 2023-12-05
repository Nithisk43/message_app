import 'dart:io';
import 'package:chatapp/About/AboutScreen.dart';
import 'package:chatapp/About/PrivacyScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'PhoneScreen.dart';
import 'SearchScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController mail = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController controller = TextEditingController();
  final bool _loading = false;
  File? imageAadhar;
  String images = "";
  String imageFilePath = "";
  String imageid = "";
  double progress = 0.0;
  UploadTask? task;
  File? file;
  String filePath = " ";
  String downloadurl = " ";
  bool loading = true;

  Future<void> getimage() async {
    await FirebaseFirestore.instance
        .collection("new")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {});
      imageid = value["profile"];
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("INBOX",
            style: TextStyle(color: Colors.white, fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent.shade100,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => const SearchScreen()));
              },
              icon: const Icon(Icons.search, size: 20, color: Colors.white)),
          IconButton(
              onPressed: () {
                getImageCamera();
              },
              icon: const Icon(Icons.camera_alt_outlined,
                  size: 20, color: Colors.white)),
          PopupMenuButton<String>(
              padding: EdgeInsets.all(0),
              onSelected: (v) {
                print(v);
              },
              itemBuilder: (BuildContext context) {
                return const [
                  PopupMenuItem(value: "New Group", child: Text("New Group")),
                  PopupMenuItem(
                      value: "New Broadcast", child: Text("New Broadcast")),
                  PopupMenuItem(
                      value: "Linked device", child: Text("Linked device")),
                  PopupMenuItem(
                      value: "Starred Message", child: Text("Starred Message")),
                  PopupMenuItem(value: "Setting", child: Text("Setting")),
                ];
              })
        ],
      ),
      drawerEnableOpenDragGesture: false,
      drawerScrimColor: Colors.transparent,
      drawer: Drawer(
        backgroundColor: Colors.white,
        shadowColor: Colors.orangeAccent.shade100,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250,
              width: double.infinity,
              child: DrawerHeader(
                decoration: BoxDecoration(
                    color: Colors.orangeAccent.shade200,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("new")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      await pickaadharimages();
                                    },
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage(
                                          snapshot.data!["profile"]),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(snapshot.data!["Name"]),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(snapshot.data!["Mail"]),
                                ],
                              ),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
                  ],
                ),
              ),
            ),
            ListTile(
              title: const Text("Privacy Policy",
                  style: TextStyle(color: Colors.black)),
              leading: const Icon(
                Icons.privacy_tip,
                size: 20,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => const PrivacyScreen()));
              },
            ),
            ListTile(
              title: const Text("About", style: TextStyle(color: Colors.black)),
              leading: const Icon(
                Icons.info_outline_rounded,
                size: 20,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => const AboutScreen()));
              },
            ),
            ListTile(
              title:
                  const Text("Sign Out", style: TextStyle(color: Colors.black)),
              leading: const Icon(
                Icons.exit_to_app_outlined,
                size: 20,
                color: Colors.black,
              ),
              onTap: () async {
                var pref = await SharedPreferences.getInstance();
                pref.setBool('logout', true);
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => const PhoneScreen()));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.contacts,
          size: 20,
          color: Colors.black,
        ),
      ),
    );
  }

  Future pickaadharimages() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      print("imageTemp ====? ${imageTemp}");
      imageFilePath = basename(imageTemp.path);
      print("aadharFilePath ====? ${imageFilePath}");
      setState(() => this.imageAadhar = imageTemp);
      // Create a storage reference from our app
      final storageRef = FirebaseStorage.instance.ref();
      // Create a reference to "mountains.jpg"
      final mountainImagesRef =
          storageRef.child("AdminAadharImage/$imageFilePath");
      await mountainImagesRef.putFile(imageTemp);
      String aadharurl = await mountainImagesRef.getDownloadURL();
      print(aadharurl);
      setState(() {
        images = aadharurl;
      });
    } on PlatformException catch (e) {
      print("FAiled to pick image:$e");
    }
  }

  String imageUrl = "";
  File? imageFile;
  Future getImageCamera() async {
    ImagePicker picker = ImagePicker();
    await picker.pickImage(source: ImageSource.camera).then((xFile) async {
      if (xFile != null) {
        print(xFile.path);
        imageFile = File(xFile.path);
        var ref = FirebaseStorage.instance
            .ref()
            .child("images")
            .child("${imageFile}.jpg");
        var uploadTask = await ref.putFile(imageFile!);
        imageUrl = await uploadTask.ref.getDownloadURL();
        print(imageUrl);
        setState(() {});
      }
    });
  }
}
