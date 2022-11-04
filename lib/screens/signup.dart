import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:doctoragileapp/api.dart';
import 'package:doctoragileapp/color.dart';
import 'package:doctoragileapp/categories.dart';

import 'package:doctoragileapp/homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SigninPage extends StatefulWidget {
  final String appid_token;
  SigninPage({this.appid_token});
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<SigninPage> {
  String _email;
  String _nname;
  String _pphonenum;
  String _password;
  final _formKey = GlobalKey<FormState>();
  final _formname = GlobalKey<FormState>();
  final _formphonenum = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final formkey = new GlobalKey<FormState>();

  FormType _formtype = FormType.login;
  TextEditingController useremail = new TextEditingController();
  TextEditingController userpassword = new TextEditingController();
  TextEditingController _name = new TextEditingController();

  TextEditingController _phone = new TextEditingController();
  TextEditingController _address = new TextEditingController();
  bool _validate = false;
  bool validateandsave() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    getapptokenid();
  }

  AlertDialog alert = AlertDialog(
    title: Text("Notice"),
    content: Text("go to login"),
  );

  String apptoken_id;

  getapptokenid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      apptoken_id = preferences.getString("appidtoken");
    });
  }

  void movetoRegister() {
    formkey.currentState.reset();
    setState(() {
      _formtype = FormType.register;
    });
  }

  void movetoLogin() {
    formkey.currentState.reset();
    setState(() {
      _formtype = FormType.login;
    });
  }

  bool _login = false;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        // bottomNavigationBar: BottomAppBar(
        //   child: Container(
        //     decoration: BoxDecoration(color: buttonColor),
        //     padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
        //     child: new RaisedButton(
        //         color: buttonColor,
        //         shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.vertical(),
        //             side: BorderSide(color: Colors.black)),
        //         child: new Text(
        //           'REGISTER',
        //           style: TextStyle(color: buttonTextColor, fontSize: 19),
        //         ),
        //         onPressed: () {
        //           _logindata();
        //         }),
        //   ),
        // ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                child: Image(
                  height: 200.0,
                  image: AssetImage('assets/Logo_BG.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 150),
                  child: Container(
                      height: 460,
                      decoration: new BoxDecoration(
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.black,
                              blurRadius: 20.0,
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(40.0),
                            topRight: const Radius.circular(40.0),
                            bottomLeft: const Radius.circular(40.0),
                            bottomRight: const Radius.circular(40.0),
                          )),
                      padding: EdgeInsets.only(top: 15, left: 40, right: 40),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          color: Colors.white),
                                      padding: EdgeInsets.only(top: 0),
                                    ),
                                  ),
                                  Text(
                                    'REGISTER',
                                    style: TextStyle(
                                        fontSize: 19, color: blackTextColor),
                                  ),
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        color: Colors.white),
                                    padding: EdgeInsets.only(top: 7, left: 10),
                                  ),
                                ],
                              )),
                          Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    controller: _name,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: new InputDecoration(
                                        labelText: 'Name',
                                        filled: true,
                                        fillColor: greyContainer,
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.vertical(),
                                        )),
                                    validator: (val) {
                                      if (val.length == 0)
                                        return "Please enter name";
                                    },
                                    onSaved: (val) => _nname = val,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  TextFormField(
                                    controller: useremail,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: new InputDecoration(
                                        labelText: 'Email',
                                        filled: true,
                                        fillColor: greyContainer,
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.vertical(),
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
                                    height: 10.0,
                                  ),
                                  TextFormField(
                                    controller: _phone,
                                    autocorrect: true,
                                    keyboardType: TextInputType.number,
                                    maxLength: 15,
                                    inputFormatters: <TextInputFormatter>[
                                      // WhitelistingTextInputFormatter
                                      //     .digitsOnly
                                    ],
                                    decoration: new InputDecoration(
                                        filled: true,
                                        fillColor: greyContainer,
                                        labelText: 'Phone number',
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.vertical(),
                                        )),
                                    validator: (val) {
                                      if (val.length == 0)
                                        return "Please enter your phone number";
                                    },
                                    onSaved: (val) => _pphonenum = val,
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            obscureText: true,
                            controller: userpassword,
                            keyboardType: TextInputType.emailAddress,
                            decoration: new InputDecoration(
                                filled: true,
                                fillColor: greyContainer,
                                labelText: 'Password',
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.vertical(),
                                )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RaisedButton(
                              color: buttonColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(),
                                  side: BorderSide(color: Colors.black)),
                              child: new Text(
                                'REGISTER',
                                style: TextStyle(
                                    color: buttonTextColor, fontSize: 19),
                              ),
                              onPressed: () {
                                _logindata();
                              }),
                        ],
                      )))
            ],
          ),
        )
