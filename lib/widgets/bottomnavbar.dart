import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:doctoragileapp/color.dart';
import 'package:doctoragileapp/screens/chatlistscreen.dart';
import 'package:doctoragileapp/categories.dart';
import 'package:doctoragileapp/triage/calendarscreen.dart';
import 'package:doctoragileapp/screens/login.dart';
import 'package:doctoragileapp/homescreen.dart';
import 'package:doctoragileapp/widgets/Alertbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../api.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      key: key,
    );
  }
}

//    gethomebutton(BuildContext context){
//   double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
//  double multiplier = 2;
//  return Text(
//   'HOME', style: TextStyle( color: Colors.white,
//     fontSize: multiplier * unitHeightValue,
//   ),
//  );
//   }
//    getcalendarbutton(BuildContext context){
//   double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
//  double multiplier = 2;
//  return Text(
//   'CALENDAR', style: TextStyle( color: Colors.white,
//     fontSize: multiplier * unitHeightValue,
//   ),
//  );
//   }
//     getservicebutton(BuildContext context){
//   double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
//  double multiplier = 2;
//  return Text(
//   'SERVICES', style: TextStyle( color: Colors.white,
//     fontSize: multiplier * unitHeightValue,
//   ),
//  );
//   }
//     getchatbutton(BuildContext context){
//   double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
//  double multiplier = 2;
//  return Text(
//   'CHAT', style: TextStyle( color: Colors.white,
//     fontSize: multiplier * unitHeightValue,
//   ),
//  );
//   }
class BottomNavigationBar extends StatefulWidget {
  const BottomNavigationBar({
    Key key,
  }) : super(key: key);

  @override
  _BottomNavigationBarState createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBar> {
  @override
  void initState() {
    super.initState();
    _localuserid();
  }

  bool _clicked = false;
  bool _homeScreen;
  bool _serviceScreen;
  bool _chatScreen;
  bool _eventScreen;
  @override
  Widget build(BuildContext context) {
    return
        //SingleChildScrollView(scrollDirection: Axis.horizontal,child:
        BottomAppBar(
            child: new Container(
      // width: MediaQuery.of(context).size.width * 140/100,
      decoration: BoxDecoration(
        border: Border.all(color: buttonColor),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          colors: [buttonColor, buttonColor],
        ),
      ),
      height: 80,

      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
              width: 75,
              child: RaisedButton(
                color: buttonColor,
                onPressed: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  _homeScreen = preferences.getBool("HomePage");
                  if (_homeScreen != true) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Upcomingappointment()));
                  } else {
                    return;
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //  SvgPicture.asset('assets/homeicon.svg',),
                    Icon(
                      Icons.home_outlined,
                      color: iconColor,
                      size: 28.0,
                    ),
                    //  gethomebutton(context)
                    Text(
                      "HOME",
                      style: TextStyle(color: buttonTextColor, fontSize: 12),
                    ),
                  ],
                ),
              )),
          //
          RaisedButton(
            color: buttonColor,
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              _eventScreen = preferences.getBool("EventPage");
              if (_eventScreen != true) {
                _setdisclaimar("calendar");
              } else {
                return;
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.calendar_today_outlined,
                  size: 25.0,
                  color: iconColor,
                ),
                //   getcalendarbutton(context)
                //Image.asset('assets/Appointment.png'),

                // SvgPicture.asset('assets/appointment.svg'),
                Text("CALENDAR",
                    style: TextStyle(color: buttonTextColor, fontSize: 12)),
              ],
            ),
          ),
          RaisedButton(
            color: buttonColor,
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              _serviceScreen = preferences.getBool("ServicePage");
              if (_serviceScreen != true) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Categoryset()));
              } else {
                return;
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/Triage.png'),
                // getservicebutton(context)
                // SvgPicture.asset('assets/service.svg'),
                Text("SERVICES",
                    style: TextStyle(color: buttonTextColor, fontSize: 12)),
              ],
            ),
          ),
          Container(
              width: 70,
              child: RaisedButton(
                color: buttonColor,
                onPressed: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  _chatScreen = preferences.getBool("ChatPage");
                  if (_chatScreen != true) {
                    _setdisclaimar("chat");
                  } else {
                    return;
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/Chat.png'),
                    //getchatbutton(context)
                    // SvgPicture.asset('assets/chat.svg'),
                    Text("CHAT",
                        style: TextStyle(color: buttonTextColor, fontSize: 12)),
                  ],
                ),
              ))
        ],
      ),
      // )
    ));
  }

  DateTime dateTime = DateTime.now();

  List disclaimer;
  _setdisclaimar(type) async {
    await http.post(apipath + '/getDisclaimer', body: {
      "disclaimer_position": type,
      "user_id": _userid,
      'timezone': dateTime.timeZoneName
    }).then((result) async {
      print(result.body);
      setState(() {
        disclaimer = jsonDecode(result.body);
      });

      print(disclaimer);
      if (disclaimer[0]['msg'] == 'chat') {
        return Navigator.push(
            context, MaterialPageRoute(builder: (context) => Chatscreen()));
      }
      if (disclaimer[0]['msg'] == 'calendar') {
        return Navigator.push(
            context, MaterialPageRoute(builder: (context) => Calendarscreen()));
      } else if (disclaimer != null) {
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return Alertbox(getdisclaimer: disclaimer);
            }); //  _onSubmit(context);
      }
    });
  }

// cALENDER

  List calenderdisclaimer;
  _setcalenderdisclaimar() async {
    await http.post(apipath + '/getDisclaimer', body: {
      "disclaimer_position": "chat",
      'timezone': dateTime.timeZoneName
    }).then((result) async {
      print(result.body);
      setState(() {
        calenderdisclaimer = jsonDecode(result.body);
      });
      print(calenderdisclaimer);
      if (calenderdisclaimer[0]['msg'] == 'empty') {
        return Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Chatscreen()));
      } else if (calenderdisclaimer != null) {
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Alertbox(getdisclaimer: calenderdisclaimer);
            });
        //  _onSubmit(context);
      }
    });
  }

  String _userid;
  bool _checked;
  _localuserid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _userid = preferences.getString("id");
      _checked = preferences.getBool("checkedDesclaimer");
    });
  }
}
