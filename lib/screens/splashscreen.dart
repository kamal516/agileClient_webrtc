// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doctoragileapp/color.dart';
import 'package:doctoragileapp/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api.dart';
import '../homescreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return initScreen(context);
  }

  // ignore: non_constant_identifier_names
  String app_token;
  @override
  void initState() {
    super.initState();
    startTimer();
    getappid();
  }

  // ignore: non_constant_identifier_names
  String app_tokenid;
  // ignore: non_constant_identifier_names
  String login_token;
  // ignore: non_constant_identifier_names
  String user_name;
  getappid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      app_tokenid = preferences.getString("appidtoken");
      login_token = preferences.getString("token");
      user_name = preferences.getString("name");
    });
    _setdisclaimar();
  }

  startTimer() async {
    var duration = Duration(seconds: 3);
    return new Timer(duration, route);
  }

  List disclaimer;
  _setdisclaimar() async {
    await http.post(apipath + '/getDisclaimer',
        body: {"disclaimer_position": 'pre-login'}).then((result) async {
      // print(result.body);
      setState(() {
        disclaimer = jsonDecode(result.body);
      });

      // print(disclaimer);
      //     if(login_token!=null){
      //       return
      //  Navigator.of(context).pushAndRemoveUntil(
      //             MaterialPageRoute(
      //                 builder: (BuildContext context) =>
      //                     Upcomingappointment(user_name:user_name)),
      //             (Route<dynamic> route) => false);
      //     }
      if (disclaimer != null) {
        return route();
        //  _onSubmit(context);
      }
    });
  }

  route() {
    if (login_token != null) {
      return Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  Upcomingappointment(user_name: user_name)),
          (Route<dynamic> route) => false);
    }
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: Column(
              children: <Widget>[
                Container(
                  child: Text('TITLE'),
                ),
                Divider(color: dividerColor),
                SizedBox(
                  height: 20,
                ),
                Container(
                    width: 260.0,
                    height: 300.0,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(67)),
                    child: SingleChildScrollView(
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            (disclaimer != null && disclaimer.length > 0)
                                ? disclaimer[0]['description']
                                : "",
                            style: TextStyle(
                                color: disclaimerTextcolor,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.justify,
                          )
                        ],
                      ),
                    )),
              ],
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                    color: buttonColor,
                    child: Text(
                      'OK',
                      style: TextStyle(color: buttonTextColor),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Loginpage()));
                    }),
              ],
            ),
          );
        });
  }

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  initScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
                color: backgroundColor,
                child: Image.asset('assets/Splash.png')),
            Text(
              'Version - 1.1',
              style: TextStyle(color: textColor),
            )
          ],
        ),
      ),
    );
  }
}
