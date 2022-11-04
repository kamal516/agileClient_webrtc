import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doctoragileapp/color.dart';
import 'package:doctoragileapp/screens/chatlistscreen.dart';
import 'package:doctoragileapp/triage/calendarscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api.dart';
import '../homescreen.dart';

class Alertbox extends StatelessWidget {
  final List getdisclaimer;
  final String apptoken;
  const Alertbox({
    Key key,
    this.getdisclaimer,
    this.apptoken,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShowAlertbox(getdisclaimer: getdisclaimer, apptoken: apptoken);
  }
}

class ShowAlertbox extends StatefulWidget {
  final List getdisclaimer;
  final String apptoken;
  const ShowAlertbox({Key key, this.getdisclaimer, this.apptoken})
      : super(key: key);

  @override
  _ShowAlertboxState createState() => _ShowAlertboxState();
}

class _ShowAlertboxState extends State<ShowAlertbox> {
  @override
  void initState() {
    super.initState();
    _localuserid();
  }

  DateTime dateTime = DateTime.now();
  int selectdont = 0;
  int selectagree;
  @override
  Widget build(BuildContext context) {
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
              // width: 260.0,
              height: 250.0,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(67)),
              child: SingleChildScrollView(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      (widget.getdisclaimer != null &&
                              widget.getdisclaimer.length > 0)
                          ? widget.getdisclaimer[0]['description']
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Checkbox(
                  value: _checked,
                  onChanged: (bool value) {
                    setState(() {
                      _checked = value;
                    });
                  }),
              // SizedBox(width: 2,),
              Text(
                "Do not show this type of \ndisclaimer again",
                style: TextStyle(fontSize: 12),
              )
            ],
          )
        ],
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          RaisedButton(
              color: buttonColor,
              child: Text(
                'I AGREE',
                style: TextStyle(color: buttonTextColor),
              ),
              onPressed: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();

                if (_localtoken == null) {
                  preferences.setString('token', widget.apptoken);
                  _diclaimeruser("OK");
                } else {
                  _diclaimeruser("OK");
                }
                await http.post(apipath + '/doNotShowDisclaimer', body: {
                  "user_id": _userid,
                  "show_disclaimer": _checked.toString(),
                  'timezone': dateTime.timeZoneName
                  // "appointment_date": widget.appointment_datetime.toString(),
                  // "client_name": name.text,
                  // "client_address": address.text,
                }).then((vl) async {
                  print(vl);
                });
                //  Navigator.pushReplacement(context, MaterialPageRoute(builder:  (context)=>Chatscreen()));
              }),
          RaisedButton(
              color: disclaimeridontButtonColor,
              child: Text(
                'I DON' "T" '',
                style: TextStyle(color: buttonTextColor),
              ),
              onPressed: () {
                if (_localtoken == null) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Upcomingappointment()),
                      (route) => false);
                }

                //   Navigator.pop(context);
              })
        ],
      ),
    );
  }

  String _userid;
  String _username;
  String _localtoken;
  bool _checked = false;
  _localuserid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _userid = preferences.getString("id");
      _username = preferences.getString("name");
      _localtoken = preferences.getString("token");
    });
  }

  List disclaimeruser;

  _diclaimeruser(action) async {
    await http.post(apipath + '/insertDisclaimerUserLog', body: {
      "disclaimer_id": widget.getdisclaimer[0]['disclaimer_id'].toString(),
      "user_id": _userid.toString(),
      "comment": widget.getdisclaimer[0]['title'],
      "action": action,
      "type": widget.getdisclaimer[0]['disclaimer_position'],
      'timezone': dateTime.timeZoneName
    }).then((result) async {
      print(result.body);
      setState(() {
        disclaimeruser = jsonDecode(result.body);
      });
      print(disclaimeruser);
      if (disclaimeruser[0]['type'] == 'chat') {
        return Navigator.push(
            context, MaterialPageRoute(builder: (context) => Chatscreen()));
      } else if (disclaimeruser[0]['type'] == 'calendar') {
        return Navigator.push(
            context, MaterialPageRoute(builder: (context) => Calendarscreen()));
      } else if (disclaimeruser[0]['type'] == 'post-login') {
        if (widget.apptoken != null) {
          return Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      Upcomingappointment(user_name: _username)),
              (Route<dynamic> route) => false);
        }
      }
    });
  }
}
