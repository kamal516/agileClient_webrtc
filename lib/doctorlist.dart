import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:doctoragileapp/api.dart';
import 'package:doctoragileapp/color.dart';
import 'package:doctoragileapp/categories.dart';
import 'package:doctoragileapp/screens/login.dart';
import 'package:doctoragileapp/triage/calendarscreen.dart';

import 'package:doctoragileapp/triage/detailpage.dart';
import 'package:doctoragileapp/triage/doctrinfo.dart';
import 'package:doctoragileapp/homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doctoragileapp/widgets/bottomnavbar.dart';

class Doctorlist extends StatefulWidget {
  final DateTime time;
  final DateTime appointment_date;
  Doctorlist({this.time, this.appointment_date});
  @override
  _DoctorListState createState() => _DoctorListState();
}

class _DoctorListState extends State<Doctorlist> {
  bool _hasBeenPressed = false;

  List<IconData> icnlst = [Icons.mail, Icons.access_alarm];
  List<IconData> icnDoctorlst = [Icons.assignment_turned_in, Icons.message];
  int selectedIndex;
  int selectedMale = 0;
  int selectedFemale;
  int selectedIndexList;
  int selectedIndexList1;
  List data;
  String _listbyid;
  void initState() {
    super.initState();
    //    if (widget.calendarvalue== '1') {
    //  calendardate= widget.appointment_datetime ;
    //   }
    //   else{
    //      calendardate= widget.appointment_datetime.toLocal() ;
    //   }
    _gettoken();
  }

