import 'package:chatapp/Chatpage/ChatsApp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

String search = "";

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent.shade100,
        title: PreferredSize(
          preferredSize: const Size(300, 100),
          child: TextFormField(
            controller: controller,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                fillColor: Colors.white,
                filled: true,
                hintText: "Search",
                hintStyle: const TextStyle(color: Colors.black),
                labelStyle: const TextStyle(color: Colors.black, fontSize: 10),
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        controller.clear();
                      });
                    },
                    icon: const Icon(
                      Icons.clear,
                      size: 20,
                      color: Colors.black,
                    ))),
            onChanged: (e) {
              setState(() {});
              print(search);
            },
          ),
        ),
      ),
      body: controller.text.isEmpty
          ? StreamBuilder(
              stream: FirebaseFirestore.instance.collection("new").snapshots(),
              builder: (context, snapshot) {
                print(snapshot.data!.docs.length);
                int length = snapshot.data!.docs.length;
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: length,
                    itemBuilder: (BuildContext context, int index) {
                      if (snapshot.data!.docs[index].id !=
                          FirebaseAuth.instance.currentUser!.uid) {
                        return ListTile(
                          title: Text(snapshot.data!.docs[index]['Name']),
                          subtitle: Text(snapshot.data!.docs[index]['Mail']),
                          leading: InkWell(
                            onTap: () {},
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                  snapshot.data!.docs[index]["profile"]),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context,MaterialPageRoute(builder:(ctx)=>
                            ChatScreen(
                             id: snapshot.data!.docs[index].id,
                              name: snapshot.data!.docs[index]["Name"],
                              profile: snapshot.data!.docs[index]["profile"],
                              url:'',
                            )
                            ));
                          },
                        );
                      }
                    });
              })
          : StreamBuilder(
              stream: FirebaseFirestore.instance.collection("new").snapshots(),
              builder: (context, snapshot) {
                print(snapshot.data!.docs.length);
                int length = snapshot.data!.docs.length;
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: length,
                    itemBuilder: (BuildContext context, int index) {
                      if (snapshot.data!.docs[index]['Name']
                              .toString()
                              .toLowerCase()
                              .contains(controller.text.toLowerCase()) ||
                          snapshot.data!.docs[index]['Mail']
                              .toString()
                              .toLowerCase()
                              .contains(controller.text)) {
                        return ListTile(
                          title: Text(snapshot.data!.docs[index]['Name']),
                          subtitle: Text(
                              snapshot.data!.docs[index]['Mail'].toString()),
                        );
                      }
                      return Container();
                    });
              }),
    );
  }
}
