import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:doctoragileapp/api.dart';
import 'package:doctoragileapp/color.dart';
import 'package:doctoragileapp/triage/detailpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doctoragileapp/widgets/bottomnavbar.dart';

class Showappointment extends StatefulWidget {
  final List<dynamic> bydate;
  final DateTime timer;
  final String calendartest;
  Showappointment({Key key, this.timer, this.bydate, this.calendartest})
      : super(key: key);
  @override
  _DoctorListState createState() => _DoctorListState();
}

class _DoctorListState extends State<Showappointment> {
  bool _hasBeenPressed = false;
  List doctorbyiddata;
  List<IconData> icnlst = [Icons.mail, Icons.access_alarm];
  List<IconData> icnDoctorlst = [Icons.assignment_turned_in, Icons.message];
  int selectedIndex;
  int selectedMale = 0;
  int selectedFemale;
  int selectedIndexList;
  int selectedIndexList1;
  List data;
  String _user(dynamic user) {
    return user['client_name'];
  }

  String _time(dynamic user) {
    return user['appointment_time'];
  }

  DateTime _date(dynamic user) {
    return user['appointment_date'];
  }

  String _adres(dynamic user) {
    return user['client_address'];
  }

  int _idfordelete(dynamic user) {
    return user['appointment_id'];
  }

  String _issue(dynamic user) {
    return user['issue'];
  }

  @override
  initState() {
    super.initState();

    _getid();
  }

  DateTime dateTime = DateTime.now();
  _deleteappointment(int apointid) async {
    final response = await http.post(apipath + '/cancelAppointmnet', body: {
      "appointment_id": apointid.toString(),
      "holder_id": widget.bydate[0]['holder_id'].toString(),
      "username": widget.bydate[0]['client_name'],
      "user_id": id,
      'timezone': dateTime.timeZoneName
    }).then((test) {
      print(test.body);
      Navigator.pop(context);
    });
  }

  TextEditingController _problem = new TextEditingController();

