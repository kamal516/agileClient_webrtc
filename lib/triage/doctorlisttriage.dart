// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:newagileapp/api.dart';
// import 'package:newagileapp/color.dart';
// import 'package:newagileapp/theme2.dart';
// import 'package:newagileapp/screens/login.dart';
// import 'package:newagileapp/triage/aptmntriage.dart';
// import 'package:newagileapp/triage/categories.dart';
// import 'package:newagileapp/triage/detailpage.dart';
// import 'package:newagileapp/triage/doctrinfo.dart';
// import 'package:newagileapp/upcomingappntmnt.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Doctorlist extends StatefulWidget {
//   final DateTime time;
//   final DateTime appointment_date;
//   Doctorlist({this.time, this.appointment_date});
//   @override
//   _DoctorListState createState() => _DoctorListState();
// }

// class _DoctorListState extends State<Doctorlist> {
//   bool _hasBeenPressed = false;

//   List<IconData> icnlst = [Icons.mail, Icons.access_alarm];
//   List<IconData> icnDoctorlst = [Icons.assignment_turned_in, Icons.message];
//   int selectedIndex;
//   int selectedMale = 0;
//   int selectedFemale;
//   int selectedIndexList;
//   int selectedIndexList1;
//   List data;
//   String _listbyid;
//   void initState() {
//     super.initState();
//     _gettoken();
//   }

//   String _token;
//   _gettoken() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     setState(() {
//       _token = preferences.getString("token");
//       // _listbyid = preferences.getString("appointment_id");
//     });
//   }

//   String _user(dynamic user) {
//     return user['username'];
//   }

//   String _holderid(dynamic user) {
//     return user['user_id'];
//   }

//   List doctorbyiddata;
//   int _id;
//   String _email(dynamic user) {
//     return user['email'];
//   }

//   TextEditingController _problem = new TextEditingController();
//   Future<List> searchdoctor() async {
//     final response = await http.post(apipath + '/doctorListBySearch',
//         //"http://192.168.1.6:3040/doctorListBySearch",
//         //  "https://agilemedapp-cn4rzuzz6a-el.a.run.app/createAppointment",
//         body: {
//           "username": _problem.text,
//           "searchword": _problem.text,
//         }).then((result) async {
//       result.body;
//       //     var doctordetail = json.decode(result.body);
//       // SharedPreferences localStorage = await SharedPreferences.getInstance();

//       // localStorage.setString('drdetailid', doctordetail['user_id'].toString());
//       setState(() {
//         data = jsonDecode(result.body);
//       });
//     });
//   }

// _fetcheddoctor(int index) async {
//     final ddata = await http.post(apipath + '/doctorListById', body: {
//       "user_id": index,
//     }).then((value) {
//      // return value.body;
//       setState(() {
//         doctorbyiddata = jsonDecode(value.body);
//       });
//     Navigator.pushReplacement(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) => Doctorinfo(
//                                                     detaildoctor:doctorbyiddata,
//                                                     appoint_time: widget.appointment_date,
//                                                   )));
//     });
//   }



//   _doctordata(int index) async {
//     final ddata = await http.post(apipath + '/doctorListById', body: {
//       "user_id": data[index]["user_id"].toString(),
//     }).then((value) {
//      // return value.body;
//       setState(() {
//         doctorbyiddata = jsonDecode(value.body);
//       });
//     Navigator.pushReplacement(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) => Doctorinfo(
//                                                     detaildoctor:doctorbyiddata,
//                                                     appoint_time: widget.appointment_date,
//                                                   )));
//     });
//   }

// List alldocotor;
//   final String apiUrl = apipath + '/doctorList';
//   //"http://192.168.1.6:3040/doctorList";

