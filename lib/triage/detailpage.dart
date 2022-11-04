import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:doctoragileapp/api.dart';
import 'package:doctoragileapp/color.dart';
import 'package:http/http.dart' as http;
import 'package:doctoragileapp/datetime.dart';
import 'package:doctoragileapp/screens/apptmntdone.dart';
import 'package:doctoragileapp/screens/doneappointment.dart';
import 'package:doctoragileapp/screens/webview.dart';
import 'package:doctoragileapp/triage/calendarscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Detailpage extends StatefulWidget {
  final String calendarvalue;
  final String starttime;
  final String endtime;
  final String date;
  final String time;
  DateTime appointment_datetime;
  final String name;
  final String phonenumber;
  final String problem;
  final String appointment_id;
  final String doctor;
  final String email;
  final String holderid;
  final String user_image;
  final String price;
  final bool payment_required;
  final String slotdifference;
  Detailpage(
      {this.calendarvalue,
      this.starttime,
      this.endtime,
      this.date,
      this.holderid,
      this.time,
      this.appointment_datetime,
      this.name,
      this.email,
      this.phonenumber,
      this.doctor,
      this.problem,
      this.user_image,
      this.appointment_id,
      this.payment_required,
      this.price,
      this.slotdifference});
  @override
  _TestcatState createState() => _TestcatState();
}

class _TestcatState extends State<Detailpage> {
  String _catg(dynamic user) {
    return user['category'];
  }

  var calendardate;
  bool check = false;
  @override
  void initState() {
    super.initState();
    _getapptoken();
    press = false;
    if (widget.calendarvalue == '1') {
      calendardate = widget.appointment_datetime.toLocal();
    } else {
      calendardate = widget.appointment_datetime.toLocal();
    }
    if (widget.appointment_datetime == null) {
      widget.appointment_datetime = DateTime.now();
    }
    // else{
    //   return widget.appointment_datetime;
    // }
  }

