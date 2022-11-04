import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:doctoragileapp/categories.dart';
import 'package:doctoragileapp/color.dart';

import 'package:doctoragileapp/screens/login.dart';
import 'package:doctoragileapp/screens/profilepage.dart';
import 'package:doctoragileapp/screens/selfassess.dart';
import 'package:doctoragileapp/triage/calendarscreen.dart';
import 'package:doctoragileapp/homescreen.dart';
import 'package:doctoragileapp/versionpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';

import 'chatlistscreen.dart';

class Menuscreen extends StatefulWidget {
  @override
  _TestcatState createState() => _TestcatState();
}

class _TestcatState extends State<Menuscreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void logout(BuildContext context) async {
    setState(() {});

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('localid');
    localStorage.remove('token');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Loginpage()),
        (Route<dynamic> route) => false);
//  }
  }

  void initState() {
    super.initState();
    _localtoken();
  }

  _showRatingDialog() {
    // actual store listing review & rating
    void _rateAndReviewApp() async {
      // refer to: https://pub.dev/packages/in_app_review
      final _inAppReview = InAppReview.instance;

      if (await _inAppReview.isAvailable()) {
        print('request actual review from store');
        _inAppReview.requestReview();
      } else {
        print('open actual store listing');
        // TODO: use your own store ids
        _inAppReview.openStoreListing(
          appStoreId: 'com.lacimasoftware.agilemeduser',
          microsoftStoreId: 'com.lacimasoftware.agilemedapplicationtwo',
        );
        //StoreRedirect.redirect(androidAppId: 'com.lacimasoftware.agilemedapplicationtwo',iOSAppId: 'com.lacimasoftware.agilemeduser');
      }
    }

    final _dialog = RatingDialog(
      initialRating: 2.0,
      // your app's name?
      title: Text(
        'AgileMed app',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      // encourage your user to leave a high rating?
      message: Text(
        'Tap a star to set your rating. Add more description here if you want.',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15),
      ),
      // your app's logo?
      image: Center(
          child: Container(
        height: 80,
        width: 80,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(120.0),
          child: Hero(
            tag: '',
            child: Image(
              image: AssetImage('assets/Logo_BG.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      )),
      // CircleAvatar(
      //   child: Image.asset('assets/Logo_BG.png',height: 100,fit: BoxFit.fitHeight,),
      // ),

      submitButtonText: 'Submit',
      commentHint: 'Set your custom comment hint',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) {
        print('rating: ${response.rating}, comment: ${response.comment}');

        // TODO: add your own logic
        if (response.rating < 3.0) {
          // send their comments to your email or anywhere you wish
          // ask the user to contact you instead of leaving a bad review
        } else {
          _rateAndReviewApp();
        }
      },
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: true, // set to false if you want to force a rating
      builder: (context) => _dialog,
    );
  }

  String _loginusername;
  String _loginuserphn;

  _localtoken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _loginusername = preferences.getString("name");
      _loginuserphn = preferences.getString("phn");
    });
    _showRatingDialog();
  }

  void signout(BuildContext context) async {
    setState(() {});

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    localStorage.remove('name');
    localStorage.remove('id');
    localStorage.remove('token');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Loginpage()),
        (Route<dynamic> route) => false);
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    clientId:
        '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.only(
          top: 3,
          left: 0,
          right: 0,
        ),
        color: buttonColor,
        child: new Container(
            height: 740,
            decoration: new BoxDecoration(
                color: Colors.white,
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
                                'MENU',
                                style: TextStyle(
                                    color: buttonTextColor, fontSize: 19),
                              ),
                              // IconButton(onPressed: (){
                              //   _showRatingDialog();
                              // }, icon: Icon(Icons.reviews))
                            ]),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 0, left: 2, right: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(top: 10.0),
                                  color: greyContainer,
                                  height: 200,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(left: 10),
                                            height: 80,
                                            width: 90,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              child: Hero(
                                                tag: '',
                                                child: Image(
                                                  height: 40.0,
                                                  width: 40.0,
                                                  image: AssetImage(
                                                      'assets/d1.jpg'),
                                                  fit: BoxFit.cover,
                                                ),
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
                                                      top: 0, left: 20),
                                                  child: Text(
                                                    _loginusername,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: blackTextColor),
                                                  ),
                                                ),
                                                Container(
                                                    padding: EdgeInsets.only(
                                                        left: 20),
                                                    child: Text(
                                                        "Edit your profile",
                                                        style: TextStyle(
                                                            color:
                                                                greyTextColor))),
                                              ]),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 7, bottom: 45)),
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      top: 0, bottom: 40),
                                                  child: IconButton(
                                                      icon: Icon(Icons.edit,
                                                          color: buttonColor),
                                                      onPressed: () {
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Profilepage()));
                                                      }))
                                            ],
                                          ),
                                          // Column(
                                          //   crossAxisAlignment:
                                          //       CrossAxisAlignment.start,
                                          //   children: <Widget>[
                                          //     Container(
                                          //       padding: EdgeInsets.only(
                                          //           top: 110, right: 1),
                                          //       child: RaisedButton(
                                          //           child: Text(
                                          //             'SIGNOUT',
                                          //             style: TextStyle(
                                          //                 color: Colors.white),
                                          //           ),
                                          //           onPressed: () {
                                          //             signout(context);
                                          //           },
                                          //           color: kPrimaryColor),
                                          //     )
                                          //   ],
                                          // )
                                        ]),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 80, top: 20),
                                            child: Container(
                                                height: 40,
                                                width: 75,
                                                child: RaisedButton(
                                                    child: Text(
                                                      'SIGNOUT',
                                                      style: TextStyle(
                                                          color:
                                                              buttonTextColor,
                                                          fontSize: 9),
                                                    ),
                                                    onPressed: () async {
                                                      //       SharedPreferences localStorage = await SharedPreferences.getInstance();

                                                      // localStorage.remove('name');
                                                      // localStorage.remove('id');
                                                      // localStorage.remove('token');
                                                      //_googleSignIn.disconnect();
                                                      _googleSignIn.signOut();
                                                      // FirebaseAuth.instance.signOut();
                                                      await FirebaseAuth
                                                          .instance
                                                          .signOut();
// firebaseUser = await  _auth.currentUser();
                                                      signout(context);
                                                    },
                                                    color: buttonColor))),
                                      ]))
                            ],
                          )),
                      Container(
                          padding: EdgeInsets.only(
                            top: 30,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Chatscreen()));
                                },
                                child: SizedBox(
                                  height: 40,
                                  width: 100,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: greyContainer,
                                        borderRadius: BorderRadius.vertical(),
                                        border: Border.all(
                                            color: containerBorderColor)),
                                    padding: EdgeInsets.only(top: 7, left: 16),
                                    child: Text(
                                      'INBOX',
                                      style: TextStyle(
                                          fontSize: 15, color: blackTextColor),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Categoryset()));
                                },
                                child: SizedBox(
                                  height: 40,
                                  width: 100,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: greyContainer,
                                        borderRadius: BorderRadius.circular(3),
                                        border: Border.all(
                                            color: containerBorderColor)),
                                    padding: EdgeInsets.only(top: 7, left: 16),
                                    child: Text(
                                      'SERVICES',
                                      style: TextStyle(
                                          fontSize: 15, color: blackTextColor),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Calendarscreen()));
                                },
                                child: SizedBox(
                                  height: 40,
                                  width: 100,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: greyContainer,
                                        borderRadius: BorderRadius.circular(3),
                                        border: Border.all(
                                            color: containerBorderColor)),
                                    padding: EdgeInsets.only(top: 7, left: 16),
                                    child: Text(
                                      'CALENDAR',
                                      style: TextStyle(
                                          fontSize: 15, color: blackTextColor),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Upcomingappointment()));
                                  //  Navigator.push(context, MaterialPageRoute(builder: (context)=>Selfassess()));
                                },
                                child: SizedBox(
                                  height: 40,
                                  width: 100,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: greyContainer,
                                        borderRadius: BorderRadius.circular(3),
                                        border: Border.all(
                                            color: containerBorderColor)),
                                    padding: EdgeInsets.only(top: 7, left: 16),
                                    child: Text(
                                      'APPOINTMENTS',
                                      style: TextStyle(
                                          fontSize: 15, color: blackTextColor),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: SizedBox(
                                  height: 40,
                                  width: 100,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: greyContainer,
                                        borderRadius: BorderRadius.circular(3),
                                        border: Border.all(
                                            color: containerBorderColor)),
                                    padding: EdgeInsets.only(top: 7, left: 16),
                                    child: Text(
                                      'SETTINGS',
                                      style: TextStyle(
                                          fontSize: 15, color: blackTextColor),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Versionpage()));
                                },
                                child: SizedBox(
                                  height: 40,
                                  width: 100,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: greyContainer,
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          border: Border.all(
                                              color: containerBorderColor)),
                                      padding:
                                          EdgeInsets.only(top: 7, left: 16),
                                      child: Text(
                                        'ABOUT',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: blackTextColor),
                                        textAlign: TextAlign.left,
                                      )),
                                ),
                              ),
                            ],
                          ))
                    ]),
              ],
            )),
      )),
    );
  }
}
