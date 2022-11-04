import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:doctoragileapp/api.dart';
import 'package:doctoragileapp/color.dart';
import 'package:http/http.dart' as http;
import 'package:doctoragileapp/screens/login.dart';
import 'package:doctoragileapp/doctorlist.dart';
import 'package:doctoragileapp/triage/calendarscreen.dart';
import 'package:doctoragileapp/triage/doctorlisttriage.dart';
import 'package:doctoragileapp/homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doctoragileapp/widgets/bottomnavbar.dart';

class QuestionList extends StatefulWidget {
  final int id;
  final String cat;
  final String desc;
// final Question qst;
  QuestionList({Key key, @required this.id, this.desc, this.cat})
      : super(key: key);
  @override
  _TestcatState createState() => _TestcatState();
}

class _TestcatState extends State<QuestionList> {
  var answerdata = {};
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
      body: Container(
        padding: EdgeInsets.only(top: 10),
        // color: kPrimaryDarkColor,
        child: new Container(
            decoration: new BoxDecoration(
                // color: Colors.white,
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
                            width: 100,
                          ),
                          Text(
                            widget.cat,
                            style:
                                TextStyle(color: buttonTextColor, fontSize: 19),
                          ),

                          // IconButton(icon: Icon(Icons.power_settings_new,color: Colors.white,), onPressed: null),
                        ]),
                      ),
                    ]),
//            SizedBox(height:0)
// ,Text(widget.desc),
                // Padding(padding: EdgeInsets.only(top:10),
                // child: Text(widget.desc),),
                Container(
                    height: (MediaQuery.of(context).size.height - 198),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: FutureBuilder(
                        future: fetchquestion(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if ((snapshot.connectionState ==
                                      ConnectionState.none &&
                                  snapshot.hasData == null) ||
                              snapshot.data == null) {
                            return Container();
                          }
                          if (snapshot.hasData) {
                            for (int i = 0; i <= snapshot.data.length; i++) {
                              print(snapshot.data);
                            }
                            if (snapshot.data == "No") {
                              return Center(
                                  child: Container(
                                padding: EdgeInsets.all(10),
                                height: 100,
                                width: 400,
                                child: Text(
                                  "Sorry! there is no data .",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ));
                            }
                            return ListView.builder(
                                padding: EdgeInsets.all(8),
                                itemCount: snapshot.data.length + 1,
                                itemBuilder: (BuildContext context, int index) {
                                  if (index < snapshot.data.length) {
                                    return Card(
                                      color: greyContainer,
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
//title: Text(widget.id.toString()),
                                            title: Text(
                                              _catgy(snapshot.data[index]),
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                          //  FlatButton(

                                          //       padding: EdgeInsets.only(),
                                          //       child:
                                          //           Text(_desc(snapshot.data[index]),

                                          //          ),
                                          //       onPressed: () {
                                          //         setState(() {
                                          //           pressed = true;
                                          //         });
                                          //       },
                                          //     ),

                                          // Row(

                                          //   children: <Widget>[
                                          //     Padding(
                                          //       padding: EdgeInsets.only(left: 15),
                                          //     ),
                                          //     pressed
                                          //         ? Text(_moredetail(
                                          //             snapshot.data[index]),
                                          //           )
                                          //         : SizedBox(),
                                          //   ],
                                          // ),
                                          ListView.builder(
                                              // scrollDirection: null,
                                              itemCount: snapshot
                                                  .data[index]['answers']
                                                  .length,
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder:
                                                  (BuildContext ct, int it) {
                                                selectedoption = snapshot
                                                    .data[index]['answers'][it]
                                                        ['answer']['weight']
                                                    .toString();
                                                return Column(
                                                  children: <Widget>[
                                                    RadioListTile(
                                                      activeColor: buttonColor,
                                                      title: Text(
                                                        snapshot.data[index]
                                                                    ['answers']
                                                                [it]['answer']
                                                            ['answer'],
                                                      ),
                                                      value: snapshot
                                                                  .data[index]
                                                              ['answers'][it]
                                                          ['answer']['weight'],
                                                      groupValue:
                                                          snapshot.data[index]
                                                              ['user_answer'],
                                                      onChanged: (val) {
                                                        setState(() {
                                                          snapshot.data[index][
                                                                  'user_answer'] =
                                                              val;

                                                          //  answerdata  =   { snapshot.data[index]['question']:snapshot.data[index]
                                                          //         ['answers'][it]
                                                          //     ['answer']['answer']}

                                                          // ;

                                                          print(snapshot.data[
                                                                          index]
                                                                      [
                                                                      'answers']
                                                                  [it]['answer']
                                                              ['weight']);
                                                        });
                                                        // for(int i = 0; i<=useranswerdata.length; i++){

                                                        // }

                                                        // useranswerdata.add(answerdata);
                                                        // print(useranswerdata);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              }),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return RaisedButton(
                                        color: buttonColor,
                                        child: Text(
                                          'Submit',
                                          style:
                                              TextStyle(color: buttonTextColor),
                                        ),
                                        onPressed: () {
                                          for (int j = 0;
                                              j < snapshot.data.length;
                                              j++) {
                                            total = total +
                                                snapshot.data[j]['user_answer'];
                                          }
                                          sendtotal();
                                        });
                                  }
                                });
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        })),
              ],
            )),
      ),
    );
  }

  DateTime dateTime = DateTime.now();
  List useranswerdata = [];
  sendtotal() async {
    await http.post(apipath + '/triage_result', body: {
      "total": total.toString(),
      "triage_test_id": widget.id.toString(),
      'timezone': dateTime.timeZoneName
    }).then((result) {
      print(result.body);

// return json.decode(result.body);

      return showDialog(
        context: context,
        builder: (BuildContext context) {
          Map<String, dynamic> user = jsonDecode(result.body);
          return AlertDialog(
            title: Text(user["action"]),
// content: const Text('This item is no longer available'),
            actions: [
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Calendarscreen()));
                },
              ),
            ],
          );
        },
      );
    });
  }
}
