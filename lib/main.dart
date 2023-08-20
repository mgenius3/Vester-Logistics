import 'package:flutter/material.dart';
import 'package:vester/app/landing_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:vester/services/auth.dart';
import 'package:vester/splash.dart';

import 'infoHandler/app_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(VesterDriver());
}

class VesterDriver extends StatelessWidget {
  const VesterDriver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MaterialColor customPrimarySwatch = MaterialColor(
      0xFFFF3131,
      <int, Color>{
        50: Color(0xFFFFE3E3), // Pale Red
        100: Color(0xFFFFC1C1), // Pale Red
        200: Color(0xFFFF9E9E), // Pale Red
        300: Color(0xFFFF7B7B), // Pale Red
        400: Color(0xFFFF5A5A), // Pale Red
        500: Color(0xFFFF3939), // Pale Red
        600: Color(0xFFFF3131), // Pale Red
        700: Color(0xFFFF2828), // Pale Red
        800: Color(0xFFFF2020), // Pale Red
        900: Color(0xFFFF1717), // Pale Red
      },
    );

    return ChangeNotifierProvider(
        create: (context) => AppInfo(),
        child: MaterialApp(
          title: 'Vester',
          theme: ThemeData(
            primaryColor: Color(0xFFFF1717),
            accentColor: Colors.orange,
            primarySwatch: customPrimarySwatch,
          ),
          debugShowCheckedModeBanner: false,
          home: Splash(),
        ));
  }
}
