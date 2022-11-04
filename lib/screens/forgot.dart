import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doctoragileapp/api.dart';
import 'package:doctoragileapp/color.dart';
import 'package:doctoragileapp/categories.dart';
import 'package:doctoragileapp/screens/rootpage.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ResetPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<ResetPassword> {
  String _email;
  String _password;
  final formkey = new GlobalKey<FormState>();
  FormType _formtype = FormType.login;
  TextEditingController useremail = new TextEditingController();
  TextEditingController userpassword = new TextEditingController();
  TextEditingController _name = new TextEditingController();
  TextEditingController _description = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _address = new TextEditingController();
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
  }

  AlertDialog alert = AlertDialog(
    title: Text("Notice"),
    content: Text("go to login"),
  );

  void validateandsubmit() async {}

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

  Future<List> sendresetpassword() async {
    final response = await http.post(apipath + '/forgotPassword',
        //  "http://192.168.1.6:3040/forgotPassword",
        //  "https://agilemedapp-cn4rzuzz6a-el.a.run.app/createAppointment",
        body: {
          "email": useremail.text,
          // "email": useremail.text,
          // "description": _description.text,
          // "phone_number1":_phone.text,
          // "address1":_address.text,
        }).then((value) {
      print(value.body);
      var data = jsonDecode(value.body);
      if (data["data"] == "Recovery Email Sent") {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              // title: Text('Not in stock'),
              content: const Text(
                'Recovery Email Sent Kindly \n Please Check',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              actions: [
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    setState(() {
                      useremail.text = "";
                    });
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => Rootpage()),
                        (Route<dynamic> route) => false);
                  },
                ),
              ],
            );
          },
        );
        print("Something done");
      } else if (data["message"] == "email is not in db") {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              // title: Text('Not in stock'),
              content: const Text(
                'Email Not Found',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
              actions: [
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        print("email not found");
      } else {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              // title: Text('Not in stock'),
              content: const Text(
                'something went wrong...!!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
              actions: [
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        print("something went wrong...!!");
      }
    });
  }

  bool _login = false;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Reset Password'),
          backgroundColor: buttonColor,
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.person,
                    size: 80,
                    color: buttonTextColor,
                  ),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 32, right: 32),
                    child: Text(
                      'Signin',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 60.0,
          ),
          new SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: new Form(
                key: formkey,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: buildInputs() + buildsubmitButtons(),
                )),
          )
        ])));
  }

  List<Widget> buildInputs() {
    return [
      new TextFormField(
        controller: useremail,
        keyboardType: TextInputType.emailAddress,
        decoration: new InputDecoration(
            filled: true,
            fillColor: greyContainer,
            labelText: 'Email',
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(65.0),
            )),
      ),
      SizedBox(
        height: 10.0,
      ),
      // TextFormField(
      //   obscureText: true,
      //   controller: userpassword,
      //   keyboardType: TextInputType.emailAddress,
      //   decoration: new InputDecoration(
      //       filled: true,
      //       fillColor: kPrimaryLightColour,
      //       labelText: 'New Password',

      //       border: new OutlineInputBorder(
      //         borderRadius: new BorderRadius.circular(65.0),
      //       )),
      // ),
      // SizedBox(
      //   height: 10,
      // )
    ];
  }

  // Future<List> sendresetpassword() async {
  //   final response = await http.post(apipath + '/forgotPassword',

  //       body: {
  //         "username": useremail.text,

  //         "password": userpassword.text,
  //       });
  // }

  _loginset() async {
    await http.post(apipath + '/login', body: {
      'username': useremail.text,
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

  List<Widget> buildsubmitButtons() {
    if (_formtype == FormType.login) {
      return [
        new RaisedButton(
            color: buttonColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.black)),
            child: new Text(
              'Reset',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              sendresetpassword();
            }),
      ];
    }
    // else {
    //   return [
    //     new RaisedButton(
    //         color: themecolor,
    //         shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(18.0),
    //             side: BorderSide(color: Colors.red)),
    //         child: new Text('Register'),
    //         onPressed: () {

    //           _loginset();
    //         }),

    //   ];
    // }
  }
}
