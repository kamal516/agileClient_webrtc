import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:doctoragileapp/api.dart';
import 'package:doctoragileapp/color.dart';
import 'package:doctoragileapp/screens/chatlist.dart';
import 'package:doctoragileapp/screens/login.dart';
import 'package:doctoragileapp/screens/menuscreen.dart';
import 'package:doctoragileapp/screens/notificationlist.dart';
import 'package:doctoragileapp/triage/detailpage.dart';
import 'package:doctoragileapp/widgets/ZoomMeeting.dart';
import 'package:doctoragileapp/widgets/bottomnavbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Upcomingappointment extends StatefulWidget {
  final String user_name;
  Upcomingappointment({this.user_name});
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<Upcomingappointment> {
  String _email;
  String _password;
  final formkey = new GlobalKey<FormState>();
  FormType _formtype = FormType.login;
  TextEditingController useremail = new TextEditingController();
  TextEditingController userpassword = new TextEditingController();
  TextEditingController _name = new TextEditingController();
// TextEditingController _description =new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _address = new TextEditingController();

  getmodifybutton() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double multiplier = 1.6;
    return Text(
      'MODIFY',
      style: TextStyle(
        color: buttonTextColor,
        fontSize: multiplier * unitHeightValue,
      ),
    );
  }

  setdoctorname(String name) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double multiplier = 1.9;
    return Text(
      name,
      style: TextStyle(
        color: blackTextColor,
        fontWeight: FontWeight.bold,
        fontSize: multiplier * unitHeightValue,
      ),
    );
  }
//         setmodifybuttom(){
//           double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
//  double multiplier = 1.8;
//  return Text(
//  'Modify',

//   style: TextStyle( color: Colors.white,
//     fontSize: multiplier * unitHeightValue,
//   ),
//  );
//      }
  getdatetime(var settime) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double multiplier = 1.6;
    return Text(
      settime,
      style: TextStyle(
        color: textColor,
        fontSize: multiplier * unitHeightValue,
      ),
    );
  }

  _deleteappointment(int apointid) async {
    final response = await http.post(apipath + '/cancelAppointmnet', body: {
      "appointment_id": apointid.toString(),
      "holder_id": appointmentdata[0]['holder_id'].toString(),
      "username": appointmentdata[0]['client_name'],
      "user_id": _localuserid,
      'timezone': dateTime.timeZoneName
      //checkid.toString(),
    }).then((test) {
      appointmentByCurrentDate();
      Navigator.pop(context);
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>EventSelect()));
    });
  }

  bool validateandsave() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  String token_id;
  String _localuserid;
  String _userid;
  String _loginedusername;
  String _localuseremail;
  bool _verifyvalue;
  @override
  void initState() {
    super.initState();
    _settoken();
    _getScreen();
  }

  bool _homeScreen;
  bool _chatScreen = false;
  bool _serviceScreen = false;
  bool _eventScreen = false;
  _getScreen() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _homeScreen = true;
    });
    preferences.setBool("HomePage", _homeScreen);
    preferences.setBool("ChatPage", _chatScreen);
    preferences.setBool("ServicePage", _serviceScreen);
    preferences.setBool("EventPage", _eventScreen);
  }

  @override
  void deactivate() {
    if (_timer.isActive) {
      _timer.cancel();
    } else {
      startTimer();
    }
    super.deactivate();
  }

  _settoken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _localuserid = preferences.getString("id");
      _loginedusername = preferences.getString("name");
      token_id = preferences.getString("token");
      _localuseremail = preferences.getString("email");
      _verifyvalue = preferences.getBool("verifyvalue");
      if (_verifyvalue != null) {
        _verifyvalue = preferences.getBool("verifyvalue");
      }
      //     else {

      // setState(() {
      //         _verifyvalue = false;
      //       });

      //     }
    });
    //   await http.post(
    //   'https://fcm.googleapis.com/fcm/send',
    //   headers: <String, String>{
    //     'Content-Type': 'application/json',
    //     'Authorization': 'AAAAPxfcBfI:APA91bHxtQ1J28ljJyFxbxW6zVmUtiRS8CjHJw83dWQbW75CYz-Bb1AhWqDivQVseDDeiTekUjZWBS7a22pBEPBFRA9dxkFIOFSVwIBaFDDMke3kZH9dcm8Y-75rIKoDVz3IVJQz409-',
    //   },
    //   body: jsonEncode(
    //     <String, dynamic>{
    //       'notification': <String, dynamic>{
    //         'body': _loginedusername,
    //         'title': 'FlutterCloudMessage'
    //       },
    //       'priority': 'high',
    //       'data': <String, dynamic>{
    //         'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    //         'id': '1',
    //         'status': 'done'
    //       },
    //       'to': token_id,
    //     },
    //   ),
    // );
    startTimer();
    appointmentByCurrentDate();
    noUserLogout();