//   Future<List<dynamic>> fetchdoctr() async {
//     var result = await http.get(apiUrl);
//     print(result.body);
//   //      setState(() {
//   //                                alldocotor =json.decode(result.body);
//   //                             });
//  return json.decode(result.body);
//   //  print(alldocotor);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         bottomNavigationBar: BottomAppBar(
//             child: new Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey[300]),
//           ),
//           height: 80,
//           child: Row(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               Container(
//                   height: 50,
//                   //  width: 10,
//                   child: GestureDetector(
//                       onTap: () {
//                         if (_token != null) {
//                           Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => Upcomingappointment()));
//                         } else {
//                           return Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => Loginpage()));
//                         }
//                       },
//                       //  Navigator.push(context,
//                       //     MaterialPageRoute(builder: (context) => AppointmentList())),
//                       child: Container(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: <Widget>[
//                             Image.asset('assets/Home.png'),
//                             //  Image.asset('assets/home.jpg'),
//                             Text("HOME"),
//                           ],
//                         ),
//                       ))),
//               Container(
//                   height: 50,
//                   //  width: 10,
//                   child: GestureDetector(
//                       onTap: () => Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => EventSelect())),
//                       child: Container(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: <Widget>[
//                             SvgPicture.asset('assets/appointment.svg'),
//                             Text("CALENDAR"),
//                           ],
//                         ),
//                       ))),
//               Container(
//                   height: 50,
//                   //  width: 10,
//                   child: GestureDetector(
//                       onTap: () => Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => Categoryset())),
//                       child: Container(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: <Widget>[
//                             SvgPicture.asset('assets/service.svg'),
//                             Text("SERVICES"),
//                           ],
//                         ),
//                       ))),

//               //        Container(
//               //  height: 50,
//               // //  width: 10,
//               //  child:
//               //   GestureDetector(
//               //       onTap: () {},
//               //       //  Navigator.push(context,
//               //       //     MaterialPageRoute(builder: (context) => AppointmentList())),
//               //       child: Container(
//               //         child: Column(
//               //           mainAxisAlignment: MainAxisAlignment.spaceAround,
//               //           children: <Widget>[
//               //             SvgPicture.asset('assets/triage.svg'),
//               //             Text("TRIAGE"),
//               //           ],
//               //         ),
//               //       ))),
//               Container(
//                   height: 50,
//                   //  width: 10,
//                   child: GestureDetector(
//                       onTap: () {},
//                       // => Navigator.push(context,
//                       //     MaterialPageRoute(builder: (context) => AppointmentList())),
//                       child: Container(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: <Widget>[
//                             SvgPicture.asset('assets/chat.svg'),
//                             Text("CHAT"),
//                           ],
//                         ),
//                       ))),
//             ],
//           ),
//         )),
//         body: SingleChildScrollView(
//           child: Container(
//             padding: EdgeInsets.only(top: 15, left: 5, right: 5),
//             color: themecolor,
//             child: new Container(
//                 decoration: new BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: new BorderRadius.only(
//                       topLeft: const Radius.circular(40.0),
//                       topRight: const Radius.circular(40.0),
//                     )),
//                 padding: EdgeInsets.only(
//                   top: 0,
//                 ),
//                 child: new Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: <Widget>[
//                     Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           Container(
//                             height: 73,
//                             width: 40,
//                             decoration: new BoxDecoration(
//                                 color: logincolr,
//                                 borderRadius: new BorderRadius.only(
//                                   topLeft: const Radius.circular(40.0),
//                                   topRight: const Radius.circular(40.0),
//                                 )),
//                             child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                 children: <Widget>[
                             
//                                   IconButton(
//                                       icon: Icon(
//                                         Icons.arrow_back,
//                                         color: Colors.white,
//                                       ),
//                                       onPressed: () {
//                                         Navigator.pop(context);
//                                       }),
//                                   // SizedBox(
//                                   //   width: 100,
//                                   // ),
//                                   Padding(
//                                     padding: EdgeInsets.only(right: 110),
//                                     child: Text(
//                                       'SERVICE',
//                                       style: TextStyle(
//                                           color: Colors.white, fontSize: 19),
//                                     ),
//                                   ),

