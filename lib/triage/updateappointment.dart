// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:intl/intl.dart';
// import 'package:newagileapp/api.dart';
// import 'package:newagileapp/color.dart';
// import 'package:http/http.dart' as http;
// import 'package:newagileapp/datetime.dart';
// import 'package:newagileapp/screens/apptmntdone.dart';
// import 'package:newagileapp/triage/calendarscreen.dart';
// import 'package:newagileapp/updatedatetime.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Updateappointment extends StatefulWidget {
//   DateTime date;
//   final String time;
//   final String name;
//   final String address;
//   final String problem;
//   final String updateid;
//   final String modifyid;
//   final int appointment_id;
//   final String doctor;
//   final String email;
//   final String holderid;
//   final String doctorname;
//   final String doctoremail;
//   // final String username;
//   Updateappointment(
//       {this.date,
//       this.holderid,
//       this.doctorname,
//       this.doctoremail,
//       this.modifyid,
//       this.doctor,
//       this.email,
//       this.appointment_id,
//       this.time,
//       this.name,
//       // this.email,
//       this.address,
//       // ?this.doctor,
//       this.problem,
//       this.updateid});
//   @override
//   _TestcatState createState() => _TestcatState();
// }

// class _TestcatState extends State<Updateappointment> {
//   String _catg(dynamic user) {
//     return user['category'];
//   }

//   @override
//   void initState() {
//     super.initState();
//     name = new TextEditingController(text: widget.name);
//     address = new TextEditingController(text: widget.address);
//     problem = new TextEditingController(text: widget.problem);
//     datetime = new TextEditingController(text: widget.date.toString());
//     //  _time= new TextEditingController(text: widget.time);
//     getPref();

//     //  datetime=new TextEditingController(text: widget.date.toString());
//   }

//   SharedPreferences prefs;
//   String _description(dynamic user) {
//     return user['description'];
//   }

//   Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
//     Map<String, dynamic> newMap = {};
//     map.forEach((key, value) {
//       newMap[key.toString()] = map[key];
//     });
//     return newMap;
//   }

//   Map<DateTime, List<dynamic>> _events;
//   List<dynamic> _selectedEvents;
//   TextEditingController name = new TextEditingController();
//   TextEditingController address = new TextEditingController();
//   TextEditingController problem = new TextEditingController();
//   TextEditingController description = new TextEditingController();
//   TextEditingController datetime = new TextEditingController();
//   TextEditingController _time = new TextEditingController();
//   TextEditingController _username = new TextEditingController();
//   TextEditingController _adress = new TextEditingController();

// // Future<List> sendappointment() async {
// //   final response = await http.post(apipath + '/createAppointment',
// //     //"http://192.168.1.6:3040/createAppointment",
// //   //  "https://agilemedapp-cn4rzuzz6a-el.a.run.app/createAppointment",
// //    body: {
// //       "appointment_date":DateFormat('yyyy-MM-dd').format(widget.date),
// //     "client_name": name.text,
// //     "client_address1": address.text,
// //     "description":description.text,
// //     "issue":problem.text,

// //   });

// // }

//   String _date, name1, phone1, address1, _problem;
//   int id;
//   String _localid;
//   getPref() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     setState(() {
//       id = preferences.getInt("localid");
//       _localid = preferences.getString("id");
//       _date = preferences.getString("appointment_date");
//       name1 = preferences.getString("client_name");
//       address1 = preferences.getString("client_address");
//       _problem = preferences.getString("issue");
//     });
//   }

//   bool _login = false;
//   int _userid;

//   Future<List> _registerndata() async {
//     final response = await http.post(apipath + '/register', body: {
//       "username": name.text,
//       "address1": address.text,
//     }).then((value) async {
//       print(value.body);
//       var body = json.decode(value.body);
//       setState(() {
//         _userid = body['user_id'];
//         // _login = true;
//       });
//       SharedPreferences localStorage = await SharedPreferences.getInstance();

//       localStorage.setInt('localid', body['user_id']);
//       localStorage.setString('token', body['token']);
//       localStorage.setString('name', body['username']);
//       localStorage.setString('adrs', body['address1']);
//     });
//     register();
//   }

