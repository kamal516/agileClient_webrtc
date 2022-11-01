import 'dart:io';

import 'package:flutter/material.dart';
import 'package:newagileapp/applisignin/apple_available.dart';
import 'package:newagileapp/applisignin/authservice.dart';
import 'package:newagileapp/applisignin/signin.dart';
import 'package:newagileapp/dd.dart';


import 'package:newagileapp/screens/splashscreen.dart';
import 'package:newagileapp/screens/webview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
void main() async{
   HttpOverrides.global = new MyHttpOverrides();
     WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
 // final appleSignInAvailable = await AppleSignInAvailable.check();
 //  runApp(Provider<AppleSignInAvailable>.value(
 //    value: appleSignInAvailable,
 //    child: MyApp(),
 //  ));
 runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      // Provider<AuthService>(
      // create: (_) => AuthService(),
      // child:
      MaterialApp(
        title: 'Apple Sign In with Firebase',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: SplashScreen()
        //SignInPage(),
      // ),
    );
//     MaterialApp(
//       debugShowCheckedModeBanner: false,
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//         ),
//         home: 
// SplashScreen()
//  );
  }
}