//                                   // IconButton(
//                                   //     icon: Icon(
//                                   //       Icons.power_settings_new,
//                                   //       color: Colors.white,
//                                   //     ),
//                                   //     onPressed: null),
//                                 ]),
//                           ),
//                         ]),
//                     Container(
//                       decoration:
//                           BoxDecoration(borderRadius: BorderRadius.circular(2)),
//                       padding: EdgeInsets.only(top: 10, left: 0, right: 30),
//                     ),
//                     Padding(
//                         padding: EdgeInsets.only(top: 10, left: 2, right: 5),
//                         child: Column(
//                           children: <Widget>[
//                             Text(
//                               "Filter Doctor/ Specialist by Profile",
//                               textAlign: TextAlign.left,
//                               style: TextStyle(fontSize: 16),
//                             ),
//                             SizedBox(
//                               height: 13,
//                             ),
//                             Container(
//                               height: 40,
//                               padding: EdgeInsets.only(left: 15, right: 15),
//                               child: Row(
//                                 children: <Widget>[
//                                   SizedBox(width: 10),
//                                   Flexible(
//                                     child: TextFormField(
//                                       controller: _problem,
//                                       decoration: InputDecoration(
//                                           border: OutlineInputBorder(),
//                                           hintText: 'Search',
//                                           suffixIcon: IconButton(
//                                             icon: Icon(Icons.search),
//                                             onPressed: () {
//                                               searchdoctor();
//                                             },
//                                           )),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             // Container(

//                             //   height: 40,
//                             //   padding: EdgeInsets.only(left:15,right: 15),
//                             //     child:      TextFormField(
//                             //      //   controller: useremail,
//                             //         keyboardType: TextInputType.emailAddress,
//                             //         decoration: new InputDecoration(

//                             //             labelText: 'Search',
//                             //             //    prefixIcon: Icon(Icons.location_city),
//                             //             border: new OutlineInputBorder(
//                             //               borderRadius: new BorderRadius.circular(5),
//                             //             )),

//                             //       ),
//                             // ),
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
//                           ],
//                         )),

                     
//                            FutureBuilder(
//                           future: fetchdoctr(),
//                           builder: (BuildContext context, AsyncSnapshot snapshot) {
//                             if ((snapshot.connectionState == ConnectionState.none &&
//                                     snapshot.hasData == null) ||
//                                 snapshot.data == null) {
//                               return Container();
//                             }
//                             if (snapshot.hasData) {
                         
//                               for (int i = 0; i <= snapshot.data.length; i++) {
//                                 print(snapshot.data);
//                               }
                          
// if(data==null){


//                               return

//                                            Container(
//                            height:  (MediaQuery.of(context).size.height - 240),
//                               padding: EdgeInsets.only(left:10,right: 10),
//                       child:
//                        ListView.builder(
//                       itemCount: snapshot.data.length,

//                      // itemCount: data==null?0:data.length,
//                       // shrinkWrap: true,
//                       // physics: ClampingScrollPhysics(),
//                       itemBuilder: (BuildContext context, int index) {
//                       List<dynamic> doctorlist  = snapshot.data;
// //                             setState(() {
// //   alldocotor=snapshot.data;
// // });
//                         return Card(
//                                   child: Row(
//                                 children: <Widget>[
//                                   GestureDetector(
//                                     onTap: () {
//                                       _doctordata(index);
//                                       // Navigator.pushReplacement(
//                                       //     context,
//                                       //     MaterialPageRoute(
//                                       //         builder: (context) => Doctorinfo(
//                                       //             //    detaildoctor:doctorbyiddata
//                                       //             )));
//                                     },
//                                     child: Container(
//                                         width: 55,
//                                         height: 45,
//                                         decoration: ShapeDecoration(
//                                             shape: CircleBorder(
//                                               side: BorderSide(
//                                                   width: 1,
//                                                   color: Theme.of(context)
//                                                       .primaryColor),
//                                             ),
//                                             image: DecorationImage(
//                                                 fit: BoxFit.fitHeight,
//                                                 image: AssetImage(
//                                                   "assets/profile.png",
//                                                 ),
//                                                 alignment: Alignment.center))),
//                                   ),
//                                   Expanded(
//                                     child: Column(
//                                       children: <Widget>[
//                                         ListTile(
//                                           //  title: Text(result.body),
//                                           title: Text(doctorlist[index]['username']),
//                                           subtitle: Text(doctorlist[index]['email']==null?"":doctorlist[index]['email']),
//                                           onTap: () {
//                                             Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         Detailpage(
//                                                              doctor:
//                                                              doctorlist[index]['username'],
                                                          
