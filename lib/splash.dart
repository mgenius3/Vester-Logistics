import 'package:vester/Assistants/assistant_method.dart';
import 'package:flutter/material.dart';
import 'package:vester/app/landing_page.dart';
import 'package:vester/services/auth.dart';
import 'package:vester/services/auth.dart';
import 'dart:async';
import "package:firebase_auth/firebase_auth.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vester/app/auth/signIn/email_sign_in_page.dart';
import 'package:vester/app/sub_screens/map_screen.dart';
import 'package:vester/app/sub_screens/search_places_screen.dart';
import 'package:provider/provider.dart';
import './infoHandler/app_info.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final auth = Auth();

  startTimer() {
    Timer(Duration(seconds: 3), () async {
      Provider.of<AppInfo>(context, listen: false)
          .updateDropOffLocationAddress(null);
      Provider.of<AppInfo>(context, listen: false)
          .updatePickUpLocationAddress(null);

      if (await FirebaseAuth.instance.currentUser != null) {
        FirebaseAuth.instance.currentUser != null
            ? AssistantMethods.readCurrentOnlineUserInfo()
            : null;
        Navigator.push(context, MaterialPageRoute(builder: (c) => MapScreen()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => EmailSignInPage()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // _navigatetohome();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/logo.png', // Replace with the path to your image
              fit: BoxFit.cover, // Adjust the image fit as needed
            ),
          ],
        ),
      ),
    );
  }
}
