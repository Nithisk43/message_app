import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomeScreen.dart';
import 'Welcomescreen.dart';

class OtpScreen extends StatefulWidget {
  String Mob_no;
  OtpScreen({super.key, required this.Mob_no});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController _otpput = TextEditingController();
  String code = "";
  String smsCode = "";
  String? _verificationCode;
  verifynumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91${widget.Mob_no}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          final User? user = FirebaseAuth.instance.currentUser;
          final uid = user!.uid;
          print(">>>>>>>>>>>>>>>>>>>>${uid}");
          var im =
              await FirebaseFirestore.instance.collection("new").doc(uid).get();
          if (im.exists) {
            var pref =await  SharedPreferences.getInstance();
            pref.setBool('login', true);
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return HomeScreen();
              },
            ));
          } else {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return WelcomeScreen(name:'',phone:widget.Mob_no,mail: '',);
              },
            ));
          }
        });
      },
      verificationFailed: (FirebaseAuthException s) {
        print(s);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("${s.message}"),
            );
          },
        );
      },
      codeSent: (String? verificationID, int? resendToken) {
        setState(() {
          print(">>>>>>>>>>>>>>>>>>>>>>>>${verificationID}");
          _verificationCode = verificationID;
        });
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        setState(() {
          _verificationCode = verificationID;
        });
      },
      timeout: const Duration(seconds: 60),
    );
  }

  Future<void> submitOtp() async {
    final credential = PhoneAuthProvider.credential(
        verificationId: _verificationCode!, smsCode: _otpput.text);
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      final curentuser = FirebaseAuth.instance.currentUser;
      final snapshot = await FirebaseFirestore.instance
          .collection("new")
          .doc(curentuser!.uid)
          .get();
      if (snapshot.exists) {
        var pref =await  SharedPreferences.getInstance();
        pref.setBool('login', true);
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return HomeScreen();
          },
        ));
      } else {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return WelcomeScreen(name: '', phone:widget.Mob_no, mail: '',);
          },
        ));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verifynumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
         decoration: const BoxDecoration(
           gradient:LinearGradient(colors:[
             Colors.blueGrey,
             Colors.cyanAccent,
             Colors.blueAccent,
             Colors.lightBlueAccent,
             Colors.blueGrey
           ],
           begin: Alignment.topLeft,
           end: Alignment.bottomRight)
         ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
              width: 300,
              child: Column(
                children: [
                  Text("Welcome",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text("Sign up /Log into Continue",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black))
                ],
              ),
            ),
            const SizedBox(
              height: 50,
              width: 300,
              child: Center(
                child: Text("Enter the 6 digit Otp",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: PinCodeTextField(
                keyboardType: TextInputType.number,
                pinTheme: PinTheme.defaults(
                  fieldHeight:60,
                    fieldWidth:50,
                    activeFillColor: Colors.black,
                    selectedColor: Colors.cyanAccent,
                    inactiveColor:Colors.white,
                    errorBorderColor: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                    shape: PinCodeFieldShape.box),
                obscureText:true,
                appContext: context,
                length: 6,
                controller: _otpput,
                onCompleted: (v) {
                  setState(() {
                    smsCode = _otpput.text;
                  });
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  submitOtp();
                },
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(100, 50),
                    backgroundColor: Colors.purple,
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Text("Verify",
                    style: TextStyle(fontSize: 20, color: Colors.white)))
          ],
        ),
      ),
    );
  }
}