//                                                             email: doctorlist[index]['email'],
                                                          
//                                                             appointment_datetime:widget.appointment_date,
//                                                             //  widget
//                                                             //     .timer
//                                                             //     .toString(),
//                                                             holderid: doctorlist[index]['user_id'].toString()
                                                           
//                                                             )));
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Padding(padding: EdgeInsets.only(left: 20)),
//                                   GestureDetector(
//                                     onTap: () {
//                                         Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         Detailpage(
//                                                              doctor:
//                                                              doctorlist[index]['username'],
                                                          
//                                                             email: doctorlist[index]['email'],
                                                          
//                                                             appointment_datetime:widget.appointment_date,
//                                                             //  widget
//                                                             //     .timer
//                                                             //     .toString(),
//                                                             holderid: doctorlist[index]['user_id'].toString()
                                                           
//                                                             )));
//                                       // setState(() {
//                                       //   selectedIndexList = 0;
//                                       //   selectedIndexList1 = 1;
//                                       // });
//                                       // Navigator.push(
//                                       //     context,
//                                       //     MaterialPageRoute(
//                                       //         builder: (context) =>
//                                       //             Detailpage()));
//                                     },
//                                     child: Container(
//                                       height: 33,
//                                       width: 33,
//                                       decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(18),
//                                           color: selectedIndexList == 0
//                                               ? Colors.grey
//                                               : themecolor),
//                                       child: Icon(Icons.done_outline,
//                                           color: selectedIndexList == 0
//                                               ? Colors.white
//                                               : Colors.black),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 5,
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       // setState(() {
//                                       //   selectedIndexList1 = 0;
//                                       //   selectedIndexList = 1;
//                                       // });
//                                       // Navigator.push(
//                                       //     context,
//                                       //     MaterialPageRoute(
//                                       //         builder: (context) =>
//                                       //             Detailpage()));
//                                     },
//                                     child: Container(
//                                       height: 36,
//                                       width: 36,
//                                       decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(18),
//                                           color: selectedIndexList1 == 0
//                                               ? Colors.grey
//                                               : menucahtcolr),

//                                       child: Padding(
//                                         padding:
//                                             EdgeInsets.only(top: 4, left: 8),
//                                         child: SvgPicture.asset(
//                                           'assets/chat1.svg',
//                                         ),
//                                       ),

//                                       // Icon(Icons.chat,
//                                       //     color: selectedIndexList1 == 0
//                                       //         ? Colors.white
//                                       //         : Colors.black),
//                                     ),
//                                   ),
//                                 ],
//                               ));
                      
