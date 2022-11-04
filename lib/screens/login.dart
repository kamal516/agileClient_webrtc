// ignore_for_file: deprecated_member_use, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:convert' show json;
import 'dart:io';

// import 'package:device_calendar/device_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:doctoragileapp/api.dart';
import 'package:doctoragileapp/applisignin/apple_available.dart';
import 'package:doctoragileapp/color.dart';
import 'package:doctoragileapp/dgoogle.dart';
import 'package:doctoragileapp/homescreen.dart';
import 'package:doctoragileapp/screens/forgot.dart';
import 'package:doctoragileapp/screens/signup.dart';
import 'package:doctoragileapp/widgets/Alertbox.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:the_apple_sign_in/the_apple_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId

  // clientId: '270983235058-df26n6u5d55vpju0jc4hoh4j3kn4akhr.apps.googleusercontent.com',
  scopes: <String>[
    'techsapphiredotnet@gmail.com',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class Loginpage extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final String token_appid;
  // ignore: non_constant_identifier_names
  Loginpage({this.token_appid});
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

enum FormType { login, register }

class _QuestionScreenState extends State<Loginpage> {
  bool isWriting = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // ignore: unused_field
  var _firstPress = true;
  TextEditingController useremail = new TextEditingController();
  TextEditingController userpassword = new TextEditingController();
  // ignore: unused_field
  bool _login = false;
  String _password = '';
  String _email = '';
  String checkpassword;
  FormType _formtype = FormType.login;
  var data;
  // ignore: non_constant_identifier_names
  String app_token;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  getbutton() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double multiplier = 1.4;
    return Text(
      'Create an Account',
      style: TextStyle(
        color: buttonColor,
        fontSize: multiplier * unitHeightValue,
      ),
    );
  }

  getforgotbutton() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double multiplier = 1.4;
    return Text(
      'Forgot password?',
      style: TextStyle(
        color: buttonColor,
        fontSize: multiplier * unitHeightValue,
      ),
    );
  }

  Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    print("onBackground: $message");

    return Future<void>.value();
  }

  GoogleSignInAccount _currentUser;
  String _contactText = '';
  @override
  void initState() {
    super.initState();
    // _retrieveCalendars();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact(_currentUser);
      }
    });
    _googleSignIn.signInSilently();
    if (Platform.isIOS) {
      _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: true));
      _firebaseMessaging.onIosSettingsRegistered
          .listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });
      _firebaseMessaging.getToken().then((val) async {
        print('Token: ' + val);
        SharedPreferences _localstorage = await SharedPreferences.getInstance();

        _localstorage.setString('appidtoken', val);
        getappid();
      });
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
        },
        //  onBackgroundMessage: myBackgroundMessageHandler,
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
        },
      );
    }

    // _firebaseMessaging.getToken().then((val) {
    //               print('Token: '+val);
    //             });

    else if (Platform.isAndroid) {
      _firebaseMessaging.getToken().then((value) async {
        print(value);
        SharedPreferences _localstorage = await SharedPreferences.getInstance();

        _localstorage.setString('appidtoken', value);
        //getappid();
        getappid();
      });

      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");

          // ignore: unused_local_variable
          final notification = message['notification'];
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");

          // ignore: unused_local_variable
          final notification = message['data'];
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
        },
      );
    }

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  // DeviceCalendarPlugin _deviceCalendarPlugin;
  // List<Calendar> _calendars;
  // // ignore: unused_element
  // List<Calendar> get _writableCalendars =>
  //     _calendars?.where((c) => !c.isReadOnly)?.toList() ?? List<Calendar>();

  // // ignore: unused_element
  // List<Calendar> get _readOnlyCalendars =>
  //     _calendars?.where((c) => c.isReadOnly)?.toList() ?? List<Calendar>();

  // // ignore: unused_element
  // _CalendarsPageState() {
  //   _deviceCalendarPlugin = DeviceCalendarPlugin();
  // }

  // void _retrieveCalendars() async {
  //   try {
  //     var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
  //     if (permissionsGranted.isSuccess && !permissionsGranted.data) {
  //       permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
  //       if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
  //         return;
  //       }
  //     }
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }
  // }

  String app_tokenid;
  String logintoken;
  String _localalerttoken;

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = "Loading contact info...";
    });
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          'requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = "People API gave a ${response.statusCode} "
            "response. Check logs for details.";
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    final String namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = "I see you know $namedContact!";
      } else {
        _contactText = "No contacts to display.";
      }
    });
  }

  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  // ignore: unused_element
  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  bool _isLoggedIn = false;
  GoogleSignInAccount _userObj;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  firebasegooglesignin() {
    _googleSignIn.signIn().then((userData) {
      setState(() {
        _isLoggedIn = true;
        _userObj = userData;
      });
      http.post(apipath + '/mobileGooglelogin', body: {
        'email': _userObj.email,
        'name': _userObj.displayName,
        'appToken': app_tokenid,
        'timezone': dateTime.timeZoneName
      }).then((value) async {
        data = jsonDecode(value.body);
        SharedPreferences localStorage = await SharedPreferences.getInstance();

        localStorage.setString('id', data['user_id'].toString());
        // localStorage.setString('token', data['token']);
        localStorage.setString('name', data['username']);
        localStorage.setString('desc', data['description']);
        localStorage.setString('phn', data['phone_number1']);
        localStorage.setString('adrs', data['address1']);
        localStorage.setString('email', data['email']);
        localStorage.setString('institute_id', data['institute_id'].toString());

        localStorage = await SharedPreferences.getInstance();
        if (mounted) {
          setState(() {
            _localalerttoken = data['token'];
          });
        }
        _setdisclaimar();
//  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Upcomingappointment()));
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future SignIn() async {
    final username = await GoogleSignInApi.login();
    if (username == null) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('sign in failed'),));
    } else {
      http.post(apipath + '/mobileGooglelogin', body: {
        'email': username.email,
        'name': username.displayName,
        'appToken': app_tokenid,
        'timezone': dateTime.timeZoneName
      }).then((value) async {
        data = jsonDecode(value.body);
        SharedPreferences localStorage = await SharedPreferences.getInstance();

        localStorage.setString('id', data['user_id'].toString());
        // localStorage.setString('token', data['token']);
        localStorage.setString('name', data['username']);
        localStorage.setString('desc', data['description']);
        localStorage.setString('phn', data['phone_number1']);
        localStorage.setString('adrs', data['address1']);
        localStorage.setString('email', data['email']);
        localStorage.setString('institute_id', data['institute_id'].toString());

        localStorage = await SharedPreferences.getInstance();
        if (mounted) {
          setState(() {
            _localalerttoken = data['token'];
          });
        }
        _setdisclaimar();
//  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Upcomingappointment()));
      });
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget _buildBody() {
    GoogleSignInAccount user = _currentUser;
    if (user != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: user,
            ),
            title: Text(user.displayName),
            subtitle: Text(user.email),
          ),
          const Text("Signed in successfully."),
          Text(_contactText),
          ElevatedButton(
            child: const Text('SIGN OUT'),
            onPressed: _handleSignOut,
          ),
          ElevatedButton(
            child: const Text('REFRESH'),
            onPressed: () => _handleGetContact(user),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text("You are not currently signed in."),
          ElevatedButton(
              child: const Text('SIGN IN'),
              onPressed: () {
                SignIn();
              }
              //_handleSignIn,
              ),
        ],
      );
    }
  }

  getappid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      app_tokenid = preferences.getString("appidtoken");
      logintoken = preferences.getString("token");
    });

    print(app_tokenid);
  }

  bool _autoValidate = false;
  DateTime dateTime = DateTime.now();
  List disclaimer;
  _loginset() async {
    await http.post(apipath + '/login', body: {
      'email': useremail.text,
      'appToken': app_tokenid,
      'password': userpassword.text,
      'timezone': dateTime.timeZoneName
    }).then((result) async {
      print(result.body);
      data = jsonDecode(result.body);

      if (data['error'] == 'User does not exist') {
        return null;
      } else if (data['error'] == 'Something went Wrong..!!') {
        return null;
      } else {
        setState(() {
          _login = true;
        });

        var body = json.decode(result.body);
        SharedPreferences localStorage = await SharedPreferences.getInstance();

        localStorage.setString('id', body['user_id'].toString());
        // localStorage.setString('token', body['token']);
        localStorage.setString('name', body['username']);
        localStorage.setString('desc', body['description']);
        localStorage.setString('phn', body['phone_number1']);
        localStorage.setString('adrs', body['address1']);
        localStorage.setString('email', body['email']);
        localStorage.setString('institute_id', body['institute_id'].toString());

        localStorage = await SharedPreferences.getInstance();
        // if (localStorage.getString("token") != null) {
        _setdisclaimar();
        if (mounted) {
          setState(() {
            _localalerttoken = body['token'];
          });
        }

        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(
        //         builder: (BuildContext context) =>
        //             Upcomingappointment(user_name: body['username'])),
        //     (Route<dynamic> route) => false);
        // }
      }
    });
  }

  _setdisclaimar() async {
    await http.post(apipath + '/getDisclaimer', body: {
      "disclaimer_position": "post-login",
      'timezone': dateTime.timeZoneName
    }).then((result) async {
      print(result.body);
      setState(() {
        disclaimer = jsonDecode(result.body);
      });
      // ignore: unused_local_variable
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      print(disclaimer);
      if (disclaimer[0]['msg'] == 'post-login') {
        return Navigator.push(context,
            MaterialPageRoute(builder: (context) => Upcomingappointment()));
      } else if (disclaimer != null) {
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Alertbox(
                apptoken: _localalerttoken,
                getdisclaimer: disclaimer,
              );
            });
        //  _onSubmit(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final appleSignInAvailable =
    // Provider.of<AppleSignInAvailable>(context, listen: false);
    return Scaffold(
        body: SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 1.0,
            color: Colors.black,
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 0, left: 0),
                      child: Image(
                        // height: 250.0,
                        // width: 450.0,
                        image: AssetImage('assets/Logo_new.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
                // Padding(
                //   padding: EdgeInsets.only(top: 0, left: 0),
                //   child: Image(
                //     height: 250.0,
                //     width: 400.0,
                //     image: AssetImage('assets/Logo_new.png'),
                //     fit: BoxFit.contain,
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(top: 250, bottom: 10),
                  child: new Container(
                      decoration: new BoxDecoration(
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.black,
                              blurRadius: 20.0,
                            ),
                          ],
                          color: Color(0xffe9eff0),
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(40.0),
                            topRight: const Radius.circular(40.0),
                            bottomLeft: const Radius.circular(40.0),
                            bottomRight: const Radius.circular(40.0),
                          )),
                      padding: EdgeInsets.only(top: 20, left: 40, right: 40),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Center(
                                //  padding: EdgeInsets.only( bottom: 20),
                                child: Text(
                                  'SIGN IN',
                                  style: TextStyle(
                                      fontSize: 25, color: buttonColor),
                                ),
                              )),
                          Form(
                              key: _formKey,
                              // autovalidateMode: AutovalidateMode.disabled,
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    onChanged: (check) {
                                      // _formKey.currentState.reset();
                                    },
                                    controller: useremail,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: new InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 10.0, 20.0, 10.0),
                                        filled: true,
                                        fillColor: greyContainer,
                                        labelText: 'Email',
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.vertical(),
                                        )),
                                    validator: (val) {
                                      if (val.length == 0) {
                                        return "Please enter email";
                                      } else if (!val.contains("@")) {
                                        return "Please enter valid email";
                                      } else if (val != data['username']) {
                                        return "Please enter correct email";
                                      } else
                                        return null;
                                    },
                                    onSaved: (val) => _email = val,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  new TextFormField(
                                      onChanged: (check) {
                                        // setState(() {
                                        //   _password = '';
                                        // });
                                      },
                                      obscureText: true,
                                      controller: userpassword,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: new InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 10.0, 20.0, 10.0),
                                        filled: true,
                                        fillColor: greyContainer,
                                        labelText: 'Password',
                                        border: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.vertical()),
                                      ),
                                      validator: (value) {
                                        if (value.length == 0) {
                                          return "Please enter password";
                                        } else if (value.length <= 5) {
                                          return "Your password should be more then 6 char long";
                                        } else if (value != data['password']) {
                                          return "Please enter correct password";
                                        } else
                                          return null;
                                      },
                                      onSaved: (value) => _password = value),
                                ],
                              )),
                          SizedBox(
                            height: MediaQuery.of(context).size.aspectRatio,
                          ),
                          if (_formtype == FormType.login)
                            Flexible(
                                flex: 2,
                                child: Container(
                                  child: new RaisedButton(
                                      color: buttonColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(),
                                          side:
                                              BorderSide(color: Colors.black)),
                                      child: new Text(
                                        'LOGIN',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 19),
                                      ),
                                      onPressed: () {
                                        _loginset();
                                        if (_formKey.currentState.validate()) {
                                          _formKey.currentState.save();
                                          _scaffoldKey.currentState
                                              // ignore: deprecated_member_use
                                              .showSnackBar(new SnackBar(
                                            content: new Text(
                                                "email:$_email Password: $_password"),
                                          ));
                                        }
                                      }),
                                )),
                          MaterialButton(
                            onPressed: () {
                              firebasegooglesignin();
                              // SignIn();
                            },
                            color: Colors.teal,
                            elevation: 10,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/dgoogleimage.png'),
                                          fit: BoxFit.cover),
                                      shape: BoxShape.circle),
                                ),
                                //          SizedBox(
                                //   width: 50,
                                // ),
                                Text(
                                  "Sign In with Google",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),

                          // if (appleSignInAvailable.isAvailable)
                          //   AppleSignInButton(
                          //
                          //       type: ButtonType.signIn,
                          //       onPressed: () => _signInWithApple(context),
                          //     ),

                          SizedBox(
                            height: 10,
                            // MediaQuery.of(context).size.aspectRatio,
                          ),

                          Container(
                            height: 50,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                FlatButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SigninPage(
                                                  appid_token: app_tokenid)));
                                    },
                                    child: getbutton()),
                                FlatButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ResetPassword()));
                                    },
                                    child: getforgotbutton())
                              ],
                            ),
                          )
                          // Container(width: 80,
                          // child:
                          // Row(
                          //     // crossAxisAlignment: CrossAxisAlignment.center,
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: <Widget>[
                          //       Container(
                          //           child: FlatButton(
                          //               onPressed: () {
                          //                 Navigator.push(
                          //                     context,
                          //                     MaterialPageRoute(
                          //                         builder: (context) =>
                          //                             SigninPage(
                          //                                 appid_token:
                          //                                     app_tokenid)));
                          //               },
                          //               child: Text(
                          //                 'Create an Account',
                          //                 style: TextStyle(
                          //                   color: kPrimaryColor,
                          //                   fontSize: 12,
                          //                 ),
                          //               ))),
                          //       // SizedBox(
                          //       //   height: 0,
                          //       // ),
                          //       Container(
                          //           child: FlatButton(
                          //               onPressed: () {
                          //                 Navigator.push(
                          //                     context,
                          //                     MaterialPageRoute(
                          //                         builder: (context) =>
                          //                             ResetPassword()));
                          //               },
                          //               child: Text('Forgot password?',
                          //                   style: TextStyle(
                          //                       color: kPrimaryColor,
                          //                       fontSize: 12)))),
                          //     ])
                          // )
                        ],
                      )),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 25, left: 30),
                    child: Stack(
                      children: <Widget>[],
                    )),
              ],
            ),
          )
        ],
      ),
    ));
  }

  Future<void> _signInWithApple(BuildContext context) async {
    try {
      // final authService = Provider.of<AuthService>(context, listen: false);
      // final user = await authService.signInWithApple();
      return Navigator.push(context,
          MaterialPageRoute(builder: (context) => Upcomingappointment()));
      // print('uid: ${user.uid}');
    } catch (e) {
      // TODO: Show alert here
      print(e);
    }
  }
}