  String _token;
  String _appintmentid;
  String id;
  _getid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _token = preferences.getString("token");
    setState(() {
      _appintmentid = preferences.getString("appointment_id");
      id = preferences.getString("id");
    });
  }

  final String apiUrl = apipath + '/appointment';
  int checkid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavBar(),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              top: 2,
            ),
            // color: buttonColor,
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
                                    color: buttonTextColor,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              // SizedBox(
                              //   width: 80,
                              // ),
                              Center(
                                  child: Text(
                                'APPOINTMENT',
                                style: TextStyle(
                                    color: buttonTextColor, fontSize: 19),
                              )),
                              // SizedBox(
                              //   width: 110,
                              // ),
                            ]),
                          ),
                        ]),
                    Container(
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(2)),
                      padding: EdgeInsets.only(top: 5, left: 0, right: 30),
                    ),
                    Container(
                        height: 50,
                        width: 450,
                        color: buttonColor,
                        alignment: Alignment.center,
                        child: Text(
                          DateFormat(' EEEE, d MMMM , y').format(widget.timer),
                          style:
                              TextStyle(fontSize: 20, color: buttonTextColor),
                        )),
                    Container(
                        height: 580,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.only(
                          top: 2,
                        ),
                        child: Container(
                            height: 400,
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: ListView.builder(
                                itemCount: widget.bydate.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return widget.timer.isBefore(DateTime.now())
                                      ? new Card(
                                          color: buttonColor,
                                          semanticContainer: true,
                                          child: ListTile(
                                              title: Text(
                                                widget.bydate[index]
                                                    ['doctorname'],
                                                // _user(
                                                //   snapshot.data[index],
                                                // ),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: buttonTextColor,
                                                    fontSize: 18),
                                              ),
                                              subtitle: Text(
                                                widget.bydate[index]['issue'] ==
                                                        null
                                                    ? ''
                                                    : widget.bydate[index]
                                                        ['issue'],
                                                // _issue(
                                                //   snapshot.data[index],
                                                // ),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15),
                                              ),
                                              trailing: Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 10),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Container(
                                                        child: Text(
                                                          DateFormat()
                                                              .add_jm()
                                                              .format(DateTime.parse(
                                                                  widget.bydate[
                                                                          index]
                                                                      [
                                                                      'appointment_date'])),
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              color:
                                                                  buttonTextColor,
                                                              fontSize: 15),
                                                        ),
                                                        // Text(
                                                        //   widget.bydate[
                                                        //           index][
                                                        //       'appointment_time'],
                                                        //   // _time(
                                                        //   //   snapshot.data[index],
                                                        //   // ),
                                                        //   textAlign:
                                                        //       TextAlign
                                                        //           .left,
                                                        //   style: TextStyle(
                                                        //       color: Colors
                                                        //           .black,
                                                        //       fontSize: 15),
                                                        // ),
                                                      ),
                                                      // SizedBox(
                                                      //   height: 2,
                                                      // ),
                                                      // Container(
                                                      //   child: Text(
                                                      //     'David cose',
                                                      //     // _time(
                                                      //     //   snapshot.data[index],
                                                      //     // ),
                                                      //     textAlign:
                                                      //         TextAlign
                                                      //             .left,
                                                      //     style: TextStyle(
                                                      //         color: Colors
                                                      //             .black,
                                                      //         fontSize: 14),
                                                      //   ),
                                                      // )
                                                    ],
                                                  ))),
                                        )
                                      : new SlideMenu(
                                          child: new Card(
                                            color: buttonColor,
                                            semanticContainer: true,
                                            child: ListTile(
                                                title: Text(
                                                  widget.bydate[index]
                                                      ['doctorname'],
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: buttonTextColor,
                                                      fontSize: 18),
                                                ),
                                                subtitle: Text(
                                                  widget.bydate[index]
                                                              ['issue'] ==
                                                          null
                                                      ? ''
                                                      : widget.bydate[index]
                                                          ['issue'],
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: buttonTextColor,
                                                      fontSize: 15),
                                                ),
                                                trailing: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                            DateFormat()
                                                                .add_jm()
                                                                .format(DateTime.parse(
                                                                        widget.bydate[index]
                                                                            [
                                                                            'appointment_date'])
                                                                    .toLocal()),
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                                color:
                                                                    buttonTextColor,
                                                                fontSize: 15),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 2,
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            '',
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                                color:
                                                                    buttonTextColor,
                                                                fontSize: 14),
                                                          ),
                                                        )
                                                      ],
                                                    ))),
                                          ),
                                          menuItems: <Widget>[
                                            GestureDetector(
                                                onTap: () {
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context)  {
                                                  final ddata = http.post(
                                                      apipath +
                                                          '/doctorListByIdAppointment',
                                                      body: {
                                                        'appointment_date':
                                                            DateTime.parse(widget
                                                                            .bydate[
                                                                        index][
                                                                    'appointment_date'])
                                                                .toLocal()
                                                                .toString(),
                                                        'timezone': dateTime
                                                            .timeZoneName,
                                                        "user_id": widget
                                                            .bydate[index]
                                                                ['holder_id']
                                                            .toString(),
                                                      }).then((value) {
                                                    // return value.body;
                                                    setState(() {
                                                      doctorbyiddata =
                                                          jsonDecode(
                                                              value.body);
                                                    });

                                                    return Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Detailpage(
                                                                      calendarvalue:
                                                                          widget
                                                                              .calendartest,
                                                                      starttime:
                                                                          doctorbyiddata[0]
                                                                              [
                                                                              'available_start_time'],
                                                                      endtime: doctorbyiddata[
                                                                              0]
                                                                          [
                                                                          'available_end_time'],
                                                                      doctor: widget
                                                                              .bydate[index]
                                                                          [
                                                                          'doctorname'],
                                                                      holderid: widget
                                                                          .bydate[
                                                                              index]
                                                                              [
                                                                              'holder_id']
                                                                          .toString(),
                                                                      user_image:
                                                                          widget.bydate[index]
                                                                              [
                                                                              'user_profile'],
                                                                      // _user(
                                                                      email: widget
                                                                              .bydate[index]
                                                                          [
                                                                          'doctoremail'],
                                                                      name: widget
                                                                              .bydate[index]
                                                                          [
                                                                          'client_name'],
                                                                      phonenumber:
                                                                          widget.bydate[index]
                                                                              [
                                                                              'phonenumber'],
                                                                      problem: widget
                                                                              .bydate[index]
                                                                          [
                                                                          'issue'],
                                                                      appointment_id: widget
                                                                          .bydate[
                                                                              index]
                                                                              [
                                                                              'appointment_id']
                                                                          .toString(),
                                                                      appointment_datetime:
                                                                          DateTime.parse(widget.bydate[index]
                                                                              [
                                                                              'appointment_date']),
                                                                    )));
                                                  });

                                                  //  }
                                                  //         ));
                                                },
                                                child: Container(
                                                  color:
                                                      rescheduleBackgroundColor,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: <Widget>[
                                                      SvgPicture.asset(
                                                        'assets/reschedule.svg',
                                                        color: buttonTextColor,
                                                      ),
                                                      Text(
                                                        "RE-SCHEDULE",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                buttonTextColor),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                            widget.bydate[index][
                                                        'is_cancellation_expire'] ==
                                                    false
                                                ? Container()
                                                : GestureDetector(
                                                    onTap: () {
                                                      _deleteappointment(widget
                                                              .bydate[index]
                                                          ['appointment_id']);
                                                    },
                                                    child: Container(
                                                      color:
                                                          deleteiconBackgroundColor,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: <Widget>[
                                                          SvgPicture.asset(
                                                              'assets/close.svg',
                                                              color:
                                                                  buttonTextColor),
                                                          Text(
                                                            "CANCEL IT",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color:
                                                                    buttonTextColor),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                          ],
                                        );
                                }))),
                  ],
                )),
          ),
        ));
  }
}

class SlideMenu extends StatefulWidget {
  final Widget child;
  final List<Widget> menuItems;

  SlideMenu({this.child, this.menuItems});

  @override
  _SlideMenuState createState() => new _SlideMenuState();
}

class _SlideMenuState extends State<SlideMenu>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  initState() {
    super.initState();

    _controller = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = new Tween(
            begin: const Offset(0.0, 0.0), end: const Offset(-0.2, 0.0))
        .animate(new CurveTween(curve: Curves.decelerate).animate(_controller));

    return new GestureDetector(
      onHorizontalDragUpdate: (data) {
        setState(() {
          _controller.value -= data.primaryDelta / context.size.width;
        });
      },
      onHorizontalDragEnd: (data) {
        if (data.primaryVelocity > 2500)
          _controller.animateTo(.0);
        else if (_controller.value >= 5 || data.primaryVelocity < -2500)
          _controller.animateTo(1.0);
        else
          _controller.animateTo(.0);
      },
      child: new Stack(
        children: <Widget>[
          new SlideTransition(position: animation, child: widget.child),
          new Positioned.fill(
            child: new LayoutBuilder(
              builder: (context, constraint) {
                return new AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return new Stack(
                      children: <Widget>[
                        new Positioned(
                          right: .0,
                          top: 5.0,
                          bottom: 5.0,
                          width: 900 * animation.value.dx * -1,
                          child: new Container(
                            color: Colors.black26,
                            child: new Row(
                              children: widget.menuItems.map((child) {
                                return new Expanded(
                                  child: child,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
