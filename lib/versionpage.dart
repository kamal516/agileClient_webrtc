import 'package:flutter/material.dart';
import 'package:doctoragileapp/color.dart';

class Versionpage extends StatefulWidget {
  @override
  _VersionpageState createState() => _VersionpageState();
}

class _VersionpageState extends State<Versionpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: buttonColor,
        title: Text('About app'),
      ),
      body: Container(
          child: Center(
              child: Text(
        'Version - 1.1',
        style: TextStyle(color: blackTextColor, fontSize: 22),
      ))),
    );
  }
}
