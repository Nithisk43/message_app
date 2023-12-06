import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import '../Document/ImageScreen.dart';
import '../Document/PdfScreen.dart';
import '../Document/VideoScreen.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({
    super.key,
    required this.id,
    required this.name,
    required this.profile,
    required this.url,
  });
  String name;
  String profile;
  String id;
  String url;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController message = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool sendButton = false;
  bool show = false;
  String chatroomId = "";
  String image = "";
  double progress = 0.0;
  String aadharFilePath = "";
  String filepath = "";
  File? file;
  String aadhar = "";
  File? imageAadhar;
  String downloadurl = "";
  UploadTask? task;

  String id = "";
  String name = "";
  String profile = "";
  String docUrl = "";
  File? doc;
  late PDFDocument document;
  bool isloading = true;
  loadDocument() async {
    document = await PDFDocument.fromURL(widget.url);
    setState(() {
      isloading = false;
    });
  }

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

  String getChatRoomId(String uid1, String uid2) {
    if (uid1.hashCode <= uid2.hashCode) {
      return '$uid1-$uid2';
    } else {
      return '$uid2-$uid1';
    }
  }

  @override
  Widget build(BuildContext context) {
    chatroomId =
        getChatRoomId(FirebaseAuth.instance.currentUser!.uid, widget.id);
    print(">>>>>>>>>>>>>>>${chatroomId}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent.shade100,
        title: SizedBox(
          width: 270,
          child: Row(
            children: [
              InkWell(
                  onTap: () {},
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(widget.profile),
                  )),
              const SizedBox(
                width: 5,
              ),
              Text(widget.name)
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.call,
                size: 20,
                color: Colors.black,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.videocam,
                size: 20,
                color: Colors.black,
              )),
          PopupMenuButton<String>(
              color: Colors.black,
              shape: const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5))),
              padding: const EdgeInsets.all(0),
              onSelected: (v) {
                print(v);
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: "View Contact",
                    child: TextButton(
                        onPressed: () {}, child: const Text("View Contact")),
                  ),
                  PopupMenuItem(
                    value: "Media, links, and docs",
                    child: TextButton(
                        onPressed: () {},
                        child: const Text("Media, links, and docs")),
                  ),
                  PopupMenuItem(
                    value: "Search",
                    child: TextButton(
                        onPressed: () {}, child: const Text("Search")),
                  ),
                  PopupMenuItem(
                    value: "Mute Notification",
                    child: TextButton(
                        onPressed: () {},
                        child: const Text("Mute Notification")),
                  ),
                  PopupMenuItem(
                    value: "Wallpaper",
                    child: TextButton(
                        onPressed: () {}, child: const Text("Wallpaper")),
                  ),
                ];
              })
        ],
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(color: Colors.white),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chatroom")
                    .doc(chatroomId)
                    .collection("chats")
                    .orderBy("Time", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          print(widget.id);
                          if (snapshot.data!.docs[index]["Sendby"] ==
                              FirebaseAuth.instance.currentUser!.uid) {
                            return Align(
                                alignment: Alignment.topRight,
                                child: WillPopScope(
                                  onWillPop: (){
                                    if(show){
                                      setState(() {
                                        show= false;
                                      });
                                    }else{
                                      Navigator.pop(context);
                                    }
                                    return Future.value(false);
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      snapshot.data!.docs[index]["Type"] ==
                                              "image"
                                          ? SizedBox(
                                              height:300,
                                              width: 400,
                                              child: Image.network(snapshot
                                                  .data!.docs[index]["image"]),
                                            )
                                          : snapshot.data!.docs[index]["Type"] ==
                                                  "Document"
                                              ? SizedBox(
                                                  height: 100,
                                                  width: 150,
                                                  child: Column(
                                                    children: [
                                                      IconButton(
                                                          onPressed: () {
                                                            print(snapshot.data!
                                                                    .docs[index]
                                                                ["Document"]);
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (ctx) => PdfScreen(
                                                                        id: widget
                                                                            .id,
                                                                        url: snapshot
                                                                            .data!
                                                                            .docs[index]["Document"])));
                                                          },
                                                          icon: const Icon(Icons
                                                              .picture_as_pdf))
                                                    ],
                                                  ))
                                              : snapshot.data!.docs[index]
                                                          ["Type"] ==
                                                      "Video"
                                                  ? SizedBox(
                                                      height: 100,
                                                      width: 150,
                                                      child: Column(children: [
                                                        IconButton(
                                                            onPressed: () {
                                                              print(snapshot.data!
                                                                      .docs[index]
                                                                  ["Video"]);
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (ctx) => VideoScreen(
                                                                          id: widget
                                                                              .id,
                                                                          url: snapshot
                                                                              .data!
                                                                              .docs[index]["Video"])));
                                                            },
                                                            icon: const Icon(
                                                                Icons.play_arrow))
                                                      ]))
                                                  : Container(
                                                      color: Colors.grey,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top:10,
                                                              bottom:10,
                                                              left: 10,
                                                              right:10),
                                                      child: Text(
                                                          snapshot.data!
                                                                  .docs[index]
                                                              ["Message"],
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white)),
                                                    )
                                    ],
                                  ),
                                ));
                          }
                          const SizedBox(
                            height: 10,
                          );
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                snapshot.data!.docs[index]["Type"] == "image"
                                    ? SizedBox(
                                        height:300,
                                        width:400,
                                        child: Image.network(snapshot
                                            .data!.docs[index]["image"]),
                                      )
                                    : snapshot.data!.docs[index]["Type"] ==
                                            "Document"
                                        ? SizedBox(
                                            height: 100,
                                            width: 150,
                                            child: Column(
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      print(snapshot
                                                              .data!.docs[index]
                                                          ["Document"]);
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (ctx) => PdfScreen(
                                                                  id: widget.id,
                                                                  url: snapshot
                                                                          .data!
                                                                          .docs[index]
                                                                      [
                                                                      "Document"])));
                                                    },
                                                    icon: const Icon(
                                                        Icons.picture_as_pdf))
                                              ],
                                            ))
                                        : snapshot.data!.docs[index]["Type"] ==
                                                "Video"
                                            ? SizedBox(
                                                height: 100,
                                                width: 150,
                                                child: Column(children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        print(snapshot.data!
                                                                .docs[index]
                                                            ["Video"]);
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (ctx) => VideoScreen(
                                                                    id: widget
                                                                        .id,
                                                                    url: snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                        [
                                                                        "Video"])));
                                                      },
                                                      icon: const Icon(
                                                          Icons.play_arrow))
                                                ]))
                                            : Container(
                                                color: Colors.teal,
                                                padding: const EdgeInsets.only(
                                                    top:10,
                                                    bottom:10,
                                                    left: 10,
                                                    right:10),
                                                child: Text(
                                                    snapshot.data!.docs[index]
                                                        ["Message"],
                                                    style: const TextStyle(
                                                        color: Colors.white)),
                                              ),
                              ],
                            ),
                          );
                        });
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                height: 70,
                width: 400,
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    show ? emojiSelect() : Container(),
                    Container(
                      height: 65,
                      width: 280,
                      color: Colors.white,
                      child: TextFormField(
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.multiline,
                        controller: message,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText: "Message",
                          hintStyle: const TextStyle(color: Colors.black),
                          labelStyle: const TextStyle(color: Colors.black),
                          prefixIcon: IconButton(
                              onPressed: () {
                                if (!show) {
                                  focusNode.unfocus();
                                  focusNode.canRequestFocus = false;
                                }
                                setState(() {
                                  show = !show;
                                });
                              },
                              icon: Icon(show
                                  ? Icons.keyboard
                                  : Icons.emoji_emotions_outlined)),
                          suffixIcon: Transform.rotate(
                            angle: -120,
                            child: IconButton(
                                onPressed: () => showDialog(
                                    context: context,
                                    builder: (ctx) => Align(
                                          alignment: Alignment.bottomCenter,
                                          child: SizedBox(
                                            height: 350,
                                            width: 350,
                                            child: AlertDialog(
                                              actions: [
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10,
                                                        vertical: 20),
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  CircleAvatar(
                                                                    radius: 25,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .indigo,
                                                                    child: IconButton(
                                                                        onPressed: () {
                                                                          pdfdoc(
                                                                              context);
                                                                        },
                                                                        icon: const Icon(
                                                                          Icons
                                                                              .insert_drive_file,
                                                                          size:
                                                                              27,
                                                                          color:
                                                                              Colors.white,
                                                                        )),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          5),
                                                                  const Text(
                                                                    "Document",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blueGrey,
                                                                        fontSize:
                                                                            15),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  height: 15),
                                                              Column(
                                                                children: [
                                                                  CircleAvatar(
                                                                    radius: 25,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .lightBlueAccent,
                                                                    child: IconButton(
                                                                        onPressed: () {
                                                                          videofile(
                                                                              context);
                                                                        },
                                                                        icon: const Icon(
                                                                          Icons
                                                                              .video_collection_outlined,
                                                                          size:
                                                                              27,
                                                                          color:
                                                                              Colors.white,
                                                                        )),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          5),
                                                                  const Text(
                                                                    "Video",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blueGrey,
                                                                        fontSize:
                                                                            15),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  height: 15),
                                                              Column(
                                                                children: [
                                                                  CircleAvatar(
                                                                    radius: 25,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .purple,
                                                                    child: IconButton(
                                                                        onPressed: () {
                                                                          pickAadharImage(
                                                                              context);
                                                                        },
                                                                        icon: const Icon(
                                                                          Icons
                                                                              .insert_photo,
                                                                          size:
                                                                              27,
                                                                          color:
                                                                              Colors.white,
                                                                        )),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          5),
                                                                  const Text(
                                                                    "Gallery",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blueGrey,
                                                                        fontSize:
                                                                            15),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  CircleAvatar(
                                                                    radius: 25,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .orange,
                                                                    child: IconButton(
                                                                        onPressed: () {},
                                                                        icon: const Icon(
                                                                          Icons
                                                                              .headphones,
                                                                          size:
                                                                              27,
                                                                          color:
                                                                              Colors.white,
                                                                        )),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          5),
                                                                  const Text(
                                                                    "Audio",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blueGrey,
                                                                        fontSize:
                                                                            15),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  height: 15),
                                                              Column(
                                                                children: [
                                                                  CircleAvatar(
                                                                    radius: 25,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .pink,
                                                                    child: IconButton(
                                                                        onPressed: () {},
                                                                        icon: const Icon(
                                                                          Icons
                                                                              .video_collection_outlined,
                                                                          size:
                                                                              27,
                                                                          color:
                                                                              Colors.white,
                                                                        )),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          5),
                                                                  const Text(
                                                                    "Camera",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blueGrey,
                                                                        fontSize:
                                                                            15),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  height: 15),
                                                              Column(children: [
                                                                CircleAvatar(
                                                                  radius: 25,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .teal,
                                                                  child: IconButton(
                                                                      onPressed: () {},
                                                                      icon: const Icon(
                                                                        Icons
                                                                            .location_pin,
                                                                        size:
                                                                            27,
                                                                        color: Colors
                                                                            .white,
                                                                      )),
                                                                ),
                                                                const SizedBox(
                                                                    height: 5),
                                                                const Text(
                                                                  "Location",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blueGrey,
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                                const SizedBox(
                                                                    height: 15),
                                                              ]),
                                                              const SizedBox(
                                                                  height: 15),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  CircleAvatar(
                                                                    radius: 25,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .blue,
                                                                    child: IconButton(
                                                                        onPressed: () {},
                                                                        icon: const Icon(
                                                                          Icons
                                                                              .person,
                                                                          size:
                                                                              27,
                                                                          color:
                                                                              Colors.white,
                                                                        )),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          5),
                                                                  const Text(
                                                                    "Contact",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blueGrey,
                                                                        fontSize:
                                                                            15),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ]))
                                              ],
                                            ),
                                          ),
                                        )),
                                icon: const Icon(
                                  Icons.attach_file_rounded,
                                  size: 20,
                                  color: Colors.black,
                                )),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                        onTap: () async {
                          if (message.text.isEmpty) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Enter some text"),
                            ));
                          } else {
                            print(">>>>>>>>>>>>>>${chatroomId}");
                            await FirebaseFirestore.instance
                                .collection("chatroom")
                                .doc(chatroomId)
                                .set({
                              "Sendby": FirebaseAuth.instance.currentUser!.uid,
                              "Sendto": widget.id,
                              "id": FieldValue.arrayUnion([
                                FirebaseAuth.instance.currentUser!.uid,
                                widget.id
                              ])
                            });
                            await FirebaseFirestore.instance
                                .collection("chatroom")
                                .doc(chatroomId)
                                .collection("chats")
                                .doc()
                                .set({
                              "Message": message.text,
                              "Sendby": FirebaseAuth.instance.currentUser!.uid,
                              "Sendto": widget.id,
                              "Time": DateTime.now(),
                              "Type": "Text",
                            }).then((value) {
                              message.clear();
                            });
                          }
                        },
                        child: CircleAvatar(
                            radius: 20,
                            child: Icon(
                              sendButton ? Icons.send : Icons.mic,
                              color: Colors.black,
                              size: 20,
                            )))
                  ],
                )),
          )
        ],
      ),
    );
  }

  Future pickAadharImage(BuildContext context) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      print("imageTemp ====? $imageTemp");
      aadharFilePath = basename(imageTemp.path);
      print("aadharFilePath ====? $aadharFilePath");
      setState(() => this.imageAadhar = imageTemp);
      // Create a storage reference from our app
      final storageRef = FirebaseStorage.instance.ref();
      // Create a reference to "mountains.jpg"
      final mountainImagesRef =
          storageRef.child("AdminAadharImage/$aadharFilePath");
      await mountainImagesRef.putFile(imageTemp);
      String aadharurl =
          await mountainImagesRef.getDownloadURL().then((value) async {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => ImageScreen(id: widget.id, url: value)));
        return widget.url;
      });
      print(aadharurl);
      setState(() {
        aadhar = aadharurl;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pdfdoc(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowedExtensions: ["pdf"], type: FileType.custom);
    if (result != null) {
      PlatformFile file = result.files.first;
      doc = File(file.path!);
      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
      var ref = FirebaseStorage.instance
          .ref()
          .child("image")
          .child("document/${file.name}");
      var uploadPdf = await ref.putFile(doc!);
      docUrl = await uploadPdf.ref.getDownloadURL().then((value) async {
        loadDocument();
        PDFDocument docc = await PDFDocument.fromFile(doc!);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => PdfScreen(id: widget.id, url: value)));
        return docUrl;
      });
      setState(() {});
      print((docUrl));
    }
  }

  Future videofile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowedExtensions: ["mp4"], type: FileType.custom);
    if (result != null) {
      PlatformFile file = result.files.first;
      doc = File(file.path!);
      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
      var ref = FirebaseStorage.instance
          .ref()
          .child("Video")
          .child("Video/${file.name}");
      var uploadPdf = await ref.putFile(doc!);
      docUrl = await uploadPdf.ref.getDownloadURL().then((value) {
        loadDocument();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => VideoScreen(id: widget.id, url: value)));
        return docUrl;
      });
      setState(() {});
      print((docUrl));
    }
  }

  Widget emojiSelect() {
    return EmojiPicker(onEmojiSelected: (emoji, category) {
      print(emoji);
      setState(() {
        message.text = message.text;
      });
    });
  }
}