//          SingleChildScrollView(
//           child: Stack(
//             children: <Widget>[
//               Container(
//                 height: MediaQuery.of(context).size.height / 1.1,
//                 color: Colors.black,
//                 child: Stack(
//                   children: <Widget>[
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: <Widget>[
//  Padding(
//                       padding: EdgeInsets.only(top: 0, left: 0),
//                       child: Image(
//                         height: 200.0,
//                         // width: 450.0,
//                         image: AssetImage('assets/Logo_new.png'),
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                       ],
//                     ),

//                     Padding(
//                       padding: EdgeInsets.only(top: 120),
//                       child: SingleChildScrollView(child: Container(
//                           decoration: new BoxDecoration(
//                               boxShadow: [
//                                 new BoxShadow(
//                                   color: Colors.black,
//                                   blurRadius: 20.0,
//                                 ),
//                               ],
//                               color: Colors.white,
//                               borderRadius: new BorderRadius.only(
//                                 topLeft: const Radius.circular(40.0),
//                                 topRight: const Radius.circular(40.0),
//                               )),
//                           padding:
//                               EdgeInsets.only(top: 50, left: 40, right: 40),
//                           child: new Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: <Widget>[
//                               Container(
//                                   padding: EdgeInsets.only(bottom: 20),
//                                   child: Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     children: <Widget>[
//                                       GestureDetector(
//                                         onTap: () {
//                                           Navigator.pop(context);
//                                         },
//                                         child: Container(
//                                           height: 30,
//                                           width: 30,
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(20.0),
//                                               color: Colors.white),
//                                           padding: EdgeInsets.only(top: 7),
//                                         ),
//                                       ),
//                                       Text(
//                                         'REGISTER',
//                                         style: TextStyle(
//                                             fontSize: 19, color: blackTextColor),
//                                       ),
//                                       Container(
//                                         height: 30,
//                                         width: 30,
//                                         decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(20.0),
//                                             color: Colors.white),
//                                         padding:
//                                             EdgeInsets.only(top: 7, left: 10),
//                                       ),
//                                     ],
//                                   )),
//                               Form(
//                                   key: _formKey,
//                                   child: Column(
//                                     children: <Widget>[
//                                       TextFormField(
//                                         controller: _name,
//                                         keyboardType:
//                                             TextInputType.emailAddress,
//                                         decoration: new InputDecoration(
//                                             labelText: 'Name',
//                                             filled: true,
//                                             fillColor: greyContainer,
//                                             border: new OutlineInputBorder(
//                                               borderRadius:
//                                                   new BorderRadius.vertical(),
//                                             )),
//                                         validator: (val) {
//                                           if (val.length == 0)
//                                             return "Please enter name";
//                                         },
//                                         onSaved: (val) => _nname = val,
//                                       ),
//                                       SizedBox(
//                                         height: 10.0,
//                                       ),
//                                       TextFormField(
//                                         controller: useremail,
//                                         keyboardType:
//                                             TextInputType.emailAddress,
//                                         decoration: new InputDecoration(
//                                             labelText: 'Email',
//                                             filled: true,
//                                             fillColor: greyContainer,
//                                             border: new OutlineInputBorder(
//                                               borderRadius:
//                                                   new BorderRadius.vertical(),
//                                             )),
//                                         validator: (val) {
//                                           if (val.length == 0)
//                                             return "Please enter email";
//                                           else if (!val.contains("@"))
//                                             return "Please enter valid email";
//                                         },
//                                         onSaved: (val) => _email = val,
//                                       ),
//                                       SizedBox(
//                                         height: 10.0,
//                                       ),
//                                       TextFormField(
//                                         controller: _phone,
//                                         autocorrect: true,
//                                         keyboardType: TextInputType.number,
//                                         maxLength: 15,
//                                         inputFormatters: <TextInputFormatter>[
//                                           // WhitelistingTextInputFormatter
//                                           //     .digitsOnly
//                                         ],
//                                         decoration: new InputDecoration(
//                                             filled: true,
//                                             fillColor: greyContainer,
//                                             labelText: 'Phone number',
//                                             border: new OutlineInputBorder(
//                                               borderRadius:
//                                                   new BorderRadius.vertical(),
//                                             )),
//                                         validator: (val) {
//                                           if (val.length == 0)
//                                             return "Please enter your phone number";
//                                         },
//                                         onSaved: (val) => _pphonenum = val,
//                                       ),
//                                     ],
//                                   )),
//                               SizedBox(
//                                 height: 10.0,
//                               ),
//                               TextFormField(
//                                 obscureText: true,
//                                 controller: userpassword,
//                                 keyboardType: TextInputType.emailAddress,
//                                 decoration: new InputDecoration(
//                                     filled: true,
//                                     fillColor: greyContainer,
//                                     labelText: 'Password',
//                                     border: new OutlineInputBorder(
//                                       borderRadius: new BorderRadius.vertical(),
//                                     )),
//                               ),
//                               SizedBox(
//                                 height: 10,
//                               ),RaisedButton(
//                 color: buttonColor,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.vertical(),
//                     side: BorderSide(color: Colors.black)),
//                 child: new Text(
//                   'REGISTER',
//                   style: TextStyle(color: buttonTextColor, fontSize: 19),
//                 ),
//                 onPressed: () {
//                   _logindata();
//                 }),
//                             ],
//                           )),
//                     ),
//                      ) ],
//                 ),
//               ),
//             ],
//           ),
//         )
        );
  }

  _logindata() async {
    _formKey.currentState.validate();
    if (useremail.text.length == 0 ||
        _phone.text.length == 0 ||
        _name.text.length == 0 ||
        userpassword.text.length == 0 ||
        !useremail.text.contains("@")) {
      return;
    }
//   if(_name.text==""||useremail.text==""||userpassword.text==""){
//    return showDialog(
//         context: context,
//         builder: (BuildContext context) {

//           return AlertDialog(
//             title: Text("Please, Insert all required fields"),
// // content: const Text('This item is no longer available'),
//             actions: [
//               FlatButton(
//                 child: Text('Ok'),
//                 onPressed: () {
//               Navigator.pop(context);
//               _name.clear();
//               _address.clear();
//              _phone.clear();
//              useremail.clear();
//              userpassword.clear();

//                 },
//               ),
//             ],
//           );
//         },
//       );
//   }

    // else{
    DateTime dateTime = DateTime.now();
    final response = await http.post(apipath + '/register', body: {
      "username": _name.text,
      "email": useremail.text,
      "phone_number1": _phone.text,
      "appToken": widget.appid_token == null ? '' : widget.appid_token,
      "password": userpassword.text,
      'timezone': dateTime.timeZoneName
    }).then((result) async {
      print(result.body);
      var data = jsonDecode(result.body);
      if (data['error'] == 'Email already exists') {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            Map<String, dynamic> user = jsonDecode(result.body);
            return AlertDialog(
              title: Text("User already exists"),
              actions: [
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                    _name.clear();
                    _address.clear();
                    _phone.clear();
                    useremail.clear();
                    userpassword.clear();
                  },
                ),
              ],
            );
          },
        );
      } else if (data['error'] == 'Invalid Email') {
        return null;
      } else if (data == 'Fill all details..!') {
        return null;
      } else {
        setState(() {
          _login = true;
        });
        // _email;
        var body = json.decode(result.body);
        SharedPreferences localStorage = await SharedPreferences.getInstance();

        localStorage.setString('token', body['token']);
        localStorage.setString('name', body['username']);
        localStorage.setString('token', body['token']);
        localStorage.setString('id', body['user_id'].toString());
        localStorage.setString('desc', body['description']);
        localStorage.setString('phn', body['phone_number1']);
        localStorage.setString('adrs', body['address1']);
        localStorage.setString('email', body['email']);

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Upcomingappointment()));
      }
    });
  }

  _loginset() async {
    await http.post("http://192.168.1.9:3040/login", body: {
      'email': useremail.text,
      'password': userpassword.text,
    }).then((result) async {
      print(result.body);
      var data = jsonDecode(result.body);
      if (data['error'] == 'User does not exist') {
        return null;
      } else {
        setState(() {
          _login = true;
        });
        var body = json.decode(result.body);
        SharedPreferences localStorage = await SharedPreferences.getInstance();

        localStorage.setString('token', body['token']);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Categoryset()));
      }
    });
  }
}
// app token1234