import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:doctoragileapp/dd.dart';
import 'package:doctoragileapp/screens/login.dart';

class testLogingoogle extends StatefulWidget {
  final GoogleSignInAccount name;
  testLogingoogle({this.name});

  @override
  _testLogingoogleState createState() => _testLogingoogleState();
}

class _testLogingoogleState extends State<testLogingoogle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name.displayName),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Loginpage()));
              },
              icon: Icon(Icons.power_settings_new_rounded))
        ],
      ),
    );
  }
}
