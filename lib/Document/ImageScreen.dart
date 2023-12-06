import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ImageScreen extends StatefulWidget {
  ImageScreen({super.key, required this.id, required this.url});
  String id;
  String url;

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  TextEditingController controller = TextEditingController();

  bool isloading = true;
  String chatroomId = "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChatRoomId(String uid1, String uid2) {
      if (uid1.hashCode <= uid2.hashCode) {
        return '$uid1-$uid2';
      } else {
        return '$uid2-$uid1';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    chatroomId =
        getChatRoomId(FirebaseAuth.instance.currentUser!.uid, widget.id);
    print(">>>>>>>>>>>>>>>${chatroomId}");
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.crop_rotate,
                  size: 27,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.emoji_emotions_outlined,
                  size: 27,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.title,
                  size: 27,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.edit,
                  size: 27,
                  color: Colors.white,
                )),
          ],
        ),
        body: isloading == false
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 150,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(widget.url),
                            fit: BoxFit.cover)),
                  ),
                  Positioned(
                    bottom:50,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black38,
                      child: TextFormField(
                        controller: controller,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 17),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            hintText: "Add a caption...",
                            hintStyle:
                                const TextStyle(color: Colors.black),
                            prefixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                    Icons.add_photo_alternate,
                                    color: Colors.black,
                                    size: 27))),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.tealAccent.shade700,
                      child: IconButton(
                          onPressed: () async {
                            print(">>>>>>>>>>>>>>>>>>$chatroomId");
                            await FirebaseFirestore.instance
                                .collection("chatroom")
                                .doc(chatroomId)
                                .set({
                              "Sendby":
                                  FirebaseAuth.instance.currentUser!.uid,
                              "Sendto": widget.id,
                              "id": FieldValue.arrayUnion([
                                FirebaseAuth.instance.currentUser!.uid,
                                widget.id
                              ]),
                            });
                            await FirebaseFirestore.instance
                                .collection("chatroom")
                                .doc(chatroomId)
                                .collection("chats")
                                .doc()
                                .set({
                              "Message":controller.text,
                              "Sendby":
                                  FirebaseAuth.instance.currentUser!.uid,
                              "Sendto": widget.id,
                              "image":widget.url,
                              "Time": DateTime.now(),
                              "Type": "image",
                            }).then((value) {
                              Navigator.pop(context);
                              controller.clear();
                              setState(() {
                              widget.url;
                              });
                            });
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 20,
                          )),
                    ),
                  )
                ],
              ),
            ));
  }

  String getChatRoomId(String uid1, String uid2) {
    if (uid1.hashCode <= uid2.hashCode) {
      return '$uid1-$uid2';
    } else {
      return '$uid2-$uid1';
    }
  }
}
