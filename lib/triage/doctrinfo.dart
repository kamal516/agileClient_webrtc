import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:doctoragileapp/api.dart';
import 'package:doctoragileapp/color.dart';
import 'package:http/http.dart' as http;

import 'package:doctoragileapp/doctorlist.dart';
import 'package:doctoragileapp/triage/detailpage.dart';

class Doctorinfo extends StatefulWidget {
  final List<dynamic> detaildoctor;
  DateTime appoint_time;
  final String holder_id;
  final String price;
  final String starttime;
  final String endtime;
  final String slotdifference;
  Doctorinfo(
      {Key key,
      this.detaildoctor,
      this.appoint_time,
      this.holder_id,
      this.price,
      this.endtime,
      this.slotdifference,
      this.starttime})
      : super(key: key);
  @override
  @override
  _TestcatState createState() => _TestcatState();
}

class _TestcatState extends State<Doctorinfo> {
  String _catg(dynamic user) {
    return user['category'];
  }

  int modifyList;
  int donelist;
  int _id;

  String _description(dynamic user) {
    return user['description'];
  }

  final String apiUrl = apipath + '/triage_test';

  Future<List<dynamic>> fetchUsers() async {
    var result = await http.get(apiUrl);
    print(result.body);
    return json.decode(result.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.only(top: 15, left: 5, right: 5, bottom: 10),
      color: Colors.black,
      child: new Container(
          decoration: new BoxDecoration(
              color: greyContainer,
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(40.0),
                  topRight: const Radius.circular(40.0),
                  bottomLeft: const Radius.circular(40.0),
                  bottomRight: const Radius.circular(40.0))),
          padding: EdgeInsets.only(
            bottom: 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 15),
                child: Card(
                  shadowColor: containerBorderColor,
                  elevation: 15.0,
                  child: Column(children: <Widget>[
                    Container(
                      height: 125,
                      width: 150,
                      child: CircleAvatar(
                        backgroundColor: containerBorderColor,
                        //  radius: 5,
                        child: ClipOval(
                            child: CachedNetworkImage(
                          imageUrl: widget.detaildoctor[0]['user_profile'],
                          fit: BoxFit.fill,
                          width: 125.0,
                        )),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 16,
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              widget.detaildoctor[0]['username']
                              // 'Dr. Jai parkash tawde'
                              ,
                              style: TextStyle(
                                  fontSize: 18, color: blackTextColor),
                            ),
                            Text(
                              'Neurosurgeon',
                              style: TextStyle(
                                  fontSize: 15, color: blackTextColor),
                            ),
                            // RatingStars(4),
                          ],
                        ),

                        // SizedBox(width:10),
                        // IconButton(icon: Icon(Icons.chat), onPressed: (){

                        // }),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30, left: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 60,
                            child: Text('Medical School',
                                style: TextStyle(
                                    fontSize: 15, color: blackTextColor)),
                          ),
                          SizedBox(
                            width: 45,
                          ),
                          Container(
                            width: 200,
                            child: Text(widget.detaildoctor[0]['medicalschool'],
                                // 'MBBS,DNB(General medicine)',
                                style: TextStyle(
                                    fontSize: 15, color: blackTextColor)),
                          )
                        ],
                      ),
                    ),
                    // Padding(padding: EdgeInsets.only(top:30,left: 20),
                    //       child: Row(
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //         mainAxisAlignment: MainAxisAlignment.start,
                    //         children: <Widget>[
                    //          Container(
                    //            child:
                    //             Text('Department',style: TextStyle(fontSize: 15)),
                    //          ),
                    //         SizedBox(width: 34,),
                    //            Container(
                    //               width: 230,
                    //            child:
                    //             Text(
                    //               //widget.detaildoctor[0]['department']==null?"":widget.detaildoctor[0]['department'],
                    //              'Nephrologist',
                    //               style: TextStyle(fontSize: 15)),
                    //          )
                    //         ],
                    //       ),

                    //       ),
                    Padding(
                      padding: EdgeInsets.only(top: 30, left: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text('Speciality',
                                style: TextStyle(
                                    fontSize: 15, color: blackTextColor)),
                          ),
                          SizedBox(
                            width: 47,
                          ),
                          Container(
                            child: Text('Neurosurgeory',
                                style: TextStyle(
                                    fontSize: 15, color: blackTextColor)),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30, left: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text('Residency',
                                style: TextStyle(
                                    fontSize: 15, color: blackTextColor)),
                          ),
                          SizedBox(
                            width: 45,
                          ),
                          Container(
                            width: 200,
                            child: Text(widget.detaildoctor[0]['address1'],
                                // 'AgileMed Hospitals ,USA',
                                style: TextStyle(
                                    fontSize: 15, color: blackTextColor)),
                          )
                        ],
                      ),
                    ),
                    //  Padding(padding: EdgeInsets.only(top:30,left: 20),
                    // child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: <Widget>[
                    //    Container(
                    //      child:
                    //       Text('Language',style: TextStyle(fontSize: 15)),
                    //    ),
                    //    SizedBox(width: 49,),
                    //      Container(
                    //      child:
                    //       Text('English, Spanish',style: TextStyle(fontSize: 15)),
                    //    )
                    //   ],
                    // ),

                    // ),
                    SizedBox(
                      height: 60,
                    ),
                  ]),
                ),

                // margin: EdgeInsets.all(100.0),
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: RaisedButton(
                          onPressed: () {
                            // setState(() {
                            //   modifyList = 0;
                            //   donelist = 1;
                            // });
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Detailpage(
                                          appointment_datetime:
                                              widget.appoint_time,
                                          doctor: widget.detaildoctor[0]
                                              ['username'],
                                          holderid: widget.detaildoctor[0]
                                                  ['user_id']
                                              .toString(),
                                          user_image: widget.detaildoctor[0]
                                              ['user_profile'],
                                          price: widget.detaildoctor[0]['price']
                                              .toString(),
                                          payment_required:
                                              widget.detaildoctor[0]
                                                  ['is_payment_required'],
                                          starttime: widget.starttime,
                                          endtime: widget.endtime,
                                          slotdifference: widget.slotdifference,
                                        )));
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          color: buttonColor,
                          //donelist == 0 ?  Colors.grey : logincolr ,
                          //  borderSide: BorderSide(color: selectedIndex == index ? Colors.cyan : Colors.grey),
                          child: Text(
                            'BOOK AN APPOINTMENT',
                            style: TextStyle(color: buttonTextColor),
                          ),
                        )),
                    Container(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: RaisedButton(
                          onPressed: () {
                            // setState(() {
                            //   modifyList = 1;
                            //   donelist = 0;
                            // });
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Doctorlist()));
                            //  Navigator.pop(context);
                            //    Navigator.pop(context);
                            //      Navigator.pop(context);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          color: buttonColor,
                          //modifyList == 0 ?  Colors.grey : logincolr ,
                          //  borderSide: BorderSide(color: selectedIndex == index ? Colors.cyan : Colors.grey),
                          child: Text(
                            'BACK',
                            style: TextStyle(color: buttonTextColor),
                          ),
                        )),
                  ])
            ],
          )),
    ));
  }
}