//   int appointmentid;
//   Future<List> register() async {
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     final response = await http.post(apipath + '/createAppointment', body: {
//       "appointment_date": _updatetime,
//       //DateFormat("yyyy-MM-dd").format( DateTime.parse(_information)),
//       "client_name": name.text,
//       "client_address": address.text,
//       // "description":description.text,
//       "issue": problem.text,
//       "user_id":
//           // id.toString(),
//           _userid.toString(),
//       "holder_id": widget.holderid,
//       "user_traiage_result_id": '1',
//     }).then((vl) async {
//       var body = json.decode(vl.body);
//       setState(() {
//         _login = true;
//       });

//       localStorage.setInt('date', body['appointment_date']);
//       // localStorage.setString('token', body['token']);
//       localStorage.setString('clientname', body['client_name']);
//       localStorage.setString('clientadrs', body['client_address']);
//       localStorage.setString('prblem', body['issue']);
//       print(vl.body);
//     });
//     if (localStorage.getString("token") != null) {
//       Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (BuildContext context) => EventSelect()),
//           (Route<dynamic> route) => false);
//     }
//   }

//   Future<List> _createappointment() async {
//     final response = await http.post(apipath + '/createAppointment', body: {
//       "appointment_date": _updatetime
//       //  DateFormat("yyyy-MM-dd").format( DateTime.parse(_information))
//       ,
//       //    "appointment_time":
//       // DateFormat("HH:MM").format( DateTime.parse(_information)) ,
//       "client_name": name.text,
//       "client_address": address.text,
//       // "description":description.text,
//       "issue": problem.text,
//       "user_id": _localid,
//       "holder_id": widget.holderid,
//       "user_traiage_result_id": '1',
//     }).then((vl) async {
//       var body = json.decode(vl.body);

//       // appointmentid= body[0]['appointment_id'];

//       SharedPreferences localStorage = await SharedPreferences.getInstance();
//       localStorage.setInt('date', body['appointment_date']);
//       //  localStorage.setString('token', body['token']);
//       // localStorage.setString('clientname', body['client_name']);
//       // localStorage.setString('clientadrs', body['client_address']);
//       // localStorage.setString('prblem', body['issue']);
//       print(vl.body);
//     });
//   }

//   Future<List> _modifyappointment() async {
//     final rs = await http.post(apipath + '/modifyAppointmnet', body: {
//       "appointment_id": widget.appointment_id.toString(),
//       "appointment_date": _updatetime,
//       "client_name": name.text,
//       "client_address": address.text,
//       // "description":description.text,
//       "issue": problem.text,
//       //abc
//       "holder_id": widget.holderid,
//       "user_traiage_result_id": '1',
//     }).then((vl) async {
//       //  return vl.body;
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => AppointmentDone(
//                   doctorname: widget.doctorname,
//                   doctoremail: widget.doctoremail,
//                   appointmenttime: _updatetime)));
//       // print(vl.body);
//     });
//   }

//   _rescheduleappointment() async {
//     final response = await http.post(apipath + '/rescheduleAppointmnet', body: {
//       "appointment_id": widget.updateid,
//       "appointment_date": _updatetime,
//     }).then((value) {
//       print(value.body);
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => AppointmentDone(
//                   doctorname: widget.doctor,
//                   doctoremail: widget.email,
//                   appointmenttime: _updatetime)));
//     });
//   }

//   final String apiUrl = apipath + '/triage_test';

//   String _updatetime;
//   Future<List<dynamic>> fetchUsers() async {
//     var result = await http.get(apiUrl);
//     print(result.body);
//     return json.decode(result.body);
//   }

//   void updateInformation(String info) {
//     setState(() => _updatetime = info);
//   }

//   void moveTotimePage() async {
//     final info = await Navigator.push(
//       context,
//       CupertinoPageRoute(
//           fullscreenDialog: true, builder: (context) => UpdateTimeDate()),
//     );
//     updateInformation(info);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//           child: Container(
//         padding: EdgeInsets.only(top: 15, left: 5, right: 5),
//         color: backgroundthemecolor,
//         child: new Container(
//             decoration: new BoxDecoration(
//                 color: backgroundthemecolor,
//                 borderRadius: new BorderRadius.only(
//                   topLeft: const Radius.circular(40.0),
//                   topRight: const Radius.circular(40.0),
//                 )),
//             padding: EdgeInsets.only(
//               top: 0,
//             ),
//             child: new Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: <Widget>[
//                       Container(
//                         height: 73,
//                         width: 40,
//                         decoration: new BoxDecoration(
//                             color: headerthemecolor,
//                             borderRadius: new BorderRadius.only(
//                               topLeft: const Radius.circular(40.0),
//                               topRight: const Radius.circular(40.0),
//                             )),
//                         child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: <Widget>[
//                               Padding(padding: EdgeInsets.only(left: 10)),
//                               IconButton(
//                                   icon: Icon(
//                                     Icons.arrow_back,
//                                     color: Colors.white,
//                                   ),
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   }),
//                               Padding(
//                                 padding: EdgeInsets.only(right: 30),
//                                 child: Text(
//                                   'Book an appointment',
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 18),
//                                 ),
//                               ),

//                               SizedBox(
//                                 width: 40,
//                               ),
//                               // IconButton(
//                               //     icon: Icon(
//                               //       Icons.power_settings_new,
//                               //       color: Colors.white,
//                               //     ),
//                               //     onPressed: null),
//                             ]),
//                       ),
//                       Container(
//                           padding:
//                               EdgeInsets.only(top: 20, left: 10, right: 10),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: <Widget>[
//                               Container(
//                                   height: 100,
//                                   decoration: BoxDecoration(
//                                     border: Border.all(
//                                         width: 3, color: Colors.grey),
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(5.0)),
//                                   ),
//                                   child: Row(children: <Widget>[
//                                     Container(
//                                       padding: EdgeInsets.only(left: 10),
//                                       height: 50,
//                                       width: 60,
//                                       decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(60)),
//                                       child:
//                                           // SvgPicture.asset('assets/appointment.svg'),

