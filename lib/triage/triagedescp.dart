import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:doctoragileapp/api.dart';
import 'package:doctoragileapp/color.dart';
import 'package:http/http.dart' as http;
import 'package:doctoragileapp/screens/login.dart';
import 'package:doctoragileapp/triage/calendarscreen.dart';
import 'package:doctoragileapp/triage/doctorlisttriage.dart';
import 'package:doctoragileapp/triage/questiontriage.dart';
import 'package:doctoragileapp/homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doctoragileapp/widgets/bottomnavbar.dart';

class Triagedescription extends StatefulWidget {
  final int id;
  final String cat;
  final String desc;
  final String image;
// final Question qst;
  Triagedescription(
      {Key key, @required this.id, this.desc, this.image, this.cat})
      : super(key: key);
  @override
  _TestcatState createState() => _TestcatState();
}

class _TestcatState extends State<Triagedescription> {
  num total = 0;
  String _catgy(dynamic user) {
    return user['question'];
  }

  bool pressed = false;
  String _moredetail(dynamic user) {
    return user['description'] + "\n" + user['short_description'];
  }

  final AsyncMemoizer _memoizer = AsyncMemoizer();
  String _desc(dynamic user) {
    return user['description'];
  }

  String option = '';
  String selectedoption = '';
  String catdesc;
  String apiUrl = apipath + '/triage_questions/';
  //  "http://192.168.1.6:3040/triage_questions/";

  fetchquestion() {
    var results = this._memoizer.runOnce(() async {
      var result = await http.get(apiUrl + widget.id.toString());
      print(result.body);
      return json.decode(result.body);
      // description
    });
    return results;
  }

  void initState() {
    super.initState();
    _tokenget();
  }

  String _token;
  _tokenget() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _token = preferences.getString("token");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      body: SingleChildScrollView(
          child: Container(
        //padding: EdgeInsets.only(top: 15),
        // color: kPrimaryDarkColor,
        child: new Container(
            decoration: new BoxDecoration(
                // color: kPrimaryLightColour,
                borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(40.0),
              topRight: const Radius.circular(40.0),
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
                        decoration: new BoxDecoration(
                            color: buttonColor,
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(40.0),
                              topRight: const Radius.circular(40.0),
                            )),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              //  IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,), onPressed: (){
                              //    Navigator.pop(context);
                              //  }),
                              // SizedBox(width: 150,),
                              Text(
                                'TRIAGE',
                                style: TextStyle(
                                    color: buttonTextColor, fontSize: 19),
                              ),

                              // IconButton(icon: Icon(Icons.power_settings_new,color: Colors.white,), onPressed: null),
                            ]),
                      ),
                    ]),
                SizedBox(height: 20),
                Container(
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(),
                    color: greyContainer,
                  ),
                  padding: EdgeInsets.only(top: 1, left: 10, right: 10),
                  child: Row(
                    children: <Widget>[
                      Container(
                          height: 110,
                          width: 80,
                          decoration: BoxDecoration(
                            color: greyContainer,
                            borderRadius: BorderRadius.vertical(),
                          ),
                          padding: EdgeInsets.only(top: 30, bottom: 25),
                          child: SvgPicture.network(widget.image)),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(

                          // color: kPrimaryLightColour,
                          child: Text(
                        widget.cat,
                        style: TextStyle(
                          fontSize: 22,
                        ),
                        overflow: TextOverflow.fade,
                        maxLines: 2,
                      )),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30, left: 12, right: 12),
                  child: Text(
                    widget.desc,
                    style: TextStyle(fontSize: 17, color: blackTextColor),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 20, left: 12, right: 12),
                    // child: Container(
                    //   height: 40,
                    //   color: kPrimaryDarkColor,
                    child: RaisedButton(
                      child: Text(
                        'Start Analysis',
                        style: TextStyle(color: buttonTextColor),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QuestionList(
                                    id: widget.id,
                                    cat: widget.cat,
                                    desc: widget.desc)));
                      },
                      color: buttonColor,
                      // ),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 0, left: 12, right: 12),
                    child: RaisedButton(
                      child: Text(
                        'Back',
                        style: TextStyle(color: buttonTextColor),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: buttonColor,
                    ))
              ],
            )),
      )),
    );
  }
}
