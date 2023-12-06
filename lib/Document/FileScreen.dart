import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class FiledowloadScreen extends StatefulWidget {
  const FiledowloadScreen({super.key});

  @override
  State<FiledowloadScreen> createState() => _FiledowloadScreenState();
}

class _FiledowloadScreenState extends State<FiledowloadScreen> {
  Future downloadFile(String url, String type) async {
    Dio dio = Dio();

    await Permission.storage.isDenied.then((value) async {
      await Permission.storage.request();
    });

    try {
      Directory? directory = Directory('/storage/emulated/0/Download');
      if (await directory.exists()) {
        // directoryapplevel = await getExternalStorageDirectory();
        print(directory.path);
        await dio
            .download(
          url,
          '${directory.path}/newvideo.$type',
        )
            .then((value) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "Download Successfully ${'${directory.path}/newvideo.$type'}")));
        });
      }
      print(directory);
    } catch (e) {

      print(e);
    }
    // print("Download completed");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // downloadFile("https://firebasestorage.googleapis.com/v0/b/schoolapp-27136.appspot.com/o/files%2FTrending%20Folk%20Dance%20%E2%9D%A4%20%23dsa%20%23dsadancecompany%20%23coimbatore%20For%20classes%20contact8072481816.mp4?alt=media&token=001cad74-d330-4533-96f1-c6056248ede3");
    // downloadFile("https://firebasestorage.googleapis.com/v0/b/schoolapp-27136.appspot.com/o/Syllabus%2FGST-CHALLAN.pdf?alt=media&token=59796274-26a4-4280-b9d7-ed0a45c524b8");
    // downloadFile("https://firebasestorage.googleapis.com/v0/b/schoolapp-27136.appspot.com/o/AdminIdImage%2Fimage_picker1170284923.jpg?alt=media&token=3af4a49d-89bc-4ad8-9d0f-7871823e8847");
  }

  void getpermission() async {
    var status = await Permission.storage.status;

    await Permission.storage.request();

    print(status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            getpermission();
          },
          child: const Text("Permission"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // downloadFile("https://firebasestorage.googleapis.com/v0/b/schoolapp-27136.appspot.com/o/Question%2FLehengas%20Lookbook-%20Label%20Vida%20sale.pdf?alt=media&token=2fd9461f-149d-43ac-8fa7-fb26505e97f1",'pdf');
          /*  downloadFile(
              "https://firebasestorage.googleapis.com/v0/b/schoolapp-27136.appspot.com/o/AdminProfileImage%2F9cb60960d0e24f97aa1d8da5a74d10af.jpeg?alt=media&token=81734432-1083-4bad-8753-a6943e2873db",
              'png');*/
          downloadFile(
              "",'mp4');
        },
      ),
      // body: Image.network("https://firebasestorage.googleapis.com/v0/b/schoolapp-27136.appspot.com/o/AdminIdImage%2Fimage_picker1170284923.jpg?alt=media&token=3af4a49d-89bc-4ad8-9d0f-7871823e8847"),
    );
  }
}