//                       })
//                     );
//                     }
//                     else if(data!=null)
//                       {
//                         return
//                       Container(
//                      height: (MediaQuery.of(context).size.height - 240),
//                         padding: EdgeInsets.only(left: 10, right: 10),
//                         child: ListView.builder(
//                             itemCount: data == null ? 0 : data.length,
//                             shrinkWrap: true,
//                             physics: ClampingScrollPhysics(),
//                             itemBuilder: (BuildContext context, int index) {
//                               List<dynamic> user = data;
//                               return Card(
//                                   child: Row(
//                                 children: <Widget>[
//                                   GestureDetector(
//                                     onTap: () {
//                                    _doctordata(index);
//                                   },
//                                     child: Container(
//                                         width: 55,
//                                         height: 45,
//                                         decoration: ShapeDecoration(
//                                             shape: CircleBorder(
//                                               side: BorderSide(
//                                                   width: 1,
//                                                   color: Theme.of(context)
//                                                       .primaryColor),
//                                             ),
//                                             image: DecorationImage(
//                                                 fit: BoxFit.fitHeight,
//                                                 image: AssetImage(
//                                                   "assets/profile.png",
//                                                 ),
//                                                 alignment: Alignment.center))),
//                                   ),
//                                   Expanded(
//                                     child: Column(
//                                       children: <Widget>[
//                                         ListTile(
//                                           //  title: Text(result.body),
//                                           title: Text(user[index]['username']),
//                                           subtitle: Text(user[index]['email']==null?"":user[index]['email']),
//                                           onTap: () {
//                                             Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         Detailpage(
//                                                              doctor: _user(
//                                                               data[index],
//                                                             ),
//                                                             email:   _email(
//                                                               data[index],
//                                                             ),
//                                                             appointment_datetime: widget
//                                                                 .appointment_date
//                                                                 ,
//                                                             holderid: data[
//                                                                         index]
//                                                                     ['user_id']
//                                                                 .toString()
//                                                             // holderid: _holderid(
//                                                             //   snapshot.data[index],
//                                                             // ),
//                                                             )));
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Padding(padding: EdgeInsets.only(left: 20)),
//                                   GestureDetector(
//                                     onTap: () {
//                                         Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         Detailpage(
//                                                              doctor:
//                                                              snapshot.data[index]['username'],
                                                          
//                                                             email: snapshot.data[index]['email'],
                                                          
//                                                             appointment_datetime:widget.appointment_date,
//                                                             //  widget
//                                                             //     .timer
//                                                             //     .toString(),
//                                                             holderid: snapshot.data[index]['user_id'].toString()
                                                           
//                                                             )));
//                                       // setState(() {
//                                       //   selectedIndexList = 0;
//                                       //   selectedIndexList1 = 1;
//                                       // });
//                                       // Navigator.push(
//                                       //     context,
//                                       //     MaterialPageRoute(
//                                       //         builder: (context) =>
//                                       //             Detailpage()));
//                                     },
//                                     child: Container(
//                                       height: 33,
//                                       width: 33,
//                                       decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(18),
//                                           color: selectedIndexList == 0
//                                               ? Colors.grey
//                                               : themecolor),
//                                       child: Icon(Icons.done_outline,
//                                           color: selectedIndexList == 0
//                                               ? Colors.white
//                                               : Colors.black),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 5,
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       // setState(() {
//                                       //   selectedIndexList1 = 0;
//                                       //   selectedIndexList = 1;
//                                       // });
//                                       // Navigator.push(
//                                       //     context,
//                                       //     MaterialPageRoute(
//                                       //         builder: (context) =>
//                                       //             Detailpage()));
//                                     },
//                                     child: Container(
//                                       height: 36,
//                                       width: 36,
//                                       decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(18),
//                                           color: selectedIndexList1 == 0
//                                               ? Colors.grey
//                                               : menucahtcolr),

//                                       child: Padding(
//                                         padding:
//                                             EdgeInsets.only(top: 4, left: 8),
//                                         child: SvgPicture.asset(
//                                           'assets/chat1.svg',
//                                         ),
//                                       ),

//                                       // Icon(Icons.chat,
//                                       //     color: selectedIndexList1 == 0
//                                       //         ? Colors.white
//                                       //         : Colors.black),
//                                     ),
//                                   ),
//                                 ],
//                               ));
//                             }));
//                     }

//                             } else {
//                               return Center(child: CircularProgressIndicator());
//                             }
//                           })
//                           // ),

                    
//                   ],
//                 )),
//           ),
//         ));
//   }
// }
