import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  VideoScreen({Key? key, required this.id, required this.url})
      : super(key: key);
  String id;
  final String url;

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  String chatroomId = "";
  late VideoPlayerController _controller;
  String docUrl="";
  bool isloading= true;
  TextEditingController text = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((value) {
        setState(() {});
      });
    getChatRoomId(String uid1, String uid2) {
      if (uid1.hashCode <= uid2.hashCode) {
        return '$uid1-$uid2';
      } else {
        return '$uid2-$uid1';
      }
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }


  @override
  Widget build(BuildContext context) {
    chatroomId =
        getChatRoomId(FirebaseAuth.instance.currentUser!.uid, widget.id);
    print(">>>>>>>>>>>>>>>$chatroomId");
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
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
              child: Stack(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: _controller.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller))
                        : Container(),
                  ),
                  Positioned(
                      bottom:70,
                      child: Container(
                        color: Colors.black38,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 8),
                        child: TextFormField(
                          controller: text,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 17),
                          maxLines: 6,
                          minLines: 1,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              hintText: "Add Caption.....",
                              hintStyle: const TextStyle(
                                  color: Colors.white, fontSize: 17),
                              prefixIcon: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.add_photo_alternate,
                                      size: 27, color: Colors.white)),
                              suffixIcon: CircleAvatar(
                                radius:15,
                                backgroundColor: Colors.tealAccent[700],
                                child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.check_circle_outlined,
                                      size: 27,
                                      color: Colors.white,
                                    )),
                              )),
                        ),
                      )),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                      child: CircleAvatar(
                        radius: 33,
                        backgroundColor: Colors.black38,
                        child: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey,
                      child: IconButton(
                          onPressed: () async {
                            print(">>>>>>>>>>>>>>>>>>$chatroomId");
                            await FirebaseFirestore.instance
                                .collection("chatroom")
                                .doc(chatroomId)
                                .set({
                              "Sendby": FirebaseAuth.instance.currentUser!.uid,
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
                              "Message": text.text,
                              "Sendby": FirebaseAuth.instance.currentUser!.uid,
                              "Sendto": widget.id,
                              "Video": widget.url,
                              "Time": DateTime.now(),
                              "Type": "Video",
                            }).then((value) {
                              Navigator.pop(context);
                              docUrl;
                              text.clear();
                            });
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 27,
                          )),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  String getChatRoomId(String uid1, String uid2) {
    if (uid1.hashCode <= uid2.hashCode) {
      return '$uid1-$uid2';
    } else {
      return '$uid2-$uid1';
    }
  }

}