  SharedPreferences prefs;
  String _description(dynamic user) {
    return user['description'];
  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  TextEditingController name = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController phonenumber = new TextEditingController();
  TextEditingController useremail = new TextEditingController();
  TextEditingController problem = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController datetime = new TextEditingController();
  TextEditingController _time = new TextEditingController();
  TextEditingController insurancename = new TextEditingController();
  TextEditingController policynumber = new TextEditingController();
  TextEditingController policydescription = new TextEditingController();
  TextEditingController policynotes = new TextEditingController();
  TextEditingController insurancegroupnumber = new TextEditingController();
  TextEditingController fees = new TextEditingController();
  TextEditingController setfees = new TextEditingController();
  String _date, name1, phone1, address1, mobilenumber, email, _problem;
  int id;
  String _localid;
  _getapptoken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      app_tokenid = preferences.getString("appidtoken");
      id = preferences.getInt("localid");
      _localid = preferences.getString("id");
      _date = preferences.getString("appointment_date");
      name1 = preferences.getString("name");
      address1 = preferences.getString("adrs");
      _problem = preferences.getString("issue");
      email = preferences.getString("email");
      mobilenumber = preferences.getString("phn");
    });
    name = new TextEditingController(text: name1);
    useremail = new TextEditingController(text: email);
    phonenumber = new TextEditingController(text: mobilenumber);
    fees = new TextEditingController(text: widget.price);
    setfees = new TextEditingController(text: '0.00');
    print(app_tokenid);
  }

  bool _login = false;
  int _userid;
  String _email;
  bool press = true;
  String _pphonenum;
  String _policynum;
  String _policydes;
  String _policynote;
  String _insurancename;
  String _insurancegoupnum;
  DateTime dateTime = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  final _insurancekey = GlobalKey<FormState>();
  Future<List> _registerndata() async {
    final response = await http.post(apipath + '/register', body: {
      "username": name.text,
      "address1": address.text,
    }).then((value) async {
      print(value.body);
      var body = json.decode(value.body);
      setState(() {
        _userid = body['user_id'];
        // _login = true;
      });
      SharedPreferences localStorage = await SharedPreferences.getInstance();

      localStorage.setInt('localid', body['user_id']);
      localStorage.setString('token', body['token']);
      localStorage.setString('name', body['username']);
      localStorage.setString('adrs', body['address1']);
    });
    register();
  }

  Future<List> _appointmentslot() async {
    final response =
        await http.post(apipath + '/getBookedAppointmentSlot', body: {
      "selected_date": widget.appointment_datetime,
      "holder_id": address.text,
      "timezone": dateTime.timeZoneName
    }).then((value) async {
      print(value.body);
      var body = json.decode(value.body);
      setState(() {
        _userid = body['user_id'];
      });
    });
  }

  String app_tokenid;
  List booktime;
  int appointmentid;
  Future<List> register() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    final response = await http.post(apipath + '/createAppointment', body: {
      "appointment_date": widget.appointment_datetime,
      "client_name": name.text,
      "client_address": address.text,
      "issue": problem.text,
      "user_id": _userid.toString(),
      "holder_id": widget.holderid,
      "user_traiage_result_id": '-1',
    }).then((vl) async {
      var body = json.decode(vl.body);
      setState(() {
        _login = true;
      });

      localStorage.setInt('date', body['appointment_date']);

      localStorage.setString('clientname', body['client_name']);
      localStorage.setString('clientadrs', body['client_address']);
      localStorage.setString('prblem', body['issue']);
      print(vl.body);
    });
    if (localStorage.getString("token") != null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => Calendarscreen()),
          (Route<dynamic> route) => false);
    }
  }

  Future<List> _createappointment() async {
    _formKey.currentState.validate();

    if (useremail.text.length == 0 ||
        phonenumber.text.length == 0 ||
        !useremail.text.contains("@")) {
      return null;
    }
//     else if( _insurancekey.currentState !=null)
// {
//   _insurancekey.currentState.validate();
//   if (
//   insurancename.text.length == 0 ||
//         policynumber.text.length == 0 ||
//         policydescription.text.length == 0 ||
//         policynotes.text.length == 0
//        ) {
//      return null;
//     }
//      else {
//       final response = await http.post(apipath + '/createAppointment', body: {
//         "appointment_date": widget.appointment_datetime.toString(),
//         "client_name": name.text,
//         "user_id": _localid,
//         "holder_id": widget.holderid,
//         "user_traiage_result_id": '-1',
//         "phonenumber": phonenumber.text,
//         "email": useremail.text,
//         'price': fees.text,
//         'insurance_name': insurancename.text,
//         'insurance_group_number': insurancegroupnumber.text,
//         'insurance_policy_number': policynumber.text,
//         'insurance_description': policydescription.text,
//         'insurance_notes': policynotes.text
//       }).then((vl) async {
//         var body = json.decode(vl.body);

//         if (body['error'] == 'Invalid Email') {
//           return null;
//         } else if (body == 'No Data Found to create an Appointment..!') {
//           return null;
//         } else if (body['is_payment_required'] == false) {
//           return Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => Doneappointment(
//                       doctorname: widget.doctor,
//                       // doctoremail: widget.email,payment_token
//                       appointmenttime: body['appointment_time'],
//                       appointmentdate: body['appointment_date'])));
//         } else {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => WebViewExample(
//                         appointment_id: body['appointment_id'].toString(),
//                         paymenttoken: body['payment_token'],
//                       )));
//           // Navigator.push(
//           //     context,
//           //     MaterialPageRoute(
//           //         builder: (context) =>
//           //         Doneappointment(
//           //             doctorname: widget.doctor,
//           //             // doctoremail: widget.email,payment_token
//           //             appointmenttime: body['appointment_time'],
//           //             appointmentdate: body['appointment_date'])
//           //             ));
//           print(vl.body);
//         }
//       });
//     }
// }

    else {
      String sendfees;
      if (check == true) {
        setState(() {
          sendfees = setfees.text;
        });
      } else {
        setState(() {
          sendfees = fees.text;
        });
      }
      final response = await http.post(apipath + '/createAppointment', body: {
        "appointment_date": widget.appointment_datetime.toLocal().toString(),
        "client_name": name.text,
        "user_id": _localid,
        "holder_id": widget.holderid,
        "user_traiage_result_id": '-1',
        "phonenumber": phonenumber.text,
        "email": useremail.text,
        'partial_amount': sendfees,
        'insurance_name': insurancename.text,
        'insurance_group_number': insurancegroupnumber.text,
        'insurance_policy_number': policynumber.text,
        'insurance_description': policydescription.text,
        'insurance_notes': policynotes.text,
        'timezone': dateTime.timeZoneName,
        'pay_later': check.toString()
      }).then((vl) async {
        var body = json.decode(vl.body);

        if (body["msg"] == 'Doctor is not available on your selected time.') {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                // title: new Center(
                //   child:  Text("DOCTOR INFO"),
                //   ),
                content:
                    new Text("Doctor is not available on your selected time."),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );

          // AlertDialog(
          //                                                               shape: RoundedRectangleBorder(
          //                                                                   borderRadius: BorderRadius.all(Radius.circular(32.0))),
          //                                                               title: Column(
          //                                                                 children: <Widget>[
          //                                                                   Container(
          //                                                                     child: Text('Test'),
          //                                                                   ),
          //                                                                   Divider(color: Colors.black),
          //                                                                   SizedBox(
          //                                                                     height: 20,
          //                                                                   ),
          //                                                                   Container(
          //                                                                       width: 200.0,
          //                                                                       height: 100.0,
          //                                                                       decoration: BoxDecoration(
          //                                                                         borderRadius: BorderRadius.circular(67),
          //                                                                       ),
          //                                                                       child: Text(
          //                                                                         'Doctor is not available on your selected time.',
          //                                                                         style: TextStyle(
          //                                                                             color: Colors.black,
          //                                                                             fontSize: 15,
          //                                                                             fontWeight: FontWeight.w600),
          //                                                                         textAlign: TextAlign.center,
          //                                                                       )),
          //                                                                 ],
          //                                                               ),
          //                                                               content: Row(
          //                                                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
          //                                                                 children: <Widget>[
          //                                                                   RaisedButton(
          //                                                                       color: themecolor,
          //                                                                       child: Text(
          //                                                                         'YES',
          //                                                                         style: TextStyle(color: Colors.white),
          //                                                                       ),
          //                                                                       onPressed: () async {

          //                                                                       }),

          //                                                                 ],
          //                                                               ),
          //                                                             );

        } else if (body == 'No Data Found to create an Appointment..!') {
          return null;
        } else if (body['is_payment_required'] == false || check == true) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: Colors.transparent,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new CircularProgressIndicator(),
                  ],
                ),
              );
            },
          );
          new Future.delayed(new Duration(seconds: 2), () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Doneappointment(
                        doctorname: widget.doctor,
                        // doctoremail: widget.email,payment_token
                        appointmenttime: body['appointment_time'],
                        appointmentdate: body['appointment_date'])));
          });
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WebViewExample(
                        appointmentid: body['appointment_id'],
                        paymenttoken: body['payment_token'],
                      )));
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) =>
          //         Doneappointment(
          //             doctorname: widget.doctor,
          //             // doctoremail: widget.email,payment_token
          //             appointmenttime: body['appointment_time'],
          //             appointmentdate: body['appointment_date'])
          //             ));
          print(vl.body);
        }
      });
    }
  }

  Future<List> _rescheduleappointment() async {
    _formKey.currentState.validate();
    if (useremail.text.length == 0 ||
        phonenumber.text.length == 0 ||
        !useremail.text.contains("@")) {
      return null;
    }
    final rs = await http.post(apipath + '/modifyAppointmnet', body: {
      "appointment_id": widget.appointment_id.toString(),
      "appointment_date": widget.appointment_datetime.toLocal().toString(),
      "client_name": name.text,
      "client_address": address.text,
      "issue": problem.text,
      "phonenumber": phonenumber.text,
      "email": useremail.text,
      "holder_id": widget.holderid,
      "user_traiage_result_id": '-1',
      "user_id": _localid,
      'timezone': dateTime.timeZoneName
    }).then((vl) async {
      var body = json.decode(vl.body);
      if (body["msg"] == 'Doctor is not available on your selected time.') {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              // title: new Center(
              //   child:  Text("DOCTOR INFO"),
              //   ),
              content:
                  new Text("Doctor is not available on your selected time."),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new CircularProgressIndicator(),
                ],
              ),
            );
          },
        );
        new Future.delayed(new Duration(seconds: 2), () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AppointmentDone(
                      doctorname: widget.doctor,
                      doctoremail: widget.email,
                      appointmenttime:
                          widget.appointment_datetime.toString())));
        });
// Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => AppointmentDone(
//                   doctorname: widget.doctor,
//                   doctoremail: widget.email,
//                   appointmenttime: widget.appointment_datetime.toString())));
      }
    });
  }

  final String apiUrl = apipath + '/triage_test';

  DateTime _information;
  Future<List<dynamic>> fetchUsers() async {
    var result = await http.get(apiUrl);
    print(result.body);
    return json.decode(result.body);
  }

  void updateInformation(DateTime information) {
    if (information != null) {
      setState(() => widget.appointment_datetime = information);
    }
  }

  DateTime dd;
  var data;
  moveToSecondPage() async {
    await http.post(apipath + '/getBookedAppointmentSlot', body: {
      "selected_date": DateFormat('yMd').format(widget.appointment_datetime),
      "holder_id": widget.holderid,
      "timezone": dateTime.timeZoneName
    }).then((value) {
      data = json.decode(value.body);
      if (value.body != '[]') {
        booktime = data;
      }
// else {
//     data =[{"appointment_date" : "2021-10-13T00:00:00.000Z",
// "holder_id" :'',
// "appointment_time" : "00:00 AM"}];

// }
    });
    DateTime selected_datetime = await Navigator.push(
      context,
      CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => Dateselect(
                appointment_datetime: calendardate,
                holderid: widget.holderid,
                bookedtime: data,
                starttime: DateTime.parse(widget.starttime),
                endtime: DateTime.parse(widget.endtime),
                slotdifference: widget.slotdifference,
                // widget.appointment_datetime.toLocal()
              )),
    );
    updateInformation(selected_datetime);
  }