//  confirmationalert();
    // _getsignupdata();
  }

  var confirmedstatus;
  confirmationstatus(BuildContext context, int selected_id) async {
    final response = await http.post(apipath + '/confirmAppointmentByClient',
        body: {'appointment_id': selected_id.toString()}).then((result) {
      result.body;
      setState(() {
        confirmedstatus = jsonDecode(result.body);
      });
      if (confirmedstatus['msg'] == 'Updated') {
        Navigator.pop(context);
      }
      return confirmedstatus['msg'];
    });
  }

  void startTimer() {
    _timer = new Timer.periodic(new Duration(seconds: 1), (time) {
      //  print(time);
      _getmessage();
      appointmentByCurrentDate();
    });
  }

  DateTime dateTime = DateTime.now();

  Timer _timer;
  List fetchmeassagedata = [];
  _getmessage() async {
    final response = http.post(apipath + '/getNotification', body: {
      "user_id": _localuserid,
      'timezone': dateTime.timeZoneName
    }).then((result) async {
      // print(result.body);
      setState(() {
        fetchmeassagedata = jsonDecode(result.body);
      });
      // print(fetchmeassagedata);
    });
  }

  List doctorbyiddata;
// last_message
  appointmentByCurrentDate() async {
    final response = http.post(apipath + '/getAppointmentByCurrentDate', body: {
      "user_id": _localuserid,
      'timezone': dateTime.timeZoneName
    }).then((result) {
      result.body;
      setState(() {
        appointmentdata = jsonDecode(result.body);
      });
      _getmessage();
    });
  }

  AlertDialog alert = AlertDialog(
    title: Text("Notice"),
    content: Text("go to login"),
  );

  int selectedIndex;
  int selectedMale = 0;
  int selectedFemale;
  int selectedIndexList;
  int selectedIndexList1;
  List appointmentdata;
  String _username(dynamic user) {
    return user[' client_name'];
  }

  int _id;
  String _specalist(dynamic user) {
    return user['email'];
  }

  String _problrm(dynamic user) {
    return user['issue'];
  }

  void movetoRegister() {
    formkey.currentState.reset();
    setState(() {
      _formtype = FormType.register;
    });
  }

  bool verify = false;

  var data;
