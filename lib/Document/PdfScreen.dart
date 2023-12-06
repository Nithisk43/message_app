

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PdfScreen extends StatefulWidget {
  PdfScreen({super.key, required this.id, required this.url});
  String id;
  String url;

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  TextEditingController text = TextEditingController();
  late PDFDocument document;
  String docUrl="";
  bool isloading = true;
  String chatroomId = "";
  loadDocument()async{
    document = await PDFDocument.fromURL(widget.url);
    setState(() {
      isloading = false;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadDocument();
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
                  PDFViewer(document: document),
                 /* Center(
                    child: SizedBox(
                        height:100,
                        width:400,
                     child:Image.network(docUrl),
                    ),
                  ),*/
                  Positioned(
                    bottom:0,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black38,
                      child: TextFormField(
                        controller: text,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.text,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 17),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            hintText: "Add a caption...",
                            hintStyle: const TextStyle(color: Colors.black),
                            prefixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.add_photo_alternate,
                                    color: Colors.black, size: 27))),
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
                              "Message": text,
                              "Sendby": FirebaseAuth.instance.currentUser!.uid,
                              "Sendto": widget.id,
                              "Document": widget.url,
                              "Time": DateTime.now(),
                              "Type": "Document",
                            }).then((value) {
                              Navigator.pop(context);
                              document;
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