//   void moveToSecondPage() async {
// await http.post(apipath + '/getBookedAppointmentSlot', body: {
//       "selected_date": widget.appointment_datetime.toString(),
//       "holder_id": widget.holderid,
//       "timezone":dateTime.timeZoneName
//     }).then((value) async {
//       print(value.body);
//         var body = json.decode(value.body);
//         if(value.body!=null){
//    setState(() {
//         booktime=body['appointment_date'] ;
//         });
//         }

//  });

  // DateTime selected_datetime = await Navigator.push(
  //   context,
  //   CupertinoPageRoute(
  //       fullscreenDialog: true,
  //       builder: (context) =>
  //           Dateselect(appointment_datetime:calendardate,
  //           holderid:widget.holderid ,
  //          bookedtime: booktime,
  //           // widget.appointment_datetime.toLocal()
  //           )),
  // );
  // updateInformation(selected_datetime);
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //     bottomNavigationBar:
      //     Container(

      //       height: 100,

      //       child:
      //     Column(
      //       crossAxisAlignment: CrossAxisAlignment.stretch,
      //       children: [
      // // RaisedButton(
      // //       child: widget.appointment_id != null ?Text(
      // //         'UPDATE',
      // //         style: TextStyle(color: Colors.white),
      // //       ):Text(
      // //         'BOOK NOW, PAY LATER',
      // //         style: TextStyle(color: Colors.white),
      // //       ),
      // //       onPressed: () {
      // //         if (widget.appointment_id != null) {
      // //           _rescheduleappointment();
      // //         } else if (_localid != null) {
      // //           _createappointment();
      // //         } else {
      // //           _registerndata();
      // //         }
      // //       },
      // //       color: kPrimaryColor,
      // //     ),
      //     RaisedButton(
      //       child: widget.appointment_id != null ?Text(
      //         'UPDATE',
      //         style: TextStyle(color: buttonTextColor),
      //       ):Text(
      //         'BOOK',
      //         style: TextStyle(color: buttonTextColor),
      //       ),
      //       onPressed: () {
      //         if (widget.appointment_id != null) {
      //           _rescheduleappointment();
      //         } else if (_localid != null) {
      //           _createappointment();
      //         } else {
      //           _registerndata();
      //         }
      //       },
      //       color: buttonColor,
      //     ),
      //     ],) ,),

      body: SingleChildScrollView(
          child: Container(
        // color: kPrimaryLightColour,
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
                        width: 40,
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
                              Text(
                                'Book an appointment',
                                style: TextStyle(
                                    color: buttonTextColor, fontSize: 18),
                              ),
                            ]),
                      ),
                      Container(
                          height: 140,
                          padding: EdgeInsets.only(top: 2, left: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: greyContainer,
                                    border: Border.all(
                                        width: 1, color: containerBorderColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  child: Row(children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(left: 2),
                                      width: 65,
                                      height: 65,
                                      child: CircleAvatar(
                                        backgroundColor: containerBorderColor,
                                        child: ClipOval(
                                            child: widget.user_image != null
                                                ? CachedNetworkImage(
                                                    imageUrl: widget.user_image,
                                                    fit: BoxFit.fill,
                                                    width: 65.0,
                                                  )
                                                : Image.asset(
                                                    "assets/profile.png")
                                            //     CachedNetworkImage(
                                            //   imageUrl: widget.user_image==null?'assets/profile.png':widget.user_image,
                                            //   fit: BoxFit.fill,
                                            //   width: 65.0,
                                            // )
                                            ),
                                      ),
                                    ),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: 150,
                                            padding: EdgeInsets.only(
                                                top: 20, left: 11),
                                            child: Text(
                                              widget.doctor == null
                                                  ? ""
                                                  : widget.doctor,
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                padding:
                                                    EdgeInsets.only(left: 11),
                                                child: AutoSizeText(
                                                    '${'Availabilty:' + DateFormat.jm().format(DateTime.parse(widget.starttime).toLocal())}' ==
                                                            null
                                                        ? ""
                                                        : '${'Availabilty :  ' + DateFormat.jm().format(DateTime.parse(widget.starttime).toLocal())}',
                                                    style: TextStyle(
                                                        fontSize: 14)),
                                              ),
                                              AutoSizeText('-'),
                                              Container(
                                                child: AutoSizeText(
                                                    DateFormat.jm().format(DateTime
                                                                    .parse(widget
                                                                        .endtime)
                                                                .toLocal()) ==
                                                            null
                                                        ? ""
                                                        : DateFormat.jm().format(
                                                            DateTime.parse(widget
                                                                    .endtime)
                                                                .toLocal()),
                                                    style: TextStyle(
                                                        fontSize: 14)),
                                              ),
                                            ],
                                          )
                                          // Container(
                                          //   width: 150,
                                          //   padding: EdgeInsets.only(left: 11),
                                          //   child: Text(
                                          //       widget.email == null
                                          //           ? ""
                                          //           : widget.email,
                                          //       style: TextStyle(fontSize: 11)),
                                          // ),
                                        ]),
                                    // SizedBox(
                                    //   width: 15,
                                    // ),
                                    // GestureDetector(
                                    //   child: SvgPicture.asset(
                                    //       'assets/appointment.svg'),
                                    //   onTap: () {},
                                    // )
                                  ]))
                            ],
                          )),
                      Container(
                          padding: EdgeInsets.only(top: 6, left: 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              TextFormField(
                                controller: name,
                                keyboardType: TextInputType.emailAddress,
                                decoration: new InputDecoration(
                                    fillColor: greyContainer,
                                    filled: true,
                                    labelText: 'Name',
                                    border: new OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    )),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Form(
                                  key: _formKey,
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                        controller: useremail,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: new InputDecoration(
                                            fillColor: greyContainer,
                                            filled: true,
                                            labelText: 'Email',
                                            border: new OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0)),
                                            )),
                                        validator: (val) {
                                          if (val.length == 0)
                                            return "Please enter email";
                                          else if (!val.contains("@"))
                                            return "Please enter valid email";
                                        },
                                        onSaved: (val) => _email = val,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        controller: phonenumber,
                                        autocorrect: true,
                                        keyboardType: TextInputType.number,
                                        maxLength: 15,
                                        inputFormatters: <TextInputFormatter>[
                                          // WhitelistingTextInputFormatter
                                          //     .digitsOnly
                                        ],
                                        decoration: new InputDecoration(
                                            fillColor: greyContainer,
                                            filled: true,
                                            labelText: 'Phone number',
                                            border: new OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0)),
                                            )),
                                        validator: (val) {
                                          if (val.length == 0)
                                            return "Please enter phonenumber";
                                        },
                                        onSaved: (val) => _pphonenum = val,
                                      ),
                                    ],
                                  )),
                              Container(
                                  child: Row(
                                children: <Widget>[
                                  Container(
                                    // width: 180,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: greyContainer,
                                      border: Border.all(
                                          width: 1,
                                          color: containerBorderColor),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(
                                        5.0,
                                      )),
                                    ),
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 13, left: 2, right: 2),
                                        child: Text(
                                          widget.calendarvalue == '1'
                                              ?
                                              //  DateFormat('yMd HH:mm a').format(widget.appointment_datetime.toLocal()):
                                              //  DateFormat('yMd HH:mm a').format(widget.appointment_datetime.toLocal()),
                                              new DateFormat.yMd()
                                                  .add_jm()
                                                  .format(widget
                                                      .appointment_datetime
                                                      .toLocal())
                                              : new DateFormat.yMd()
                                                  .add_jm()
                                                  .format(widget
                                                      .appointment_datetime
                                                      .toLocal()),
                                          style: TextStyle(
                                            fontSize: 13,
                                          ),
                                        )),
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: greyContainer,
                                      border: Border.all(
                                          width: 1,
                                          color: containerBorderColor),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(
                                        5.0,
                                      )),
                                    ),
                                    child: IconButton(
                                        icon: Icon(Icons.timer),
                                        onPressed: () {
                                          moveToSecondPage();
                                        }),
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  widget.payment_required == true
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                              check == false
                                                  ? Container(
                                                      width: 80,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        color: greyContainer,
                                                        border: Border.all(
                                                            width: 1,
                                                            color:
                                                                containerBorderColor),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                          5.0,
                                                        )),
                                                      ),
                                                      child: TextFormField(
                                                        controller:
                                                            check == true
                                                                ? setfees
                                                                : fees,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            new InputDecoration(
                                                                fillColor:
                                                                    greyContainer,
                                                                filled: true,
                                                                labelText:
                                                                    'Fees',
                                                                contentPadding:
                                                                    EdgeInsets.only(
                                                                        left:
                                                                            14,
                                                                        right:
                                                                            14,
                                                                        top: 2),
                                                                border:
                                                                    new OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5.0)),
                                                                )),
                                                      ))
                                                  : Container()
                                            ])
                                      : Container(),
                                ],
                              )),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          )),
                      Container(
                          padding: EdgeInsets.only(top: 6, left: 5, right: 5),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                // widget.payment_required == true
                                //     ?
                                FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        press = true;
                                      });
                                    },
                                    child: press
                                        ? Column(
                                            //   crossAxisAlignment: CrossAxisAlignment.start,
                                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              TextFormField(
                                                controller: insurancename,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration: new InputDecoration(
                                                    fillColor: greyContainer,
                                                    filled: true,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            left: 14,
                                                            right: 14,
                                                            top: 2),
                                                    labelText:
                                                        'Insurance Provider',
                                                    border:
                                                        new OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5.0)),
                                                    )),
                                                validator: (val) {
                                                  if (val.length == 0)
                                                    return "Please enter Insurance Name";
                                                },
                                                onSaved: (val) =>
                                                    _insurancename = val,
                                              ),

                                              SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller: policynumber,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: new InputDecoration(
                                                    fillColor: greyContainer,
                                                    filled: true,
                                                    labelText: 'Policy Number',
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            left: 14,
                                                            right: 14,
                                                            top: 2),
                                                    border:
                                                        new OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5.0)),
                                                    )),
                                                validator: (val) {
                                                  if (val.length == 0)
                                                    return "Please enter PolicyNo";
                                                },
                                                onSaved: (val) =>
                                                    _policynum = val,
                                              ),
                                              //                   SizedBox(
                                              //                     height: 5,
                                              //                   ),
                                              //                   TextFormField(
                                              //                     controller:
                                              //                         policydescription,
                                              //                     keyboardType:
                                              //                         TextInputType
                                              //                             .emailAddress,
                                              //                     decoration:
                                              //                         new InputDecoration(
                                              //                             fillColor:
                                              //                                 Colors.grey[
                                              //                                     300],
                                              //                             filled:
                                              //                                 true,
                                              //                             labelText:
                                              //                                 'Description',
                                              //                             contentPadding: EdgeInsets.only(
                                              //                                 left:
                                              //                                     14,
                                              //                                 right:
                                              //                                     14,
                                              //                                 top: 2),
                                              //                             border:
                                              //                                 new OutlineInputBorder(
                                              //                               borderRadius:
                                              //                                   BorderRadius.all(
                                              //                                       Radius.circular(5.0)),
                                              //                             )),   validator: (val) {
                                              //   if (val.length == 0)
                                              //     return "Please enter Description";
                                              // },
                                              // onSaved: (val) => _policydes = val,
                                              //                   ),
                                              //                   SizedBox(
                                              //                     height: 5,
                                              //                   ),
                                              //                   TextFormField(
                                              //                     controller:
                                              //                         policynotes,
                                              //                     keyboardType:
                                              //                         TextInputType
                                              //                             .emailAddress,
                                              //                     decoration:
                                              //                         new InputDecoration(
                                              //                             fillColor:
                                              //                                 Colors.grey[
                                              //                                     300],
                                              //                             filled:
                                              //                                 true,
                                              //                             labelText:
                                              //                                 'Notes',
                                              //                             contentPadding: EdgeInsets.only(
                                              //                                 left:
                                              //                                     14,
                                              //                                 right:
                                              //                                     14,
                                              //                                 top: 2),
                                              //                             border:
                                              //                                 new OutlineInputBorder(
                                              //                               borderRadius:
                                              //                                   BorderRadius.all(
                                              //                                       Radius.circular(5.0)),
                                              //                             )),   validator: (val) {
                                              //   if (val.length == 0)
                                              //     return "Please enter Notes";
                                              // },
                                              // onSaved: (val) => _policynote = val,
                                              //                   ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    insurancegroupnumber,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration: new InputDecoration(
                                                    fillColor: greyContainer,
                                                    filled: true,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            left: 14,
                                                            right: 14,
                                                            top: 2),
                                                    labelText: 'Group Number',
                                                    border:
                                                        new OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5.0)),
                                                    )),
                                                validator: (val) {
                                                  if (val.length == 0)
                                                    return "Please enter InsuranceGroup Number";
                                                },
                                                onSaved: (val) =>
                                                    _insurancegoupnum = val,
                                              ),
                                            ],
                                          )
                                        : Container(
                                            height: 30,
                                            width: 160,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              border: Border.all(
                                                  width: 1,
                                                  color: containerBorderColor),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0)),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Add Insurance Info',
                                                style: TextStyle(fontSize: 16),
                                                textAlign: TextAlign.center,
                                              ),
                                            )))
                                // : null
                              ])),
                      SizedBox(
                        height: 8,
                      ),
                      widget.appointment_id == null &&
                              widget.payment_required == true
                          ? Container(
                              padding: EdgeInsets.only(left: 24),
                              height: 30,
                              child: Row(
                                children: [
                                  Text(
                                    'Pay Later',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Switch(
                                    value: check,
                                    onChanged: (value) {
                                      setState(() {
                                        check = value;
                                      });
                                      print(check);
                                    },
                                  ),
                                ],
                              ))
                          : Container(),
                      RaisedButton(
                        child: widget.appointment_id != null
                            ? Text(
                                'UPDATE',
                                style: TextStyle(color: buttonTextColor),
                              )
                            : Text(
                                'BOOK',
                                style: TextStyle(color: buttonTextColor),
                              ),
                        onPressed: () {
                          if (widget.appointment_id != null) {
                            _rescheduleappointment();
                          } else if (_localid != null) {
                            _createappointment();
                          } else {
                            _registerndata();
                          }
                        },
                        color: buttonColor,
                      ),
                    ]),
              ],
            )),
      )),
    );
  }
}