  String _token;
  String _institute_id;
  _gettoken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _token = preferences.getString("token");
      _institute_id = preferences.getString("institute_id");
      // _listbyid = preferences.getString("appointment_id");
    });
    fetchdoctr();
    print(_institute_id);
  }

  String _user(dynamic user) {
    return user['username'];
  }

  String _holderid(dynamic user) {
    return user['user_id'];
  }

  List doctorbyiddata;
  List timeslot;
  int _id;
  String _email(dynamic user) {
    return user['email'];
  }

  TextEditingController _problem = new TextEditingController();

  Future<List> searchdoctor() async {
    if (_problem.text == '') {
      return fetchdoctr();
    } else {
      final response = await http.post(apipath + '/doctorListBySearch', body: {
        "username": _problem.text,
        "searchword": _problem.text,
        'selectedDate': widget.appointment_date.toString(),
        'institute_id': _institute_id.toString()
      }).then((result) async {
        result.body;
        if (result.body == '"No Data"') {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              //  Map<String, dynamic> user = jsonDecode(result.body);
              return AlertDialog(
                title: Text("No such specialist available"),
// content: const Text('This item is no longer available'),
                actions: [
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.pop(context);
                      fetchdoctr();
                    },
                  ),
                ],
              );
            },
          );
        }
        // else if(result.body=='"insert Keyword for search"'){
        //   return fetchdoctr();
        // }
        setState(() {
          alldocotor = jsonDecode(result.body);
        });
      });
    }
  }

  DateTime dateTime = DateTime.now();
  _fetcheddoctor(int index) async {
    final ddata = await http.post(apipath + '/doctorListById', body: {
      "user_id": alldocotor[index]["user_id"].toString(),
      'timezone': dateTime.timeZoneName
    }).then((value) {
      // return value.body;
      setState(() {
        doctorbyiddata = jsonDecode(value.body);
      });
      http.post(apipath + '/doctorListByIdAppointment', body: {
        'appointment_date': _senddate.toLocal().toString(),
        'timezone': _currenttime.timeZoneName,
        "user_id": alldocotor[0]['user_id'].toString(),
      }).then((val) {
        setState(() {
          timeslot = jsonDecode(val.body);
        });
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Doctorinfo(
                    detaildoctor: doctorbyiddata,
                    appoint_time: widget.appointment_date,
                    starttime: timeslot[0]['available_start_time'],
                    endtime: timeslot[0]['available_end_time'],
                    slotdifference: timeslot[0]['slot_size'])));
      });
    });
  }

  _doctordata(int index) async {
    final ddata = await http.post(apipath + '/doctorListById', body: {
      "user_id": data[index]["user_id"].toString(),
      'timezone': dateTime.timeZoneName
    }).then((value) {
      // return value.body;
      setState(() {
        doctorbyiddata = jsonDecode(value.body);
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Doctorinfo(
                    detaildoctor: doctorbyiddata,
                    appoint_time: widget.appointment_date,
                  )));
    });
  }

  List alldocotor;
  final String apiUrl = apipath + '/doctorList';
  DateTime _senddate;
  Future<List<dynamic>> fetchdoctr() async {
    if (widget.time != null) {
      _senddate = widget.time;
    } else {
      _senddate = widget.appointment_date;
    }
    var result = await http.post(apiUrl, body: {
      'selectedDate': _senddate.toLocal().toString(),
      //widget.appointment_date.toLocal().toString(),
      'timezone': dateTime.timeZoneName,
      'institute_id': _institute_id.toString()
    });

    setState(() {
      alldocotor = json.decode(result.body);
    });

    print(alldocotor);
  }

  DateTime _currenttime = DateTime.now();
  // _doctorlist(int index) async {

  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavBar(),
        body: SingleChildScrollView(
          child: Container(
            //       padding: EdgeInsets.only(top: 15, left: 5, right: 5),
            // color: Color(0xFF1b2b33),
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
                                  topLeft: const Radius.circular(0.0),
                                  topRight: const Radius.circular(40.0),
                                )),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  // IconButton(
                                  //     icon: Icon(
                                  //       Icons.arrow_back,
                                  //       color: Colors.white,
                                  //     ),
                                  //     onPressed: () {
                                  //       Navigator.pop(context);
                                  //     }),
                                  // SizedBox(
                                  //   width: 100,
                                  // ),

                                  Text(
                                    'SERVICE',
                                    style: TextStyle(
                                        color: buttonTextColor, fontSize: 19),
                                  ),

                                  // IconButton(
                                  //     icon: Icon(
                                  //       Icons.power_settings_new,
                                  //       color: Colors.white,
                                  //     ),
                                  //     onPressed: null),
                                ]),
                          ),
                        ]),
                    Container(
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(2)),
                      padding: EdgeInsets.only(top: 10, left: 0, right: 30),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 10, left: 2, right: 5),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Filter Doctor/ Specialist by Profile",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 16, color: buttonTextColor),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            Container(
                              height: 40,
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(width: 10),
                                  Flexible(
                                    child: TextFormField(
                                      controller: _problem,
                                      decoration: InputDecoration(
                                          fillColor: greyContainer,
                                          filled: true,
                                          border: OutlineInputBorder(),
                                          hintText: 'Search',
                                          suffixIcon: IconButton(
                                            icon: Icon(Icons.search),
                                            onPressed: () {
                                              searchdoctor();
                                            },
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Container(

                            //   height: 40,
                            //   padding: EdgeInsets.only(left:15,right: 15),
                            //     child:      TextFormField(
                            //      //   controller: useremail,
                            //         keyboardType: TextInputType.emailAddress,
                            //         decoration: new InputDecoration(

                            //             labelText: 'Search',
                            //             //    prefixIcon: Icon(Icons.location_city),
                            //             border: new OutlineInputBorder(
                            //               borderRadius: new BorderRadius.circular(5),
                            //             )),

                            //       ),
                            // ),
//                             SizedBox(
//                               height: 20,
//                             ),
//                             Row(
//                               children: <Widget>[
//                                 SizedBox(
//                                   width: 65,
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       selectedMale = 1;
//                                       selectedFemale = 0;
//                                     });
//                                   },
//                                   child: Container(
//                                     height: 80,
//                                     width: 80,
//                                     decoration: ShapeDecoration(
//                                       shape: CircleBorder(
//                                         side: BorderSide(
//                                             width: 3,
//                                             color: selectedFemale == 0
//                                                 ? Colors.purple
//                                                 : Colors.grey),
//                                       ),
//                                     ),
//                                     child: SvgPicture.asset(
//                                         'assets/male_doctor.svg'),
//                                     // Icon(Icons.add_a_photo,
//                                     //     color: selectedFemale == 0
//                                     //         ? Colors.purple
//                                     //         : Colors.grey),
//                                   ),
//                                 ),
// // customRadio(icnlst[0], 0),
//                                 SizedBox(
//                                   width: 60,
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       selectedMale = 0;
//                                       selectedFemale = 1;
//                                     });
//                                   },
//                                   child: Container(
//                                     height: 80,
//                                     width: 80,
//                                     decoration: ShapeDecoration(
//                                       shape: CircleBorder(
//                                         side: BorderSide(
//                                             width: 3,
//                                             color: selectedMale == 0
//                                                 ? Colors.purple
//                                                 : Colors.grey),
//                                       ),
//                                     ),
//                                     child: SvgPicture.asset(
//                                         'assets/female_doctor.svg'),
//                                     //  Icon(Icons.add_a_photo,
//                                     //     color: selectedMale == 0
//                                     //         ? Colors.purple
//                                     //         : Colors.grey),
//                                   ),
//                                 ),
// // customRadio(icnlst[1], 1),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             Row(
//                               children: <Widget>[
//                                 SizedBox(
//                                   width: 60,
//                                 ),
//                                 Text(
//                                   "Neurosurgeon",
//                                   style: TextStyle(fontSize: 15),
//                                 ),
//                                 SizedBox(
//                                   width: 35,
//                                 ),
//                                 Text(
//                                   "Chiropractic Care",
//                                   style: TextStyle(fontSize: 15),
//                                 ),
//                               ],
//                             )
                          ],
                        )),
                    Container(
                        height: (MediaQuery.of(context).size.height - 240),
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: ListView.builder(
                            itemCount:
                                alldocotor == null ? 0 : alldocotor.length,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              List<dynamic> user = alldocotor;
                              //if(data==null){
                              return Card(
                                  color: greyContainer,
                                  child: Row(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          _fetcheddoctor(index);
                                        },
                                        child: Container(
                                          width: 65,
                                          height: 65,
                                          padding: EdgeInsets.only(left: 2.0),
                                          child: CircleAvatar(
                                            backgroundColor: greyContainer,
                                            //radius: 5,
                                            child: ClipOval(
                                                child: user[index]
                                                            ['user_profile'] !=
                                                        null
                                                    ? CachedNetworkImage(
                                                        imageUrl: user[index]
                                                            ['user_profile'],
                                                        fit: BoxFit.fill,
                                                        width: 65.0,
                                                      )
                                                    : Image.asset(
                                                        "assets/profile.png")),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            ListTile(
                                              //  title: Text(result.body),
                                              title:
                                                  Text(user[index]['username']),
                                              subtitle: Text(
                                                  user[index]['email'] == null
                                                      ? ""
                                                      : user[index]['email']),
                                              onTap: () {
                                                final ddata = http.post(
                                                    apipath +
                                                        '/doctorListByIdAppointment',
                                                    body: {
                                                      'appointment_date':
                                                          _senddate
                                                              .toLocal()
                                                              .toString(),
                                                      'timezone': _currenttime
                                                          .timeZoneName,
                                                      "user_id": user[index]
                                                              ['user_id']
                                                          .toString(),
                                                    }).then((value) {
                                                  // return value.body;
                                                  setState(() {
                                                    doctorbyiddata =
                                                        jsonDecode(value.body);
                                                  });
                                                  print(DateFormat.jm().format(
                                                      DateTime.parse(
                                                          doctorbyiddata[0][
                                                              'available_start_time'])));
                                                  return Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Detailpage(
                                                                  starttime:
                                                                      doctorbyiddata[0][
                                                                          'available_start_time'],
                                                                  endtime: doctorbyiddata[0]
                                                                      [
                                                                      'available_end_time'],
                                                                  doctor: _user(
                                                                    user[index],
                                                                  ),
                                                                  email: _email(
                                                                    user[index],
                                                                  ),
                                                                  appointment_datetime:
                                                                      widget
                                                                          .appointment_date,
                                                                  holderid:
                                                                      user[index]['user_id']
                                                                          .toString(),
                                                                  user_image:
                                                                      user[index]
                                                                          [
                                                                          'user_profile'],
                                                                  payment_required:
                                                                      user[index]
                                                                          [
                                                                          'is_payment_required'],
                                                                  price: user[
                                                                          index]
                                                                      ['price'],
                                                                  slotdifference:
                                                                      doctorbyiddata[0]
                                                                          ['slot_size']
                                                                  // holderid: _holderid(
                                                                  //   snapshot.alldocotor[index],
                                                                  // ),
                                                                  )));
                                                });
                                                //  _doctorlist(user[index]['user_id']) ;
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             Detailpage(
                                                //                 doctor: _user(
                                                //                   user[index],
                                                //                 ),
                                                //                 email: _email(
                                                //                   user[index],
                                                //                 ),
                                                //                 appointment_datetime:
                                                //                     widget
                                                //                         .appointment_date,
                                                //                 holderid: user[
                                                //                             index]
                                                //                         [
                                                //                         'user_id']
                                                //                     .toString(),
                                                //                 user_image: user[
                                                //                         index][
                                                //                     'user_profile'],
                                                //                     payment_required: user[
                                                //                     index][
                                                //                 'is_payment_required'] ,
                                                //                 price: user[
                                                //                     index][
                                                //                 'price']
                                                //                 // holderid: _holderid(
                                                //                 //   snapshot.alldocotor[index],
                                                //                 // ),
                                                //                 )));
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 20)),
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Detailpage(
                                                          doctor: user[index]
                                                              ['username'],
                                                          email: user[index]
                                                              ['email'],
                                                          appointment_datetime:
                                                              widget
                                                                  .appointment_date,
                                                          //  widget
                                                          //     .timer
                                                          //     .toString(),
                                                          holderid: user[index]
                                                                  ['user_id']
                                                              .toString(),
                                                          user_image: user[
                                                                  index]
                                                              ['user_profile'],
                                                          // payment_required: user[
                                                          //     index][
                                                          // 'is_payment_required'] ,
                                                        )));
                                            // setState(() {
                                            //   selectedIndexList = 0;
                                            //   selectedIndexList1 = 1;
                                            // });
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             Detailpage()));
                                          },
                                          child: Container()
                                          //  Container(
                                          //   height: 33,
                                          //   width: 33,
                                          //   decoration: BoxDecoration(
                                          //       borderRadius:
                                          //           BorderRadius.circular(18),
                                          //       color: selectedIndexList == 0
                                          //           ? Colors.grey
                                          //           : themecolor),
                                          //   child: Icon(Icons.done_outline,
                                          //   color: Colors.white,
                                          //       // color: selectedIndexList == 0
                                          //       //     ? Colors.white
                                          //       //     : Colors.black
                                          //           ),
                                          // ),
                                          ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     // setState(() {
                                      //     //   selectedIndexList1 = 0;
                                      //     //   selectedIndexList = 1;
                                      //     // });
                                      //     // Navigator.push(
                                      //     //     context,
                                      //     //     MaterialPageRoute(
                                      //     //         builder: (context) =>
                                      //     //             Detailpage()));
                                      //   },
                                      //   child: Container(
                                      //     height: 36,
                                      //     width: 36,
                                      //     decoration: BoxDecoration(
                                      //         borderRadius:
                                      //             BorderRadius.circular(18),
                                      //         color: selectedIndexList1 == 0
                                      //             ? Colors.grey
                                      //             : menucahtcolr),

                                      //     child: Padding(
                                      //       padding:
                                      //           EdgeInsets.only(top: 4, left: 8),
                                      //       child: SvgPicture.asset(
                                      //         'assets/chat1.svg',
                                      //       ),
                                      //     ),

                                      //     // Icon(Icons.chat,
                                      //     //     color: selectedIndexList1 == 0
                                      //     //         ? Colors.white
                                      //     //         : Colors.black),
                                      //   ),
                                      // ),
                                    ],
                                  ));
                            })),
                  ],
                )),
          ),
        ));
  }
}
