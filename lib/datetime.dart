import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:horizontal_time_picker/horizontal_time_picker.dart';
import 'package:intl/intl.dart';
import 'package:doctoragileapp/api.dart';
import 'package:doctoragileapp/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_range/time_range.dart';
import 'package:http/http.dart' as http;

class Dateselect extends StatefulWidget {
  DateTime appointment_datetime;
  List bookedtime;
  String holderid;
  final DateTime starttime;
  final DateTime endtime;
  final String slotdifference;
  Dateselect(
      {this.appointment_datetime,
      this.holderid,
      this.bookedtime,
      this.starttime,
      this.endtime,
      this.slotdifference});
  @override
  _WidgetPageState createState() => _WidgetPageState();
}

class _WidgetPageState extends State<Dateselect> {
  DateTime _selectedDate;
  DateTime _dateTime = DateTime.now();
  var slottimeshow;
  @override
  String _localuserid;
  _settoken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _localuserid = preferences.getString("id");
    });
  }

  // DateTime dd = DateTime();
  static const orange = Color(0xFFFE9A75);
  static const dark = Color(0xFF333A47);
  static const double leftPadding = 50;
  int colorgrid = 0;
  int selectedCard = -1;
  int bookedCard = -1;
  final _defaultTimeRange = TimeRangeResult(
    TimeOfDay(hour: 14, minute: 50),
    TimeOfDay(hour: 0, minute: 0),
  );
  TimeRangeResult _timeRange;
  DateTime appointment_datetime;
  DateTime gettime;
  var st;
  var et;
  var splitduration;
  List booktime = [];
  var setdatetime;
  List bookedtimelist = [];
  List<dynamic> timeSlots1 = [
    {"time": "01:00", "selected": false},
    {"time": "01:15", "selected": false},
    {"time": "01:30", "selected": false},
    {"time": "01:45", "selected": false},
    {"time": "02:00", "selected": false},
    {"time": "02:15", "selected": false},
    {"time": "02:30", "selected": false},
    {"time": "02:45", "selected": false},
    {"time": "03:00", "selected": false},
    {"time": "03:15", "selected": false},
    {"time": "03:30", "selected": false},
    {"time": "03:45", "selected": false},
    {"time": "04:00", "selected": false},
    {"time": "04:15", "selected": false},
    {"time": "04:30", "selected": false},
    {"time": "04:45", "selected": false},
    {"time": "05:00", "selected": false},
    {"time": "05:15", "selected": false},
    {"time": "05:30", "selected": false},
    {"time": "05:45", "selected": false},
    {"time": "06:00", "selected": false},
    {"time": "06:15", "selected": false},
    {"time": "06:30", "selected": false},
    {"time": "06:45", "selected": false},
    {"time": "07:00", "selected": false},
    {"time": "07:15", "selected": false},
    {"time": "07:30", "selected": false},
    {"time": "07:45", "selected": false},
    {"time": "08:00", "selected": false},
    {"time": "08:15", "selected": false},
    {"time": "08:30", "selected": false},
    {"time": "08:45", "selected": false},
    {"time": "09:00", "selected": false},
    {"time": "09:15", "selected": false},
    {"time": "09:30", "selected": false},
    {"time": "09:45", "selected": false},
    {"time": "10:00", "selected": false},
    {"time": "10:15", "selected": false},
    {"time": "10:30", "selected": false},
    {"time": "10:45", "selected": false},
    {"time": '11:00', "selected": false},
    {"time": '11:15', "selected": false},
    {"time": '11:30', "selected": false},
    {"time": '11:45', "selected": false},
    {"time": '12:00', "selected": false},
    {"time": '12:15', "selected": false},
    {"time": '12:30', "selected": false},
    {"time": '12:45', "selected": false},
    {"time": '13:00', "selected": false},
    {"time": '13:15', "selected": false},
    {"time": '13:30', "selected": false},
    {"time": '13:45', "selected": false},
    {"time": '14:00', "selected": false},
    {"time": '14:15', "selected": false},
    {"time": '14:30', "selected": false},
    {"time": '14:45', "selected": false},
    {"time": '15:00', "selected": false},
    {"time": '15:15', "selected": false},
    {"time": '15:30', "selected": false},
    {"time": '15:45', "selected": false},
    {"time": '16:00', "selected": false},
    {"time": '16:15', "selected": false},
    {"time": '16:30', "selected": false},
    {"time": '16:45', "selected": false},
    {"time": '17:00', "selected": false},
    {"time": '17:15', "selected": false},
    {"time": '17:30', "selected": false},
    {"time": '17:45', "selected": false},
    {"time": '18:00', "selected": false},
    {"time": '18:15', "selected": false},
    {"time": '18:30', "selected": false},
    {"time": '18:45', "selected": false},
    {"time": '19:00', "selected": false},
    {"time": '19:15', "selected": false},
    {"time": '19:30', "selected": false},
    {"time": '19:45', "selected": false},
    {"time": '20:00', "selected": false},
    {"time": '20:15', "selected": false},
    {"time": '20:30', "selected": false},
    {"time": '20:45', "selected": false},
    {"time": '21:00', "selected": false},
    {"time": '21:15', "selected": false},
    {"time": '21:30', "selected": false},
    {"time": '21:45', "selected": false},
    {"time": '22:00', "selected": false},
    {"time": '22:15', "selected": false},
    {"time": '22:30', "selected": false},
    {"time": '22:45', "selected": false},
    {"time": '23:00', "selected": false},
    {"time": '23:15', "selected": false},
    {"time": '23:30', "selected": false},
    {"time": '23:45', "selected": false},
  ];
  List<dynamic> timeSlots30 = [
    {"time": "01:00", "selected": false},
    {"time": "01:30", "selected": false},
    {"time": "02:00", "selected": false},
    {"time": "02:30", "selected": false},
    {"time": "03:00", "selected": false},
    {"time": "03:30", "selected": false},
    {"time": "04:00", "selected": false},
    {"time": "04:30", "selected": false},
    {"time": "05:00", "selected": false},
    {"time": "05:30", "selected": false},
    {"time": "06:00", "selected": false},
    {"time": "06:30", "selected": false},
    {"time": "07:00", "selected": false},
    {"time": "07:30", "selected": false},
    {"time": "08:00", "selected": false},
    {"time": "08:30", "selected": false},
    {"time": "09:00", "selected": false},
    {"time": "09:30", "selected": false},
    {"time": "10:00", "selected": false},
    {"time": "10:30", "selected": false},
    {"time": '11:00', "selected": false},
    {"time": '11:30', "selected": false},
    {"time": '12:00', "selected": false},
    {"time": '12:30', "selected": false},
    {"time": '13:00', "selected": false},
    {"time": '13:30', "selected": false},
    {"time": '14:00', "selected": false},
    {"time": '14:30', "selected": false},
    {"time": '15:00', "selected": false},
    {"time": '15:30', "selected": false},
    {"time": '16:00', "selected": false},
    {"time": '16:30', "selected": false},
    {"time": '17:00', "selected": false},
    {"time": '17:30', "selected": false},
    {"time": '18:00', "selected": false},
    {"time": '18:30', "selected": false},
    {"time": '19:00', "selected": false},
    {"time": '19:30', "selected": false},
    {"time": '20:00', "selected": false},
    {"time": '20:30', "selected": false},
    {"time": '21:00', "selected": false},
    {"time": '21:30', "selected": false},
    {"time": '22:00', "selected": false},
    {"time": '22:30', "selected": false},
    {"time": '23:00', "selected": false},
    {"time": '23:30', "selected": false},
  ];
  List<dynamic> timeSlots45 = [
    {"time": "01:00", "selected": false},
    {"time": "01:45", "selected": false},
    {"time": "02:30", "selected": false},
    {"time": "03:15", "selected": false},
    {"time": "04:00", "selected": false},
    {"time": "04:45", "selected": false},
    {"time": "05:30", "selected": false},
    {"time": "06:15", "selected": false},
    {"time": "07:00", "selected": false},
    {"time": "07:45", "selected": false},
    {"time": "08:30", "selected": false},
    {"time": "09:15", "selected": false},
    {"time": "10:00", "selected": false},
    {"time": "10:45", "selected": false},
    {"time": '11:30', "selected": false},
    {"time": '12:15', "selected": false},
    {"time": '13:00', "selected": false},
    {"time": '13:45', "selected": false},
    {"time": '14:30', "selected": false},
    {"time": '15:15', "selected": false},
    {"time": '16:00', "selected": false},
    {"time": '16:45', "selected": false},
    {"time": '17:30', "selected": false},
    {"time": '18:15', "selected": false},
    {"time": '19:00', "selected": false},
    {"time": '19:45', "selected": false},
    {"time": '20:30', "selected": false},
    {"time": '21:15', "selected": false},
    {"time": '22:00', "selected": false},
    {"time": '22:45', "selected": false},
    {"time": '23:30', "selected": false},
  ];
  @override
  void initState() {
    super.initState();
    _settoken();
    _timeRange = _defaultTimeRange;
    st = DateFormat('hh:mm a').format(widget.starttime.toLocal());
    et = DateFormat('hh:mm a').format(widget.endtime.toLocal());

    if (widget.slotdifference == null) {
      splitduration = 15;
    } else {
      var splittime = widget.slotdifference.split(':');
      splitduration = int.parse(splittime[1]);
    }
    print(splitduration);
    slottime();
    var today = new DateTime.now();
    var addminutes = widget.starttime.add(new Duration(minutes: 15));
    var addminutes1 = addminutes.add(new Duration(minutes: 15));
    print(DateFormat('HH:mm').format(addminutes1.toLocal()));
  }

  DateTime dt1;
  List<dynamic> allslotslist = [];
  List<dynamic> slottimeList = [];
  DateTime starttimechange;
  DateTime endtimechange;
  DateTime dateTime = DateTime.now();
  Future<List> _dateappointment() async {
    final response =
        await http.post(apipath + '/doctorListByIdAppointment', body: {
      "appointment_date": DateFormat("yMd").format(widget.appointment_datetime),
      "user_id": widget.holderid,
      'timezone': dateTime.timeZoneName
    }).then((value) {
      print(value.body);
      var dta = jsonDecode(value.body);
      setState(() {
        starttimechange = DateTime.parse(dta[0]['available_start_time']);
        endtimechange = DateTime.parse(dta[0]['available_end_time']);
        st = DateFormat('hh:mm a')
            .format(DateTime.parse(dta[0]['available_start_time']).toLocal());
        et = DateFormat('hh:mm a')
            .format(DateTime.parse(dta[0]['available_end_time']).toLocal());
      });
      slottimeList = [];
      if (dta[0]['slot_size'] == null) {
        setState(() {
          splitduration = 15;
        });
      } else {
        var splittime = dta[0]['slot_size'].split(':');
        setState(() {
          splitduration = int.parse(splittime[1]);
        });
      }
      moveToSecondPage();
      slottimechange();

      // print(dta[0]['available_start_time'].toLocal());
    });
  }

  var data;
  List bookedtimechange = [];
  moveToSecondPage() async {
    await http.post(apipath + '/getBookedAppointmentSlot', body: {
      "selected_date": DateFormat('yMd').format(widget.appointment_datetime),
      "holder_id": widget.holderid,
      "timezone": dateTime.timeZoneName
    }).then((value) {
      data = json.decode(value.body);
      if (value.body != '[]') {
        setState(() {
          bookedtimechange = data;
        });
      }
    });
  }

  slottimechange() {
    var dynamiclist = [];
    var obj = {'time': st, "selected": false};
    var addminutes;
    dynamiclist.add(obj);
    addminutes = starttimechange.add(new Duration(minutes: splitduration));

    for (int i = 0; i < dynamiclist.length; i++) {
      var obj1 = {
        'time': DateFormat('hh:mm a').format(addminutes.toLocal()),
        "selected": false
      };
      dynamiclist.add(obj1);
      addminutes = addminutes.add(new Duration(minutes: splitduration));
      if (DateFormat('hh:mm a').format(addminutes.toLocal()) == et) {
        var obj2 = {'time': et, "selected": false};
        dynamiclist.add(obj2);
        break;
      }
    }

    for (int i = 0; i < dynamiclist.length; i++) {
      if (dynamiclist[i]['time'] == st) {
        for (int k = 0; k < bookedtimechange.length; k++) {
          if (dynamiclist[i]['time'] ==
              DateFormat('hh:mm a').format(
                  DateTime.parse(bookedtimechange[k]['appointment_date'])
                      .toLocal())) {
            dynamiclist[i]['selected'] = true;
          }
        }
        slottimeList.add(dynamiclist[i]);
        for (int j = i + 1; j < dynamiclist.length; j++) {
          for (int k = 0; k < bookedtimechange.length; k++) {
            if (dynamiclist[j]['time'] ==
                DateFormat('hh:mm a').format(
                    DateTime.parse(bookedtimechange[k]['appointment_date'])
                        .toLocal())) {
              dynamiclist[j]['selected'] = true;
            }
          }
          slottimeList.add(dynamiclist[j]);
          if (dynamiclist[j]['time'] == et) {
            break;
          }
        }
      }
    }
    print(slottimeList);
  }

  slottime() {
    var dynamiclist = [];
    var obj = {'time': st, "selected": false};
    var addminutes;
    dynamiclist.add(obj);
    addminutes = widget.starttime.add(new Duration(minutes: splitduration));

    for (int i = 0; i < dynamiclist.length; i++) {
      var obj1 = {
        'time': DateFormat('hh:mm a').format(addminutes.toLocal()),
        "selected": false
      };
      dynamiclist.add(obj1);
      addminutes = addminutes.add(new Duration(minutes: splitduration));
      if (DateFormat('hh:mm a').format(addminutes.toLocal()) == et) {
        var obj2 = {'time': et, "selected": false};
        dynamiclist.add(obj2);
        break;
      }
    }

    for (int i = 0; i < dynamiclist.length; i++) {
      if (dynamiclist[i]['time'] == st) {
        for (int k = 0; k < widget.bookedtime.length; k++) {
          if (dynamiclist[i]['time'] ==
              DateFormat('hh:mm a').format(
                  DateTime.parse(widget.bookedtime[k]['appointment_date'])
                      .toLocal())) {
            dynamiclist[i]['selected'] = true;
          }
        }
        slottimeList.add(dynamiclist[i]);
        for (int j = i + 1; j < dynamiclist.length; j++) {
          for (int k = 0; k < widget.bookedtime.length; k++) {
            if (dynamiclist[j]['time'] ==
                DateFormat('hh:mm a').format(
                    DateTime.parse(widget.bookedtime[k]['appointment_date'])
                        .toLocal())) {
              dynamiclist[j]['selected'] = true;
            }
          }
          slottimeList.add(dynamiclist[j]);
          if (dynamiclist[j]['time'] == et) {
            break;
          }
        }
      }
    }
    print(slottimeList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        // color: Colors.white,
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
                            width: 60,
                          ),
                          Text(
                            'Select date and time',
                            style:
                                TextStyle(color: buttonTextColor, fontSize: 19),
                          ),
                        ]),
                      ),
                    ]),
                SizedBox(height: 0),
                Column(
                  children: <Widget>[
                    Container(
                        height: 30,
                        width: 450,
                        // color: Colors.white,
                        alignment: Alignment.center,
                        child: Text(
                          'Date',
                          style: TextStyle(fontSize: 22),
                        )),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(top: 30, left: 35, right: 35),
                      child: DatePickerWidget(
                        looping: false,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2040, 1, 1),
                        initialDate: widget.appointment_datetime.toLocal(),
                        dateFormat: "dd-MMMM-yyyy",
                        locale: DateTimePickerLocale.en_us,
                        onChange: (DateTime newDate, _) {
                          widget.appointment_datetime = new DateTime(
                              newDate.year,
                              newDate.month,
                              newDate.day,
                              widget.appointment_datetime.hour,
                              widget.appointment_datetime.minute,
                              widget.appointment_datetime.second,
                              widget.appointment_datetime.millisecond,
                              widget.appointment_datetime.microsecond);
                          _dateappointment();
                        },
                        pickerTheme: DateTimePickerTheme(
                          backgroundColor: Colors.white,
                          itemTextStyle:
                              TextStyle(color: blackTextColor, fontSize: 20),
                          dividerColor: dividerColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Container(
                          height: 30,
                          width: 450,
                          color: Colors.white,
                          alignment: Alignment.center,
                          child: Text(
                            'Time',
                            style: TextStyle(fontSize: 22),
                          )),
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    Container(
                        decoration: BoxDecoration(
                            //                border:  Border(
                            //     bottom: BorderSide(color: Colors.grey, width: 1, style: BorderStyle.solid),

                            // ),
                            ),
                        height: 230,
                        child: Padding(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: GridView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 7,
                                        crossAxisSpacing: 5.0,
                                        mainAxisSpacing: 1),
                                itemCount: slottimeList.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  // bookedtimelist.add(slottimeList.where((f) => f[index] == booktime))     ;
                                  //     print(bookedtimelist);
                                  return GestureDetector(
                                      onTap: slottimeList[index]['selected'] ==
                                              false
                                          ? () {
                                              setState(() {
                                                slottimeshow =
                                                    slottimeList[index]['time'];
                                                dt1 = DateFormat('hh:mm a')
                                                    .parse(slottimeshow);
                                                selectedCard = index;
                                              });
                                              print(DateFormat('HH:mm')
                                                  .format(dt1));
                                            }
                                          : null,
                                      child: Container(
                                        padding: EdgeInsets.all(0.0),
                                        margin: EdgeInsets.only(
                                            left: 1.0,
                                            right: 1.0,
                                            top: 1.0,
                                            bottom: 10.0),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey,
                                                // bookedCard==index?Colors.grey:Colors.red,
                                                width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    8.0) //                 <--- border radius here
                                                ),
                                            color: slottimeList[index]
                                                        ['selected'] ==
                                                    false
                                                ? selectedCard == index
                                                    ? (buttonColor)
                                                    : (Colors.white)
                                                : (Colors.grey)),
                                        child: Center(
                                          child: Text(
                                            slottimeList[index]['time'],
                                            style: TextStyle(
                                              color: slottimeList[index]
                                                          ['selected'] ==
                                                      false
                                                  ? selectedCard == index
                                                      ? Colors.white
                                                      : Colors.black
                                                  : Colors.white,
                                              fontSize: 14.0,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ));
                                }))),
                    SizedBox(
                      height: 10,
                    ),
                    slottimeshow != null
                        ? Text(
                            'Selected Time: ${DateFormat('hh:mm a').format(dt1)}',
                            style: TextStyle(fontSize: 15),
                          )
                        : Text(''),
                    // slottimeshow.toString()
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                        color: buttonColor,
                        onPressed: () {
                          Navigator.pop(
                            context,
                            DateTime.parse(DateFormat('yMMdd ')
                                    .format(widget.appointment_datetime) +
                                DateFormat('HH:mm').format(dt1)),
                          );
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(color: buttonTextColor),
                        ))

                    // Padding(slottimeshow.split('AM')[0]
                    //     padding: EdgeInsets.only(top: 10),
                    //     child: Container(
                    //       color: Colors.white,
                    //       padding: EdgeInsets.only(top: 10),
                    //       child: new Column(
                    //         children: <Widget>[
                    //           hourMinute15Interval(),
                    //           SizedBox(height: 58),
                    //           Container(
                    //               width: 360,
                    //               padding: EdgeInsets.only(right: 10, left: 10),
                    //               child: RaisedButton(
                    //                 onPressed: () {
                    //                   if (_selectedDate == null) {
                    //                     setState(() {
                    //                       _timer =
                    //                           DateFormat('yyyy-MM-dd  HH:MM')
                    //                               .format(_dateTime);
                    //                     });
                    //                   } else {
                    //                     setState(() {
                    //                       _timer = _selectedDate.year
                    //                               .toString() +
                    //                           '-' +
                    //                           _selectedDate.month.toString() +
                    //                           '-' +
                    //                           _selectedDate.day.toString() +
                    //                           ' ' +
                    //                           _dateTime.hour
                    //                               .toString()
                    //                               .padLeft(2, '0') +
                    //                           ':' +
                    //                           _dateTime.minute
                    //                               .toString()
                    //                               .padLeft(2, '0');
                    //                     });
                    //                   }

                    //                   Navigator.pop(
                    //                     context,
                    //                     widget.appointment_datetime,
                    //                   );
                    //                 },
                    //                 shape: RoundedRectangleBorder(
                    //                     borderRadius:
                    //                         BorderRadius.circular(10.0)),
                    //                 color: buttonColor,
                    //                 child: Text(
                    //                   'DONE',
                    //                   style: TextStyle(color: buttonTextColor),
                    //                 ),
                    //               ))
                    //         ],
                    //       ),
                    //     ))
                    //   ],
                    // )
                  ],
                )
              ],
            )),
      ),
    ));
  }

  String _timer;
  Widget hourMinute15Interval() {
    return new TimePickerSpinner(
      spacing: 30,
      itemHeight: 40,
      minutesInterval: 15,
      is24HourMode: false,
      time: widget.appointment_datetime,
      onTimeChange: (time) {
        setState(() {
          widget.appointment_datetime = new DateTime(
              widget.appointment_datetime.year,
              widget.appointment_datetime.month,
              widget.appointment_datetime.day,
              time.hour,
              time.minute,
              time.second,
              time.millisecond,
              time.microsecond);
        });
      },
    );
  }
}
