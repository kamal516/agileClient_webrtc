import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:doctoragileapp/api.dart';
import 'package:doctoragileapp/color.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class Selfassess extends StatefulWidget {
  @override
  _TestcatState createState() => _TestcatState();
}

class _TestcatState extends State<Selfassess>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    getid();
  }

  bool monVal = false;
  bool tuVal = false;
  bool wedVal = false;
  bool thurVal = false;
  bool friVal = false;
  bool satVal = false;
  bool sunVal = false;

  String _mondaystarttime = "00:00";
  String _tuesdyastarttime = "00:00";
  String _wednesdaystarttime = "00:00";
  String _thursdaystarttime = "00:00";
  String _fridaystarttime = "00:00";
  String _saturdaystarttime = "00:00";
  String _sundaystarttime = "00:00";

  String _mondayendtime = "00:00";
  String _tuesdyaendtime = "00:00";
  String _wednesdayendtime = "00:00";
  String _thursdayendtime = "00:00";
  String _fridayendtime = "00:00";
  String _saturdayendtime = "00:00";
  String _sundayendtime = "00:00";

  String break_start_time = "00:00";
  String break_end_time = "00:00";

  String _localid;
  getid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _localid = preferences.getString("id");
    });
  }

  Future<List> _registeravailability() async {
    final response =
        await http.post(apipath + '/setavailabilityfordoctor', body: {
      "user_id": _localid,
      "title": "Timing",
      "description": "New week timing",
      "monday": monVal.toString(),
      "tuesday": tuVal.toString(),
      "wednesday": wedVal.toString(),
      "thursday": thurVal.toString(),
      "friday": friVal.toString(),
      "saturday": satVal.toString(),
      "sunday": sunVal.toString(),
      "monday_start_time": _mondaystarttime,
      "monday_end_time": _mondayendtime,
      "tuesday_start_time": _tuesdyastarttime,
      "tuesday_end_time": _tuesdyaendtime,
      "wednesday_start_time": _wednesdaystarttime,
      "wednesday_end_time": _wednesdayendtime,
      "thursday_start_time": _thursdaystarttime,
      "thursday_end_time": _thursdayendtime,
      "friday_start_time": _fridaystarttime,
      "friday_end_time": _fridayendtime,
      "saturday_start_time": _saturdaystarttime,
      "saturday_end_time": _saturdayendtime,
      "sunday_start_time": _sundaystarttime,
      "sunday_end_time": _sundayendtime,
      "break_start_time": break_start_time,
      "break_end_time": break_end_time,
      "availability_till": "08:00:00"
    }).then((value) async {
      print(value.body);
      var body = json.decode(value.body);
      setState(() {});
      SharedPreferences localStorage = await SharedPreferences.getInstance();

      localStorage.setInt('localid', body['user_id']);
      localStorage.setString('token', body['token']);
      localStorage.setString('name', body['username']);
      localStorage.setString('adrs', body['address1']);
    });
  }

  Widget checkbox(String title, bool boolValue) {
    return Row(
      children: <Widget>[
        Text(title),
        Padding(
            padding: EdgeInsets.only(left: 15),
            child: Checkbox(
              value: boolValue,
              onChanged: (bool value) {
                setState(() {
                  switch (title) {
                    case "Monday      ":
                      monVal = value;

                      break;
                    case "Tuesday      ":
                      tuVal = value;

                      break;
                    case "Wednesday":
                      wedVal = value;

                      break;
                    case "Thursday    ":
                      thurVal = value;

                      break;
                    case "Friday          ":
                      friVal = value;

                      break;
                    case "Saturday     ":
                      satVal = value;

                      break;
                    case "Sunday        ":
                      sunVal = value;
                      break;
                  }
                });
              },
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: RaisedButton(
            child: Text(
              'UPDATE',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              _registeravailability();
            },
            color: buttonColor,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              top: 15,
            ),
            color: buttonColor,
            child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
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
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              SizedBox(
                                width: 80,
                              ),
                              Text(
                                'SELF ASSESS',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 19),
                              ),
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
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              (monVal == false)
                                                  ? checkbox(
                                                      "Monday      ", monVal)
                                                  : Column(
                                                      children: <Widget>[
                                                        checkbox("Monday      ",
                                                            monVal),
                                                        RaisedButton(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0)),
                                                          elevation: 4.0,
                                                          onPressed: () {
                                                            DatePicker.showTimePicker(
                                                                context,
                                                                theme:
                                                                    DatePickerTheme(
                                                                  containerHeight:
                                                                      210.0,
                                                                ),
                                                                showTitleActions:
                                                                    true,
                                                                onConfirm:
                                                                    (time) {
                                                              print(
                                                                  'confirm $time');
                                                              _mondaystarttime =
                                                                  '${time.hour}:${time.minute}:${time.second}';
                                                              setState(() {});
                                                            },
                                                                currentTime:
                                                                    DateTime
                                                                        .now(),
                                                                locale:
                                                                    LocaleType
                                                                        .en);
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 50.0,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Icon(
                                                                            Icons.access_time,
                                                                            size:
                                                                                18.0,
                                                                            color:
                                                                                Colors.teal,
                                                                          ),
                                                                          Text(
                                                                            " $_mondaystarttime",
                                                                            style: TextStyle(
                                                                                color: Colors.teal,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 18.0),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                Text(
                                                                  "  Start time",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .teal,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18.0),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        RaisedButton(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0)),
                                                          elevation: 4.0,
                                                          onPressed: () {
                                                            DatePicker.showTimePicker(
                                                                context,
                                                                theme:
                                                                    DatePickerTheme(
                                                                  containerHeight:
                                                                      210.0,
                                                                ),
                                                                showTitleActions:
                                                                    true,
                                                                onConfirm:
                                                                    (time) {
                                                              print(
                                                                  'confirm $time');
                                                              _mondayendtime =
                                                                  '${time.hour}:${time.minute}:${time.second}';
                                                              setState(() {});
                                                            },
                                                                currentTime:
                                                                    DateTime
                                                                        .now(),
                                                                locale:
                                                                    LocaleType
                                                                        .en);
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 50.0,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Icon(
                                                                            Icons.access_time,
                                                                            size:
                                                                                18.0,
                                                                            color:
                                                                                Colors.teal,
                                                                          ),
                                                                          Text(
                                                                            " $_mondayendtime",
                                                                            style: TextStyle(
                                                                                color: Colors.teal,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 18.0),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                Text(
                                                                  "  End time",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .teal,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18.0),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          color: Colors.white,
                                                        )
                                                      ],
                                                    ),
                                            ],
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              (tuVal == false)
                                                  ? checkbox(
                                                      "Tuesday      ", tuVal)
                                                  : Column(
                                                      children: <Widget>[
                                                        checkbox(
                                                            "Tuesday      ",
                                                            tuVal),
                                                        RaisedButton(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0)),
                                                          elevation: 4.0,
                                                          onPressed: () {
                                                            DatePicker.showTimePicker(
                                                                context,
                                                                theme:
                                                                    DatePickerTheme(
                                                                  containerHeight:
                                                                      210.0,
                                                                ),
                                                                showTitleActions:
                                                                    true,
                                                                onConfirm:
                                                                    (time) {
                                                              print(
                                                                  'confirm $time');
                                                              _tuesdyastarttime =
                                                                  '${time.hour}:${time.minute}:${time.second}';
                                                              setState(() {});
                                                            },
                                                                currentTime:
                                                                    DateTime
                                                                        .now(),
                                                                locale:
                                                                    LocaleType
                                                                        .en);
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 50.0,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Icon(
                                                                            Icons.access_time,
                                                                            size:
                                                                                18.0,
                                                                            color:
                                                                                Colors.teal,
                                                                          ),
                                                                          Text(
                                                                            " $_tuesdyastarttime",
                                                                            style: TextStyle(
                                                                                color: Colors.teal,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 18.0),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                Text(
                                                                  "  Start time",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .teal,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18.0),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        RaisedButton(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0)),
                                                          elevation: 4.0,
                                                          onPressed: () {
                                                            DatePicker.showTimePicker(
                                                                context,
                                                                theme:
                                                                    DatePickerTheme(
                                                                  containerHeight:
                                                                      210.0,
                                                                ),
                                                                showTitleActions:
                                                                    true,
                                                                onConfirm:
                                                                    (time) {
                                                              print(
                                                                  'confirm $time');
                                                              _tuesdyaendtime =
                                                                  '${time.hour}:${time.minute}:${time.second}';
                                                              setState(() {});
                                                            },
                                                                currentTime:
                                                                    DateTime
                                                                        .now(),
                                                                locale:
                                                                    LocaleType
                                                                        .en);
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 50.0,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Icon(
                                                                            Icons.access_time,
                                                                            size:
                                                                                18.0,
                                                                            color:
                                                                                Colors.teal,
                                                                          ),
                                                                          Text(
                                                                            " $_tuesdyaendtime",
                                                                            style: TextStyle(
                                                                                color: Colors.teal,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 18.0),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                Text(
                                                                  "  End time",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .teal,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18.0),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          color: Colors.white,
                                                        )
                                                      ],
                                                    ),
                                            ],
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              (wedVal == false)
                                                  ? checkbox(
                                                      "Wednesday", wedVal)
                                                  : Column(
                                                      children: <Widget>[
                                                        checkbox("Wednesday",
                                                            wedVal),
                                                        RaisedButton(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0)),
                                                          elevation: 4.0,
                                                          onPressed: () {
                                                            DatePicker.showTimePicker(
                                                                context,
                                                                theme:
                                                                    DatePickerTheme(
                                                                  containerHeight:
                                                                      210.0,
                                                                ),
                                                                showTitleActions:
                                                                    true,
                                                                onConfirm:
                                                                    (time) {
                                                              print(
                                                                  'confirm $time');
                                                              _wednesdaystarttime =
                                                                  '${time.hour}:${time.minute}:${time.second}';
                                                              setState(() {});
                                                            },
                                                                currentTime:
                                                                    DateTime
                                                                        .now(),
                                                                locale:
                                                                    LocaleType
                                                                        .en);
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 50.0,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Icon(
                                                                            Icons.access_time,
                                                                            size:
                                                                                18.0,
                                                                            color:
                                                                                Colors.teal,
                                                                          ),
                                                                          Text(
                                                                            " $_wednesdaystarttime",
                                                                            style: TextStyle(
                                                                                color: Colors.teal,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 18.0),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                Text(
                                                                  "  Start time",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .teal,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18.0),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        RaisedButton(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0)),
                                                          elevation: 4.0,
                                                          onPressed: () {
                                                            DatePicker.showTimePicker(
                                                                context,
                                                                theme:
                                                                    DatePickerTheme(
                                                                  containerHeight:
                                                                      210.0,
                                                                ),
                                                                showTitleActions:
                                                                    true,
                                                                onConfirm:
                                                                    (time) {
                                                              print(
                                                                  'confirm $time');
                                                              _wednesdayendtime =
                                                                  '${time.hour}:${time.minute}:${time.second}';
                                                              setState(() {});
                                                            },
                                                                currentTime:
                                                                    DateTime
                                                                        .now(),
                                                                locale:
                                                                    LocaleType
                                                                        .en);
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 50.0,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Icon(
                                                                            Icons.access_time,
                                                                            size:
                                                                                18.0,
                                                                            color:
                                                                                Colors.teal,
                                                                          ),
                                                                          Text(
                                                                            " $_wednesdayendtime",
                                                                            style: TextStyle(
                                                                                color: Colors.teal,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 18.0),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                Text(
                                                                  "  End time",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .teal,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18.0),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          color: Colors.white,
                                                        )
                                                      ],
                                                    ),
                                            ],
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              (thurVal == false)
                                                  ? checkbox(
                                                      "Thursday    ", thurVal)
                                                  : Column(
                                                      children: <Widget>[
                                                        checkbox("Thursday    ",
                                                            thurVal),
                                                        RaisedButton(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0)),
                                                          elevation: 4.0,
                                                          onPressed: () {
                                                            DatePicker.showTimePicker(
                                                                context,
                                                                theme:
                                                                    DatePickerTheme(
                                                                  containerHeight:
                                                                      210.0,
                                                                ),
                                                                showTitleActions:
                                                                    true,
                                                                onConfirm:
                                                                    (time) {
                                                              print(
                                                                  'confirm $time');
                                                              _thursdaystarttime =
                                                                  '${time.hour}:${time.minute}:${time.second} ';
                                                              setState(() {});
                                                            },
                                                                currentTime:
                                                                    DateTime
                                                                        .now(),
                                                                locale:
                                                                    LocaleType
                                                                        .en);
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 50.0,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Icon(
                                                                            Icons.access_time,
                                                                            size:
                                                                                18.0,
                                                                            color:
                                                                                Colors.teal,
                                                                          ),
                                                                          Text(
                                                                            " $_thursdaystarttime",
                                                                            style: TextStyle(
                                                                                color: Colors.teal,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 18.0),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                Text(
                                                                  "  Start time",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .teal,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18.0),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        RaisedButton(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0)),
                                                          elevation: 4.0,
                                                          onPressed: () {
                                                            DatePicker.showTimePicker(
                                                                context,
                                                                theme:
                                                                    DatePickerTheme(
                                                                  containerHeight:
                                                                      210.0,
                                                                ),
                                                                showTitleActions:
                                                                    true,
                                                                onConfirm:
                                                                    (time) {
                                                              print(
                                                                  'confirm $time');
                                                              _thursdayendtime =
                                                                  '${time.hour}:${time.minute}:${time.second}';
                                                              setState(() {});
                                                            },
                                                                currentTime:
                                                                    DateTime
                                                                        .now(),
                                                                locale:
                                                                    LocaleType
                                                                        .en);
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 50.0,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Icon(
                                                                            Icons.access_time,
                                                                            size:
                                                                                18.0,
                                                                            color:
                                                                                Colors.teal,
                                                                          ),
                                                                          Text(
                                                                            " $_thursdayendtime",
                                                                            style: TextStyle(
                                                                                color: Colors.teal,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 18.0),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                Text(
                                                                  "  End time",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .teal,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18.0),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          color: Colors.white,
                                                        )
                                                      ],
                                                    ),
                                            ],
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              (friVal == false)
                                                  ? checkbox("Friday          ",
                                                      friVal)
                                                  : Column(
                                                      children: <Widget>[
                                                        checkbox(
                                                            "Friday          ",
                                                            friVal),
                                                        RaisedButton(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0)),
                                                          elevation: 4.0,
                                                          onPressed: () {
                                                            DatePicker.showTimePicker(
                                                                context,
                                                                theme:
                                                                    DatePickerTheme(
                                                                  containerHeight:
                                                                      210.0,
                                                                ),
                                                                showTitleActions:
                                                                    true,
                                                                onConfirm:
                                                                    (time) {
                                                              print(
                                                                  'confirm $time');
                                                              _fridaystarttime =
                                                                  '${time.hour}:${time.minute}:${time.second}';
                                                              setState(() {});
                                                            },
                                                                currentTime:
                                                                    DateTime
                                                                        .now(),
                                                                locale:
                                                                    LocaleType
                                                                        .en);
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 50.0,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Icon(
                                                                            Icons.access_time,
                                                                            size:
                                                                                18.0,
                                                                            color:
                                                                                Colors.teal,
                                                                          ),
                                                                          Text(
                                                                            " $_fridaystarttime",
                                                                            style: TextStyle(
                                                                                color: Colors.teal,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 18.0),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                Text(
                                                                  "  Start time",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .teal,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18.0),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        RaisedButton(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0)),
                                                          elevation: 4.0,
                                                          onPressed: () {
                                                            DatePicker.showTimePicker(
                                                                context,
                                                                theme:
                                                                    DatePickerTheme(
                                                                  containerHeight:
                                                                      210.0,
                                                                ),
                                                                showTitleActions:
                                                                    true,
                                                                onConfirm:
                                                                    (time) {
                                                              print(
                                                                  'confirm $time');
                                                              _fridayendtime =
                                                                  '${time.hour}:${time.minute}:${time.second}';
                                                              setState(() {});
                                                            },
                                                                currentTime:
                                                                    DateTime
                                                                        .now(),
                                                                locale:
                                                                    LocaleType
                                                                        .en);
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 50.0,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Icon(
                                                                            Icons.access_time,
                                                                            size:
                                                                                18.0,
                                                                            color:
                                                                                Colors.teal,
                                                                          ),
                                                                          Text(
                                                                            " $_fridayendtime",
                                                                            style: TextStyle(
                                                                                color: Colors.teal,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 18.0),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                Text(
                                                                  "  End time",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .teal,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18.0),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          color: Colors.white,
                                                        )
                                                      ],
                                                    ),
                                            ],
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              (satVal == false)
                                                  ? checkbox(
                                                      "Saturday     ", satVal)
                                                  : Column(
                                                      children: <Widget>[
                                                        checkbox(
                                                            "Saturday     ",
                                                            satVal),
                                                        RaisedButton(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0)),
                                                          elevation: 4.0,
                                                          onPressed: () {
                                                            DatePicker.showTimePicker(
                                                                context,
                                                                theme:
                                                                    DatePickerTheme(
                                                                  containerHeight:
                                                                      210.0,
                                                                ),
                                                                showTitleActions:
                                                                    true,
                                                                onConfirm:
                                                                    (time) {
                                                              print(
                                                                  'confirm $time');
                                                              _saturdaystarttime =
                                                                  '${time.hour}:${time.minute}:${time.second}';
                                                              setState(() {});
                                                            },
                                                                currentTime:
                                                                    DateTime
                                                                        .now(),
                                                                locale:
                                                                    LocaleType
                                                                        .en);
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 50.0,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Icon(
                                                                            Icons.access_time,
                                                                            size:
                                                                                18.0,
                                                                            color:
                                                                                Colors.teal,
                                                                          ),
                                                                          Text(
                                                                            " $_saturdaystarttime",
                                                                            style: TextStyle(
                                                                                color: Colors.teal,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 18.0),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                Text(
                                                                  "  Start time",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .teal,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18.0),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        RaisedButton(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0)),
                                                          elevation: 4.0,
                                                          onPressed: () {
                                                            DatePicker.showTimePicker(
                                                                context,
                                                                theme:
                                                                    DatePickerTheme(
                                                                  containerHeight:
                                                                      210.0,
                                                                ),
                                                                showTitleActions:
                                                                    true,
                                                                onConfirm:
                                                                    (time) {
                                                              print(
                                                                  'confirm $time');
                                                              _saturdayendtime =
                                                                  '${time.hour}:${time.minute}:${time.second}';
                                                              setState(() {});
                                                            },
                                                                currentTime:
                                                                    DateTime
                                                                        .now(),
                                                                locale:
                                                                    LocaleType
                                                                        .en);
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 50.0,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Icon(
                                                                            Icons.access_time,
                                                                            size:
                                                                                18.0,
                                                                            color:
                                                                                Colors.teal,
                                                                          ),
                                                                          Text(
                                                                            " $_saturdayendtime",
                                                                            style: TextStyle(
                                                                                color: Colors.teal,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 18.0),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                Text(
                                                                  "  End time",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .teal,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18.0),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          color: Colors.white,
                                                        )
                                                      ],
                                                    ),
                                            ],
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              (sunVal == false)
                                                  ? checkbox(
                                                      "Sunday        ", sunVal)
                                                  : Column(
                                                      children: <Widget>[
                                                        checkbox(
                                                            "Sunday        ",
                                                            sunVal),
                                                        RaisedButton(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0)),
                                                          elevation: 4.0,
                                                          onPressed: () {
                                                            DatePicker.showTimePicker(
                                                                context,
                                                                theme:
                                                                    DatePickerTheme(
                                                                  containerHeight:
                                                                      210.0,
                                                                ),
                                                                showTitleActions:
                                                                    true,
                                                                onConfirm:
                                                                    (time) {
                                                              print(
                                                                  'confirm $time');
                                                              _sundaystarttime =
                                                                  '${time.hour}:${time.minute}:${time.second}';
                                                              setState(() {});
                                                            },
                                                                currentTime:
                                                                    DateTime
                                                                        .now(),
                                                                locale:
                                                                    LocaleType
                                                                        .en);
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 50.0,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Icon(
                                                                            Icons.access_time,
                                                                            size:
                                                                                18.0,
                                                                            color:
                                                                                Colors.teal,
                                                                          ),
                                                                          Text(
                                                                            " $_sundaystarttime",
                                                                            style: TextStyle(
                                                                                color: Colors.teal,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 18.0),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                Text(
                                                                  "  Start time",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .teal,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18.0),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        RaisedButton(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0)),
                                                          elevation: 4.0,
                                                          onPressed: () {
                                                            DatePicker.showTimePicker(
                                                                context,
                                                                theme:
                                                                    DatePickerTheme(
                                                                  containerHeight:
                                                                      210.0,
                                                                ),
                                                                showTitleActions:
                                                                    true,
                                                                onConfirm:
                                                                    (time) {
                                                              print(
                                                                  'confirm $time');
                                                              _sundayendtime =
                                                                  '${time.hour}:${time.minute}:${time.second}';
                                                              setState(() {});
                                                            },
                                                                currentTime:
                                                                    DateTime
                                                                        .now(),
                                                                locale:
                                                                    LocaleType
                                                                        .en);
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 50.0,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Icon(
                                                                            Icons.access_time,
                                                                            size:
                                                                                18.0,
                                                                            color:
                                                                                Colors.teal,
                                                                          ),
                                                                          Text(
                                                                            " $_sundayendtime",
                                                                            style: TextStyle(
                                                                                color: Colors.teal,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 18.0),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                Text(
                                                                  "  End time",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .teal,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18.0),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          color: Colors.white,
                                                        ),
                                                      ],
                                                    ),
                                            ],
                                          )),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Container(
                                        height: 30,
                                        width: 450,
                                        color: Colors.grey[300],
                                        alignment: Alignment.center,
                                        child: Text(
                                          'BreakTime',
                                          style: TextStyle(fontSize: 20),
                                        )),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: 20, right: 10, left: 10),
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        elevation: 4.0,
                                        onPressed: () {
                                          DatePicker.showTimePicker(context,
                                              theme: DatePickerTheme(
                                                containerHeight: 210.0,
                                              ),
                                              showTitleActions: true,
                                              onConfirm: (time) {
                                            print('confirm $time');
                                            break_start_time =
                                                '${time.hour}:${time.minute}:${time.second}';
                                            setState(() {});
                                          },
                                              currentTime: DateTime.now(),
                                              locale: LocaleType.en);
                                          setState(() {});
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 50.0,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.access_time,
                                                          size: 18.0,
                                                          color: Colors.teal,
                                                        ),
                                                        Text(
                                                          " $break_start_time",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.teal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18.0),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Text(
                                                "  Start time",
                                                style: TextStyle(
                                                    color: Colors.teal,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                        color: Colors.white,
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: 20, right: 10, left: 10),
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        elevation: 4.0,
                                        onPressed: () {
                                          DatePicker.showTimePicker(context,
                                              theme: DatePickerTheme(
                                                containerHeight: 210.0,
                                              ),
                                              showTitleActions: true,
                                              onConfirm: (time) {
                                            print('confirm $time');
                                            break_end_time =
                                                '${time.hour}:${time.minute}:${time.second}';
                                            setState(() {});
                                          },
                                              currentTime: DateTime.now(),
                                              locale: LocaleType.en);
                                          setState(() {});
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 50.0,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.access_time,
                                                          size: 18.0,
                                                          color: Colors.teal,
                                                        ),
                                                        Text(
                                                          " $break_end_time",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.teal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18.0),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Text(
                                                "  End time",
                                                style: TextStyle(
                                                    color: Colors.teal,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                        color: Colors.white,
                                      ))
                                ],
                              ),
                            ))),
                  ],
                )),
          ),
        ));
  }
}
