import 'package:flutter/material.dart';
import 'package:newagileapp/screens/login.dart';

import 'package:newagileapp/homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Rootpage extends StatefulWidget {
  final String app_id;
  Rootpage({this.app_id});
  @override
  _RootpageState createState() => _RootpageState();
}

enum AuthStatus { notsignIn, signIn }

class _RootpageState extends State<Rootpage> {
  AuthStatus authStatus = AuthStatus.notsignIn;
  SharedPreferences localStorage;
  String token = '';
  bool signin = false;
  bool signout = false;
  void _getdata() async {
    localStorage = await SharedPreferences.getInstance();
    setState(() {
      authStatus = localStorage.getString("token") == null
          ? AuthStatus.notsignIn
          : AuthStatus.signIn;
    });
  }

  @override
  void initState() {
    super.initState();
    _getdata();
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signIn;
    });
  }

  void _signOut() {
    setState(() {
      authStatus = AuthStatus.notsignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notsignIn:
        return new Loginpage(token_appid: widget.app_id);
      case AuthStatus.signIn:
        return new Upcomingappointment();
    }
  }
}