// DateTime dateTime = DateTime.now();
  void noUserLogout() async {
    http.post(apipath + '/checkUser', body: {'user_id': _localuserid}).then(
        (value) async {
      setState(() {
        data = jsonDecode(value.body);
      });

      if (data[0]['msg'] == 'User not Available') {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.remove('localid');
        localStorage.remove('token');
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Loginpage()),
            (Route<dynamic> route) => false);
      } else {
        _getsignupdata();
      }
    });
  }

  void _getsignupdata() async {
    http.post(apipath + '/verifyUser', body: {
      'email': _localuseremail,
      'timezone': dateTime.timeZoneName
    }).then((result) async {
      // print(result.body);
      setState(() {
        data = jsonDecode(result.body);
      });

      if (data['error'] == 'User is Not-Verified') {
        setState(() {
          _verifyvalue = false;
        });
        confirmationalert();
      }

      if (data['result'] == "User is Verified") {
        if (_verifyvalue == false) {
          setState(() {
            _verifyvalue = true;
          });
          SharedPreferences localStorage =
              await SharedPreferences.getInstance();

          localStorage.setBool('verifyvalue', _verifyvalue);
          return Navigator.of(
            context,
          ).pop();
        } else {
          print('object');
        }
      }
    });
  }

  //  BuildContext dialogContext;

  confirmationalert() {
    if (_verifyvalue == true) {
      // print(_verifyvalue);
    } else if (_verifyvalue == false) {
      if (_opensdialog == true) {
        // print(_opensdialog);
      } else if (_opensdialog == false) {
        setState(() {
          _opensdialog = true;
        });
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              _timer = Timer.periodic(new Duration(seconds: 3), (time) {
                _getsignupdata();
                //   Navigator.of(context).pop();
//             if(data['result'] == "User is Verified"){
//  Navigator.of(context).pop();
//             }
              });
              //   dialogContext = context;
              return WillPopScope(
                  onWillPop: () {},
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0))),
                    contentPadding: EdgeInsets.only(bottom: 20),
                    content: Container(
                      // height: 210,
                      width: 300.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 12, bottom: 20.0),
                            decoration: BoxDecoration(
                              color: disclaimerHeaderColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(32.0),
                                  topRight: Radius.circular(32.0)),
                            ),
                            child: Text(
                              "TITLE",
                              style:
                                  TextStyle(color: disclaimerHeaderTextColor),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Column(
                            // crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Email Confirmation',
                                style: TextStyle(
                                    color: disclaimerTextcolor,
                                    fontSize: 21,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.justify,
                              ),
                              Container(
                                height: 80,
                                width: 60,
                                decoration: BoxDecoration(
                                    color: iconColor,
                                    shape: BoxShape.rectangle),
                                child: Image.asset('assets/processed.jpeg'),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                'A verification link has been sent successfully to your email.\nCheck your email account',
                                style: TextStyle(
                                    color: disclaimerTextcolor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ));
            });
        //     then((val) {
        //   setState(() {
        //     _opensdialog = true;
        //   });
        //   if (_timer.isActive) {
        //     _timer.cancel();
        //   }
        //   // setState(() {
        //   //   _opensdialog = true;
        //   // });
        // });
      }
    }
  }

  bool _opensdialog = false;
  void signout() async {
    setState(() {});

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.clear();
    localStorage.remove('name');
    localStorage.remove('id');
    localStorage.remove('token');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Loginpage()),
        (Route<dynamic> route) => false);
  }

  void movetoLogin() {
    formkey.currentState.reset();
    setState(() {
      _formtype = FormType.login;
    });
  }

  _getZoomDetails(String _zoomDetails) {
    if (_zoomDetails == null) {
      return Container();
    } else {
      var _replaceMeeting = _zoomDetails
          .replaceAll(":", "&")
          .replaceAll("?", "&")
          .replaceAll("=", "&");
      var _getMeetingCred = _replaceMeeting.split("&");
      // var _replace = user[index]['last_message']
      //     .replaceAll("/", "&")
      //     .replaceAll("?", "&")
      //     .replaceAll("#", "&");
      // var _splittext = _replace.split("&");
      if (_getMeetingCred[0].contains("**meeting")) {
        return GestureDetector(
          onTap: () {
            // setState(() {
            //   selectedIndexList1 = 0;
            //   selectedIndexList = 1;
            // });
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return MeetingWidget(
                      displayname: _loginedusername,
                      meetingId: _getMeetingCred[1].toString(),
                      meetingPassword: _getMeetingCred[3].toString());
                },
              ),
            );
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => Chatlist(
            //               doctorname: user[index]['doctorname'],
            //               holderid: user[index]['holder_id'].toString(),
            //             )));
          },
          child: Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  //chat message inside appointment screen.
                  color: selectedIndexList1 == 0
                      ? Colors.grey
                      : videoiconBackgroundColor),
              child: Center(
                child: Icon(
                  Icons.videocam,
                  color: iconColor,
                ),
              )
              //     Padding(
              //   padding: EdgeInsets.only(
              //       top:
              //           4,
              //       left:
              //           8),
              //   child: SvgPicture
              //       .asset(
              //     'assets/chat1.svg',
              //     color:
              //         Colors.white,
              //   ),
              // ),
              ),
        );
      } else {
        return Container();
      }
    }
  }

  bool _login = false;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        bottomNavigationBar: BottomNavBar(),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 1.1,
                color: backgroundColor,
                child: Stack(
                  children: <Widget>[
                    // SvgPicture.asset('assets/bg.svg'),
                    Padding(
                      padding: EdgeInsets.only(top: 0, left: 0),
                      child: Image(
                        height: 190.0,
                        width: 450.0,
                        image: AssetImage('assets/Logo_new.png'),
                        fit: BoxFit.contain,
                      ),
                    ),

                    // SizedBox(height: 30,),

                    // Padding(
                    //   padding: EdgeInsets.only(top: 35, left: 30),
                    //   child: SvgPicture.asset(
                    //     'assets/monitor.svg',
                    //     height: 140,
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 55, left: 300),
                    //   child: SvgPicture.asset(
                    //     'assets/man.svg',
                    //     height: 110,
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.only(top: 200),
                      child: new Container(
                          decoration: new BoxDecoration(
                              boxShadow: [
                                new BoxShadow(
                                  color: backgroundColor,
                                  blurRadius: 20.0,
                                ),
                              ],
                              color: homescreenContainerColor,
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(40.0),
                                topRight: const Radius.circular(40.0),
                              )),
                          padding:
                              EdgeInsets.only(top: 50, left: 20, right: 20),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
//                             Container(
// // padding: EdgeInsets.only(left: 10, bottom: 10),
//                               child:
//                                Text(
//                                 'Welcome!',
//                                 style:
//                                     TextStyle(fontSize: 15, color: Colors.grey),
//                               ),
//                             ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Welcome!",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: greyTextColor)),
                                      Text(
                                          //widget.user_name==null?"Loading...": widget.user_name
                                          _loginedusername == null
                                              ? "Loading..."
                                              : _loginedusername,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: blackTextColor,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 90,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Notificationlist()));
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      child: Stack(
                                        children: [
                                          // Image.asset('assets/bell.png'),
                                          SvgPicture.asset('assets/Belll.svg'),
                                          Container(
                                            width: 30,
                                            height: 30,
                                            alignment: Alignment.topCenter,
                                            margin: EdgeInsets.only(top: 0),
                                            child: Container(
                                              width: 15,
                                              height: 15,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: belliconCircle,
                                                  border: Border.all(
                                                      color: iconColor,
                                                      width: 1)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: Center(
                                                  child: Text(
                                                    fetchmeassagedata.length
                                                                .toString() ==
                                                            null
                                                        ? ''
                                                        : fetchmeassagedata
                                                            .length
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontSize: 8,
                                                        color:
                                                            belliconCircleTextColor),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //   GestureDetector(
                                  //   onTap: (){
                                  //     signout();
                                  //   },
                                  //   child:
                                  //   Container(
                                  //     child:
                                  //       Image.asset('assets/poweroff.jpg')
                                  //       ),
                                  // ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: 20,
                              ),
                              Text("Upcoming Appointments",
                                  style: TextStyle(
                                      fontSize: 12, color: greyTextColor)),
                              SizedBox(
                                height: 5,
                              ),
                              Expanded(
                                  child: ListView.builder(
                                      itemCount: appointmentdata == null
                                          ? 0
                                          : appointmentdata.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Card(
                                            shape: RoundedRectangleBorder(
                                                // if you need this
                                                side: BorderSide(
                                              color: appointmentCardborderColor,
                                              width: 1,
                                            )),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Container(
                                                        child: Row(
                                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 5),
                                                          child: CircleAvatar(
                                                              radius: 30,
                                                              child: ClipOval(
                                                                child: appointmentdata[index]
                                                                            [
                                                                            'user_profile'] !=
                                                                        null
                                                                    ? CachedNetworkImage(
                                                                        imageUrl:
                                                                            appointmentdata[index]['user_profile'],
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        width:
                                                                            65.0,
                                                                      )
                                                                    : Image.asset(
                                                                        "assets/profile.png")
                                                                // CachedNetworkImage(imageUrl: appointmentdata[index]['user_profile']==null?Image.asset('assets/profile.png'):appointmentdata[index]['user_profile'],fit: BoxFit.fill,width: 65,)
                                                                ,
                                                              )),
                                                        ),
                                                        SizedBox(
                                                          width: 12,
                                                        ),
                                                        Container(
                                                          width: 120,
                                                          child: setdoctorname(
                                                              appointmentdata[
                                                                      index][
                                                                  'doctorname']),
                                                        )
                                                      ],
                                                    )),
                                                    Container(
                                                        child: Row(
                                                      children: [
                                                        _getZoomDetails(
                                                            appointmentdata[
                                                                    index][
                                                                'last_message']),
                                                        SizedBox(
                                                          width: 2,
                                                        ),
                                                        GestureDetector(
                                                            onTap: () {
                                                              return showDialog(
                                                                  context:
                                                                      context,
                                                                  barrierDismissible:
                                                                      false,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(32.0))),
                                                                      title:
                                                                          Column(
                                                                        children: <
                                                                            Widget>[
                                                                          Container(
                                                                            child:
                                                                                Text('CONFIRMATION'),
                                                                          ),
                                                                          Divider(
                                                                              color: dividerColor),
                                                                          SizedBox(
                                                                            height:
                                                                                20,
                                                                          ),
                                                                          Container(
                                                                              width: 200.0,
                                                                              height: 100.0,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(67),
                                                                              ),
                                                                              child: Text(
                                                                                'Are you sure you would like to cancel your appointment?',
                                                                                style: TextStyle(color: disclaimerTextcolor, fontSize: 15, fontWeight: FontWeight.w600),
                                                                                textAlign: TextAlign.center,
                                                                              )),
                                                                        ],
                                                                      ),
                                                                      content:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        children: <
                                                                            Widget>[
                                                                          RaisedButton(
                                                                              color: buttonColor,
                                                                              child: Text(
                                                                                'YES',
                                                                                style: TextStyle(color: buttonTextColor),
                                                                              ),
                                                                              onPressed: () async {
                                                                                _deleteappointment(appointmentdata[index]['appointment_id']);
                                                                                // Navigator.pop(context);
                                                                              }),
                                                                          RaisedButton(
                                                                              color: disclaimeridontButtonColor,
                                                                              child: Text(
                                                                                'NO',
                                                                                style: TextStyle(color: buttonTextColor),
                                                                              ),
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                              })
                                                                        ],
                                                                      ),
                                                                    );
                                                                  });
                                                            },
                                                            child: appointmentdata[
                                                                            index]
                                                                        [
                                                                        'is_cancellation_expire'] ==
                                                                    false
                                                                ? Container()
                                                                : Container(
                                                                    height: 32,
                                                                    width: 32,
                                                                    decoration: BoxDecoration(
                                                                        color:
                                                                            deleteiconBackgroundColor,
                                                                        shape: BoxShape
                                                                            .circle),
                                                                    child: Padding(
                                                                        padding: EdgeInsets.only(top: 4, left: 10),
                                                                        child: Center(
                                                                          child: SvgPicture.asset(
                                                                              'assets/Delete.svg',
                                                                              color: iconColor),
                                                                        )))),
                                                        SizedBox(
                                                          width: 2,
                                                        ),
                                                        GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          Chatlist(
                                                                            doctorname:
                                                                                appointmentdata[index]['doctorname'],
                                                                            holderid:
                                                                                appointmentdata[index]['holder_id'].toString(),
                                                                          )));
                                                            },
                                                            child: Container(
                                                                height: 32,
                                                                width: 32,
                                                                decoration: BoxDecoration(
                                                                    color: selectedIndexList1 ==
                                                                            0
                                                                        ? Colors
                                                                            .grey
                                                                        : chaticonBackgroundColor,
                                                                    shape: BoxShape
                                                                        .circle),
                                                                child: Padding(
                                                                    padding: EdgeInsets.only(
                                                                        top: 4,
                                                                        left:
                                                                            8),
                                                                    child:
                                                                        Center(
                                                                      child: SvgPicture.asset(
                                                                          'assets/chat1.svg',
                                                                          color:
                                                                              iconColor),
                                                                    )))),
                                                        //     SizedBox(
                                                        //     width: 2,
                                                        //   ),
                                                        //              GestureDetector(
                                                        // onTap: () {
                                                        //   return showDialog(
                                                        //       context: context,
                                                        //       barrierDismissible:
                                                        //           false,
                                                        //       builder:
                                                        //           (BuildContext
                                                        //               context) {
                                                        //         return AlertDialog(
                                                        //           shape: RoundedRectangleBorder(
                                                        //               borderRadius:
                                                        //                   BorderRadius.all(
                                                        //                       Radius.circular(32.0))),
                                                        //           title: Column(
                                                        //             children: <
                                                        //                 Widget>[
                                                        //               Container(
                                                        //                 child: Text(
                                                        //                     'CONFIRMATION'),
                                                        //               ),
                                                        //               Divider(
                                                        //                   color:
                                                        //                       dividerColor),
                                                        //               SizedBox(
                                                        //                 height:
                                                        //                     20,
                                                        //               ),
                                                        //               Container(
                                                        //                   width:
                                                        //                       200.0,
                                                        //                   height:
                                                        //                       100.0,
                                                        //                   decoration:
                                                        //                       BoxDecoration(
                                                        //                     borderRadius:
                                                        //                         BorderRadius.circular(67),
                                                        //                   ),
                                                        //                   child:
                                                        //                       Text(
                                                        //                     'Are you sure you want to confirm this appointment?',
                                                        //                     style: TextStyle(
                                                        //                         color: Colors.black,
                                                        //                         fontSize: 15,
                                                        //                         fontWeight: FontWeight.w600),
                                                        //                     textAlign:
                                                        //                         TextAlign.center,
                                                        //                   )),
                                                        //             ],
                                                        //           ),
                                                        //           content: Row(
                                                        //             mainAxisAlignment:
                                                        //                 MainAxisAlignment
                                                        //                     .spaceAround,
                                                        //             children: <
                                                        //                 Widget>[
                                                        //               RaisedButton(
                                                        //                   color:
                                                        //                       buttonColor,
                                                        //                   child:
                                                        //                       Text(
                                                        //                     'YES',
                                                        //                     style:
                                                        //                         TextStyle(color: buttonTextColor),
                                                        //                   ),
                                                        //                   onPressed:
                                                        //                       () async {

                                                        //                     confirmationstatus(
                                                        //                         context,
                                                        //                         appointmentdata[index]['appointment_id']);

                                                        //                     // _deleteappointment(user[index]['appointment_id']);
                                                        //                   }),
                                                        //               RaisedButton(
                                                        //                   color:
                                                        //                       disclaimeridontButtonColor,
                                                        //                   child:
                                                        //                       Text(
                                                        //                     'NO',
                                                        //                     style:
                                                        //                         TextStyle(color: buttonTextColor),
                                                        //                   ),
                                                        //                   onPressed:
                                                        //                       () {
                                                        //                     Navigator.pop(
                                                        //                         context);
                                                        //                   })
                                                        //             ],
                                                        //           ),
                                                        //         );
                                                        //       });
                                                        // },
                                                        // child: appointmentdata[index][
                                                        //                 'appointment_status'] ==
                                                        //             "Confirm" &&
                                                        //         appointmentdata[index]
                                                        //                 [
                                                        //                 'appointment_status'] !=
                                                        //             "Completed"
                                                        //     ?
                                                        //     // confirmedstatus==null?
                                                        //     Container(
                                                        //         height: 32,
                                                        //         width: 32,
                                                        //         decoration: BoxDecoration(
                                                        //             borderRadius:
                                                        //                 BorderRadius
                                                        //                     .circular(
                                                        //                         18),
                                                        //             color:
                                                        //                 checkColor

                                                        //             ),
                                                        //         child: Center(
                                                        //           child: Icon(
                                                        //             Icons.check,
                                                        //             color:
                                                        //                 iconColor,
                                                        //           ),
                                                        //         )

                                                        //         )
                                                        //     : Container()),
                                                      ],
                                                    ))
                                                  ],
                                                ),
                                                Container(
                                                    child: Row(
                                                  //       crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                        height: 36,
                                                        width: 170,
                                                        decoration: BoxDecoration(
                                                            color:
                                                                appointmentCarddateBackgroundColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        2)),
                                                        child: Center(
                                                          child: Text(
                                                            DateFormat(
                                                                    " EEEE, d MMMM\n y")
                                                                .add_jm()
                                                                .format(DateTime.parse(
                                                                        appointmentdata[index]
                                                                            [
                                                                            'appointment_date'])
                                                                    .toLocal()),
                                                            style: TextStyle(
                                                                color:
                                                                    textColor,
                                                                fontSize: 13),
                                                          ),
                                                        )
                                                        // getdatetime(DateFormat(" EEEE, d MMMM\n y").add_jm().format(DateTime.parse(appointmentdata[index]['appointment_date']).toLocal())) ,)
                                                        ),
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 5),
                                                        child: RaisedButton(
                                                            color: buttonColor,
                                                            onPressed: () {
                                                              final ddata = http
                                                                  .post(
                                                                      apipath +
                                                                          '/doctorListByIdAppointment',
                                                                      body: {
                                                                    'appointment_date': DateTime.parse(appointmentdata[index]
                                                                            [
                                                                            'appointment_date'])
                                                                        .toLocal()
                                                                        .toString(),
                                                                    'timezone':
                                                                        dateTime
                                                                            .timeZoneName,
                                                                    "user_id": appointmentdata[index]
                                                                            [
                                                                            'holder_id']
                                                                        .toString(),
                                                                  }).then(
                                                                      (value) {
                                                                // return value.body;
                                                                setState(() {
                                                                  doctorbyiddata =
                                                                      jsonDecode(
                                                                          value
                                                                              .body);
                                                                });
                                                                return Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => Detailpage(
                                                                              starttime: doctorbyiddata[0]['available_start_time'],
                                                                              endtime: doctorbyiddata[0]['available_end_time'],
                                                                              doctor: appointmentdata[index]['doctorname'],
                                                                              holderid: appointmentdata[index]['holder_id'].toString(),
                                                                              user_image: appointmentdata[index]['user_profile'],
                                                                              // _user(
                                                                              email: appointmentdata[index]['email'],
                                                                              name: appointmentdata[index]['client_name'],
                                                                              phonenumber: appointmentdata[index]['phonenumber'],
                                                                              // problem: appointmentdata[index]['issue'],
                                                                              appointment_id: appointmentdata[index]['appointment_id'].toString(),
                                                                              appointment_datetime: DateTime.parse(appointmentdata[index]['appointment_date']),
                                                                              slotdifference: doctorbyiddata[0]['slot_size'],
                                                                            )));
                                                              });
                                                            },
                                                            child:
                                                                // setmodifybuttom()
                                                                Text(
                                                              'Modify',
                                                              style: TextStyle(
                                                                  color:
                                                                      buttonTextColor,
                                                                  fontSize: 11),
                                                            )))
                                                  ],
                                                ))
                                              ],
                                            ));
                                      }))
                            ],
                          )),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 25, left: 30),
                        child: Stack(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(top: 20, left: 5),
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: buttonColor,
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.menu,
                                          color: iconColor,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Menuscreen()));
                                        }),
                                  ),
                                )),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