// class AuthService {
//   final _firebaseAuth = FirebaseAuth.instance;
//
//   Future<User> signInWithApple({List<Scope> scopes = const []}) async {
//     // 1. perform the sign-in request
//     final result = await TheAppleSignIn.performRequests(
//         [AppleIdRequest(requestedScopes: scopes)]);
//     // 2. check the result
//     switch (result.status) {
//       case AuthorizationStatus.authorized:
//         final appleIdCredential = result.credential;
//         final oAuthProvider = OAuthProvider('apple.com');
//         final credential = oAuthProvider.credential(
//           idToken: String.fromCharCodes(appleIdCredential.identityToken),
//           accessToken:
//               String.fromCharCodes(appleIdCredential.authorizationCode),
//         );
//         final userCredential =
//             await _firebaseAuth.signInWithCredential(credential);
//         final firebaseUser = userCredential.user;
//         if (scopes.contains(Scope.fullName)) {
//           final fullName = appleIdCredential.fullName;
//           if (fullName != null &&
//               fullName.givenName != null &&
//               fullName.familyName != null) {
//             final displayName = '${fullName.givenName} ${fullName.familyName}';
//             await firebaseUser.displayName;
//           }
//         }
//         return firebaseUser;
//       case AuthorizationStatus.error:
//         throw PlatformException(
//           code: 'ERROR_AUTHORIZATION_DENIED',
//           message: result.error.toString(),
//         );
//
//       case AuthorizationStatus.cancelled:
//         throw PlatformException(
//           code: 'ERROR_ABORTED_BY_USER',
//           message: 'Sign in aborted by user',
//         );
//       default:
//         throw UnimplementedError();
//     }
//   }
// }