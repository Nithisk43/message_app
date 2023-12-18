import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomeScreen.dart';
import 'Otpscreen.dart';


class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});


  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    check();
  }
  void check()async{
    var pref = await SharedPreferences.getInstance();
    bool? st = pref.getBool('login');
    if(st == true){
      Navigator.push(context,MaterialPageRoute(builder:(context)=>HomeScreen()));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://img.freepik.com/free-photo/ombre-blue-curve-light-blue-background-vector_53876-170266.jpg?w=360&t=st=1700717593~exp=1700718193~hmac=b0de5b9b19792b66e9bc234e840a5fb2439b5801ebdd265a00c62e30aef1012d"),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
              width: 300,
              child: Center(
                child: Text("WELCOME",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 30)),
              ),
            ),
            SizedBox(
                height: 50,
                width: 300,
                child: Row(
                  children: [
                    const SizedBox(
                      height: 50,
                      width: 60,
                      child: Expanded(
                          flex: 1,
                          child: Center(
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: "+91",
                                  hintStyle: TextStyle(color: Colors.black),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10)),
                                  )),
                            ),
                          )),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "Phone Number",
                            hintStyle: const TextStyle(color: Colors.black),
                            labelStyle: const TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  controller.clear();
                                },
                                icon: const Icon(
                                  Icons.close,
                                  size: 20,
                                  color: Colors.black,
                                )),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(5)),
                            )),
                        onChanged: (v) {
                          print(v);
                        },
                        onSaved: (s) {
                          print(s);
                        },
                      ),
                    ),
                  ],
                )),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  print(">>>>>>>>>>>>>>>>>${controller.text}");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => OtpScreen(
                                Mob_no: controller.text,
                              )));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    fixedSize: const Size(100, 50),
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
          ],
        ),
      ),
    );
  }
}
