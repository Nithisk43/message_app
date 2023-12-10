import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class DymamicLinkPage extends StatefulWidget {
  const DymamicLinkPage({super.key});

  @override
  State<DymamicLinkPage> createState() => _DymamicLinkPageState();
}

class _DymamicLinkPageState extends State<DymamicLinkPage> {
  static Future<String> createDynamicLink(
      bool short,
      ) async {
    String linkMessage;

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://fbdemo12.page.link',
      link: Uri.parse('https://www.google.com/'),
      // link: Uri.parse('https://www.giventa.in/?page=Groups&id=GA0001&postid=xyz'),
      androidParameters: const AndroidParameters(
        packageName: 'com.example.message_app',
        minimumVersion: 0,
      ),
      // iosParameters: const IOSParameters(bundleId: "com.example.message_app",appStoreId: "6464373409"),
    );

    Uri? url;
    if (short) {
      // final ShortDynamicLink shortLink = await parameters.buildShortLink();
      var d = await FirebaseDynamicLinks.instance.buildLink(parameters);

      // final ShortDynamicLink shortLink = await d;
      // url = shortLink.shortUrl;
      print('sdfvgbhnm');
      print("Url :"+d.toString());
    } else {
      // url = await parameters.buildUrl();
    }

    linkMessage = url.toString();
    return linkMessage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          createDynamicLink(true);
        },
      ),
    );
  }
}