//                                           ClipRRect(
//                                         borderRadius:
//                                             BorderRadius.circular(60.0),
//                                         child: Hero(
//                                           tag: '',
//                                           child: Image(
//                                             height: 40.0,
//                                             width: 40.0,
//                                             image: AssetImage(
//                                                 'assets/profile.png'),
//                                             fit: BoxFit.fitHeight,
//                                           ),
//                                         ),
//                                       ),
//                                     ),

//                                     Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: <Widget>[
//                                           Container(
//                                             padding: EdgeInsets.only(
//                                                 top: 20, left: 11),
//                                             child: Text(
//                                               widget.doctorname,
//                                               //  widget.doctor,
//                                               style: TextStyle(fontSize: 15),
//                                             ),
//                                           ),
//                                           Container(
//                                             padding: EdgeInsets.only(left: 11),
//                                             child: Text(widget.doctoremail,
//                                                 //  widget.email,

//                                                 style: TextStyle(fontSize: 11)),
//                                           ),
//                                         ]),
//                                     SizedBox(
//                                       width: 80,
//                                     ),
//                                     GestureDetector(
//                                       child: SvgPicture.asset(
//                                           'assets/appointment.svg'),
//                                       onTap: () {},
//                                     )

//                                     //IconButton(icon: Icon(Icons.calendar_today_outlined,size: 36,), onPressed: null)
//                                   ]))
//                             ],
//                           )),
//                       Container(
//                           padding:
//                               EdgeInsets.only(top: 60, left: 20, right: 20),
//                           //  height: 60,
//                           // width: 20,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: <Widget>[
//                               TextFormField(
//                                 controller: name,
//                                 //  _username,
//                                 keyboardType: TextInputType.emailAddress,
//                                 decoration: new InputDecoration(
//                                     labelText: 'Name',
//                                     //    prefixIcon: Icon(Icons.location_city),
//                                     border: new OutlineInputBorder(
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(5.0)),
//                                     )),
//                               ),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               TextFormField(
//                                 controller: address,
//                                 // _adress,
//                                 keyboardType: TextInputType.emailAddress,
//                                 decoration: new InputDecoration(
//                                     labelText: 'Address',
//                                     //    prefixIcon: Icon(Icons.location_city),
//                                     border: new OutlineInputBorder(
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(5.0)),
//                                     )),
//                               ),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               TextFormField(
//                                 controller: problem,
//                                 keyboardType: TextInputType.emailAddress,
//                                 decoration: new InputDecoration(
//                                     labelText: 'Problem',
//                                     //    prefixIcon: Icon(Icons.location_city),
//                                     border: new OutlineInputBorder(
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(5.0)),
//                                     )),
//                               ),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               TextFormField(
//                                 //controller: useremail,
//                                 keyboardType: TextInputType.emailAddress,
//                                 decoration: new InputDecoration(
//                                     labelText: 'Photo of prescription of any',
//                                     suffixIcon: IconButton(
//                                         icon: Icon(Icons.camera_alt),
//                                         onPressed: () {
//                                           //  Navigator.push(context, MaterialPageRoute(builder: (context)=>Dateselect()));
//                                         }),
//                                     border: new OutlineInputBorder(
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(5.0)),
//                                     )),
//                               ),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               TextFormField(
//                                 //   enabled: true,
//                                 // showCursor: false,
//                                 //     readOnly: false,
//                                 //       autofocus: false,
//                                 controller: datetime,
//                                 //    keyboardType:,
//                                 decoration: new InputDecoration(
//                                     // labelText:  widget.date,
//                                     hintText: _updatetime,
//                                     suffixIcon: IconButton(
//                                         icon: Icon(Icons.timer),
//                                         onPressed: () {
//                                           datetime.clear();
//                                           moveTotimePage();
//                                           //   Navigator.push(context, MaterialPageRoute(builder: (context)=>Dateselect()));
//                                         }),
//                                     border: new OutlineInputBorder(
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(5.0)),
//                                     )),
//                               ),
//                               SizedBox(
//                                 height: 80,
//                               ),
//                               RaisedButton(
//                                 child: Text(
//                                   'UPDATE',
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                                 onPressed: () {
//                                   if (widget.updateid != null) {
//                                     _rescheduleappointment();
//                                   } else if (_localid != null &&
//                                       widget.modifyid == null) {
//                                     _createappointment();
//                                   } else if (widget.modifyid != null) {
//                                     _modifyappointment();
//                                   }
//                                 },
//                                 color: logincolr,
//                               )
//                             ],
//                           ))
//                     ]),
//               ],
//             )),
//       )),
//     );
//   }
// }
