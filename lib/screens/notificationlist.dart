import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:doctoragileapp/api.dart';
import 'package:doctoragileapp/color.dart';
import 'package:http/http.dart' as http;

import 'package:doctoragileapp/screens/showappointment.dart';
import 'package:doctoragileapp/homescreen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Notificationlist extends StatefulWidget {
  @override
  _TestcatState createState() => _TestcatState();
}

class _TestcatState extends State<Notificationlist>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    getid();
    startTimer();
  }

  void deactivate() {
    if (_timer.isActive) {
      _timer.cancel();
    } else {
      startTimer();
    }
    super.deactivate();
  }

  List<Map> messageslist;

  void startTimer() {
    _timer = new Timer.periodic(new Duration(seconds: 1), (time) {
      _getmessage();
    });
  }

  Timer _timer;

  String _localid;
  getid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _localid = preferences.getString("id");
    });
    _getmessage();
  }

  List fetchmeassagedata;
  String messagedata;
  int modifyList;
  int donelist;
  DateTime dateTime = DateTime.now();
  TextEditingController message = new TextEditingController();

  Future<List> _getmessage() async {
    final response = await http.post(apipath + '/getNotification', body: {
      "user_id": _localid,
      'timezone': dateTime.timeZoneName
    }).then((result) async {
      print(result.body);
      setState(() {
        fetchmeassagedata = jsonDecode(result.body);
      });

      print(fetchmeassagedata);
    });
  }

  _markmessage(int chat_notification_id) async {
    final response = await http.post(apipath + '/updateNotification', body: {
      "notification_id": chat_notification_id.toString(),
      'timezone': dateTime.timeZoneName
    }).then((value) {});
  }

  _readall(BuildContext context) async {
    final response = await http.post(apipath + '/updateallnotification', body: {
      "user_id": _localid,
      'timezone': dateTime.timeZoneName
    }).then((value) {
      fetchmeassagedata.clear();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Upcomingappointment()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: RaisedButton(
            child: Text(
              'CLEAR ALL',
              style: TextStyle(color: buttonTextColor),
            ),
            onPressed: () {
              _readall(context);
            },
            color: buttonColor,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              top: 5,
            ),
            child: new Container(
                decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(40.0),
                  topRight: const Radius.circular(40.0),
                  bottomLeft: const Radius.circular(1.0),
                  bottomRight: const Radius.circular(1.0),
                )),
                padding: EdgeInsets.only(
                  top: 0,
                ),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 73,
                            width: 40,
                            decoration: new BoxDecoration(
                                color: buttonColor,
                                borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(40.0),
                                  topRight: const Radius.circular(40.0),
                                )),
                            child: Row(children: <Widget>[
                              IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: buttonTextColor,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              // SizedBox(
                              //   width: 80,
                              // ),
                              Center(
                                  child: Text(
                                'NOTIFICATIONS',
                                style: TextStyle(
                                    color: buttonTextColor, fontSize: 16),
                              )),
                            ]),
                          ),
                        ]),
                    Container(
                        height: (MediaQuery.of(context).size.height - 140),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.only(top: 0),
                        child: Container(
                            height: 400,
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: ListView.builder(
                                itemCount: fetchmeassagedata == null
                                    ? 0
                                    : fetchmeassagedata.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return new SlideMenu(
                                    child: new Card(
                                      elevation: 10,
                                      color: greyContainer,
                                      semanticContainer: true,
                                      child: ListTile(
                                          title: Text(
                                            fetchmeassagedata[index]
                                                        ['username'] ==
                                                    null
                                                ? ''
                                                : fetchmeassagedata[index]
                                                    ['username'],
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: blackTextColor,
                                                fontSize: 16),
                                          ),
                                          subtitle: Text(
                                            fetchmeassagedata[index]
                                                        ['messagesummary'] ==
                                                    null
                                                ? ''
                                                : fetchmeassagedata[index]
                                                    ['messagesummary'],
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: blackTextColor,
                                                fontSize: 13),
                                          ),
                                          trailing: Padding(
                                              padding: EdgeInsets.only(top: 0),
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    child: Text(
                                                      DateFormat(
                                                              '  d MMMM ,  hh:mm a')
                                                          .format(DateTime.parse(fetchmeassagedata[
                                                                              index]
                                                                          [
                                                                          'created_at'] ==
                                                                      null
                                                                  ? ''
                                                                  : fetchmeassagedata[
                                                                          index]
                                                                      [
                                                                      'created_at'])
                                                              .toLocal()),
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          color: blackTextColor,
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      '',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          color: blackTextColor,
                                                          fontSize: 14),
                                                    ),
                                                  )
                                                ],
                                              ))),
                                    ),
                                    menuItems: <Widget>[
                                      GestureDetector(
                                          onTap: () {
                                            _markmessage(
                                                fetchmeassagedata[index]
                                                    ['notification_id']);
                                          },
                                          child: Container(
                                            color: buttonColor,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Image.asset(
                                                  'assets/delete2.jpg',
                                                ),
                                                Text(
                                                  "READ",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: buttonTextColor),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ],
                                  );
                                }))),
                  ],
                )),
          ),
        ));
  }
}
