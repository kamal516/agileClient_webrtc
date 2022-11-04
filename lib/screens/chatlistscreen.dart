import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:doctoragileapp/api.dart';
import 'package:doctoragileapp/color.dart';
import 'package:http/http.dart' as http;
import 'package:doctoragileapp/screens/chatlist.dart';
import 'package:doctoragileapp/widgets/bottomnavbar.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Chatscreen extends StatefulWidget {
  @override
  _TestcatState createState() => _TestcatState();
}

class _TestcatState extends State<Chatscreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    getid();
    _getScreen();
  }

  bool _homeScreen = false;
  bool _chatScreen;
  bool _serviceScreen = false;
  bool _eventScreen = false;

  _getScreen() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _chatScreen = true;
    });
    preferences.setBool("HomePage", _homeScreen);
    preferences.setBool("ChatPage", _chatScreen);
    preferences.setBool("ServicePage", _serviceScreen);
    preferences.setBool("EventPage", _eventScreen);
  }

  String _localid;
  getid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _localid = preferences.getString("id");
    });
    _getchatlist();
  }

  List alldocotor;
  DateTime dateTime = DateTime.now();

  Future<List> _getchatlist() async {
    final response = await http.post(apipath + '/getChatListScreenData', body: {
      "user_id": _localid,
      'timezone': dateTime.timeZoneName
    }).then((result) async {
      print(result.body);
      setState(() {
        alldocotor = jsonDecode(result.body);
      });

      print(alldocotor);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavBar(),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 15, bottom: 0.3),
            // color: Color(0xFF666B7E),
            child: new Container(
                decoration: new BoxDecoration(
                    // color: Colors.white,
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
                              SizedBox(
                                width: 80,
                              ),
                              Text(
                                'CHAT LIST',
                                style: TextStyle(
                                    color: buttonTextColor, fontSize: 19),
                              ),
                            ]),
                          ),
                        ]),
                    Container(
                        height: (MediaQuery.of(context).size.height - 100),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.only(top: 0),
                        child: Container(
                            height: 400,
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: ListView.builder(
                                itemCount:
                                    alldocotor == null ? 0 : alldocotor.length,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  List<dynamic> user = alldocotor;

                                  return Card(
                                      color: buttonColor,
                                      child: Row(
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              width: 75,
                                              height: 75,
                                              padding: EdgeInsets.only(left: 9),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: buttonColor,
                                              ),
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    containerBorderColor,
                                                child: ClipOval(
                                                    child: CachedNetworkImage(
                                                  imageUrl: user[index][
                                                              'user_profile'] ==
                                                          null
                                                      ? ""
                                                      : user[index]
                                                          ['user_profile'],
                                                  fit: BoxFit.fill,
                                                  width: 75.0,
                                                )),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: <Widget>[
                                                ListTile(
                                                  title: Text(
                                                    user[index]['username'] ==
                                                            null
                                                        ? ""
                                                        : user[index]
                                                            ['username'],
                                                    style: TextStyle(
                                                        color: buttonTextColor),
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Chatlist(
                                                                      holderid: user[index]
                                                                              [
                                                                              'from_user_id']
                                                                          .toString(),
                                                                      doctorname:
                                                                          user[index]
                                                                              [
                                                                              'username'],
                                                                    )));
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ));
                                }))),
                  ],
                )),
          ),
        ));
  }
}
