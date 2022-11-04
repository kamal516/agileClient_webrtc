import 'dart:convert';

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:doctoragileapp/api.dart';
import 'package:doctoragileapp/color.dart';

import 'package:doctoragileapp/homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profilepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<Profilepage> {
  String _email;
  String _password;
  final formkey = new GlobalKey<FormState>();
  FormType _formtype = FormType.login;
  TextEditingController updatemail = new TextEditingController();
  TextEditingController userpassword = new TextEditingController();
  TextEditingController updateusername = new TextEditingController();
  TextEditingController updateimage = new TextEditingController();
  TextEditingController updatephone = new TextEditingController();
  TextEditingController updateaddress = new TextEditingController();
  TextEditingController updateid = new TextEditingController();

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

    _localuserid();
  }

  AlertDialog alert = AlertDialog(
    title: Text("Notice"),
    content: Text("go to login"),
  );

  void movetoRegister() {
    formkey.currentState.reset();
    setState(() {
      _formtype = FormType.register;
    });
  }

  File _image;
  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
    print(_image);
  }

  void movetoLogin() {
    formkey.currentState.reset();
    setState(() {
      _formtype = FormType.login;
    });
  }

  bool isDisabled = false;
  bool _login = false;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        // bottomNavigationBar: BottomAppBar(
        //   child: Container(
        //     color: buttonColor,
        //     padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
        // child: new RaisedButton(
        //     color: buttonColor,
        //     shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.vertical(),
        //         side: BorderSide(color: Colors.black)),
        //     child: new Text(
        //       'UPDATE ',
        //       style: TextStyle(color: Colors.white, fontSize: 19),
        //     ),
        //     onPressed: () {
        //       _updatedata();

        //     }),
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
                  height: 420,
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
                  padding: EdgeInsets.only(top: 50, left: 40, right: 40),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                    padding: EdgeInsets.only(top: 7),
                                  )),
                              // SizedBox(
                              //   width: 80,
                              // ),
                              Center(
                                  child: Text(
                                'PROFILE',
                                style: TextStyle(
                                    fontSize: 19, color: Colors.black),
                              )),
                              // SizedBox(
                              //   width: 80,
                              // ),
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.white),
                                padding: EdgeInsets.only(top: 10, left: 8),
                              ),
                            ],
                          )),
                      TextFormField(
                        controller: updateusername,
                        keyboardType: TextInputType.emailAddress,
                        decoration: new InputDecoration(
                            fillColor: greyContainer,
                            filled: true,
                            labelText: "Username",
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.vertical(),
                            )),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      new TextFormField(
                        enabled: false,
                        controller: updatemail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: new InputDecoration(
                            fillColor: greyContainer,
                            filled: true,
                            labelText: "Email",
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.vertical(),
                            )),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        controller: updatephone,
                        autocorrect: true,
                        keyboardType: TextInputType.number,
                        maxLength: 15,
                        inputFormatters: <TextInputFormatter>[
                          // WhitelistingTextInputFormatter.digitsOnly
                        ],
                        decoration: new InputDecoration(
                            fillColor: greyContainer,
                            filled: true,
                            labelText: "Phone",
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.vertical(),
                            )),
                      ),
                      new RaisedButton(
                          color: buttonColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(),
                              side: BorderSide(color: Colors.black)),
                          child: new Text(
                            'UPDATE ',
                            style: TextStyle(color: Colors.white, fontSize: 19),
                          ),
                          onPressed: () {
                            _updatedata();
                          }),
                    ],
                  )))
        ],
      ),
    )
        //     SingleChildScrollView(
        //       child: Stack(
        //         children: <Widget>[
        //           Container(
        //             height: MediaQuery.of(context).size.height / 1.1,
        //             color: Colors.black,
        //             child: Stack(
        //               children: <Widget>[
        //                 Padding(
        //                   padding: EdgeInsets.only(top: 0, left: 0),
        //                   child: Image(
        //                     height: 200.0,
        //                     image: AssetImage('assets/Logo_BG.png'),
        //                     fit: BoxFit.fitHeight,
        //                   ),
        //                 ),
        //                 Padding(
        //                   padding: EdgeInsets.only(top: 200),
        //                   child: SingleChildScrollView(child: Container(
        //                       decoration: new BoxDecoration(
        //                           boxShadow: [
        //                             new BoxShadow(
        //                               color: Colors.black,
        //                               blurRadius: 20.0,
        //                             ),
        //                           ],
        //                           color: Colors.white,
        //                           borderRadius: new BorderRadius.only(
        //                             topLeft: const Radius.circular(40.0),
        //                             topRight: const Radius.circular(40.0),
        //                           )),
        //                       padding:
        //                           EdgeInsets.only(top: 50, left: 40, right: 40),
        //                       child: new Column(
        //                         crossAxisAlignment: CrossAxisAlignment.stretch,
        //                         mainAxisAlignment: MainAxisAlignment.start,
        //                         children: <Widget>[
        //                           Container(
        //                               padding: EdgeInsets.only(bottom: 20),
        //                               child: Row(
        //                                 crossAxisAlignment:
        //                                     CrossAxisAlignment.center,
        //                                 mainAxisAlignment:
        //                                     MainAxisAlignment.spaceAround,
        //                                 children: <Widget>[
        //                                   GestureDetector(
        //                                       onTap: () {
        //                                         Navigator.pop(context);
        //                                       },
        //                                       child: Container(
        //                                         height: 30,
        //                                         width: 30,
        //                                         decoration: BoxDecoration(
        //                                             borderRadius:
        //                                                 BorderRadius.circular(20.0),
        //                                             color: Colors.white),
        //                                         padding: EdgeInsets.only(top: 7),
        //                                       )),
        //                                   // SizedBox(
        //                                   //   width: 80,
        //                                   // ),
        //                                  Center(child:Text(
        //                                     'PROFILE',
        //                                     style: TextStyle(
        //                                         fontSize: 19, color: Colors.black),
        //                                   )),
        //                                   // SizedBox(
        //                                   //   width: 80,
        //                                   // ),
        //                                   Container(
        //                                     height: 30,
        //                                     width: 30,
        //                                     decoration: BoxDecoration(
        //                                         borderRadius:
        //                                             BorderRadius.circular(20.0),
        //                                         color: Colors.white),
        //                                     padding:
        //                                         EdgeInsets.only(top: 10, left: 8),
        //                                   ),
        //                                 ],
        //                               )),
        //                           TextFormField(
        //                             controller: updateusername,
        //                             keyboardType: TextInputType.emailAddress,
        //                             decoration: new InputDecoration(
        //                                 fillColor: greyContainer,
        //                                 filled: true,
        //                                 labelText: "Username",
        //                                 border: new OutlineInputBorder(
        //                                   borderRadius: new BorderRadius.vertical(),
        //                                 )),
        //                           ),
        //                           SizedBox(
        //                             height: 10.0,
        //                           ),
        //                           new TextFormField(
        //                             enabled: false,
        //                             controller: updatemail,
        //                             keyboardType: TextInputType.emailAddress,
        //                             decoration: new InputDecoration(
        //                                 fillColor: greyContainer,
        //                                 filled: true,
        //                                 labelText: "Email",
        //                                 border: new OutlineInputBorder(
        //                                   borderRadius: new BorderRadius.vertical(),
        //                                 )),
        //                           ),

        //                           SizedBox(
        //                             height: 10.0,
        //                           ),
        //                           TextFormField(
        //                             controller: updatephone,
        //                             autocorrect: true,
        //                             keyboardType: TextInputType.number,
        //                             maxLength: 15,
        //                             inputFormatters: <TextInputFormatter>[
        //                               // WhitelistingTextInputFormatter.digitsOnly
        //                             ],
        //                             decoration: new InputDecoration(
        //                                 fillColor: greyContainer,
        //                                 filled: true,
        //                                 labelText: "Phone",
        //                                 border: new OutlineInputBorder(
        //                                   borderRadius: new BorderRadius.vertical(),
        //                                 )),
        //                           ),
        // //                              Container(

        // //                             width: MediaQuery.of(context).size.width,
        // //                             height: 100.0,
        // //                             child: Center(
        // //                               child: _image == null
        // //                                   ?
        // //                                   // CachedNetworkImage(
        // //                                   //   imageUrl:getprofile==null?'':getprofile,
        // //                                   // )
        // //                            Image.network(_localprofile==null?'':_localprofile)
        // //                                 : Image.file(_image),
        // //                             ),
        // //                           ),
        // //                           Row(
        // //                          //   crossAxisAlignment: CrossAxisAlignment.start,
        // //                             mainAxisAlignment:
        // //                                 MainAxisAlignment.spaceEvenly,
        // //                             children: <Widget>[
        // //                               FloatingActionButton(
        // //                                 onPressed: getImageFromGallery,
        // //                                 tooltip: 'Pick Image',
        // //                                 child: Icon(Icons.wallpaper),
        // //                               ),
        // //                               SizedBox(
        // //                             width: 40,
        // //                           ),
        // //                                RaisedButton(
        // //             color: kPrimaryColor,
        // //             shape: RoundedRectangleBorder(
        // //                 borderRadius: BorderRadius.vertical(),
        // //                 side: BorderSide(color: Colors.black)),
        // //             child: new Text(
        // //               'upload ',
        // //               style: TextStyle(color: Colors.white, fontSize: 19),
        // //             ),
        // //             onPressed: ()async {
        // //            uploadImage(_image);
        // //             SharedPreferences localStorage = await SharedPreferences.getInstance();
        // // localStorage.remove('profile');

        // //             }),
        // //                             ],
        // //                           ),

        //                         ],
        //                       )
        //                       ),
        //                 ),
        //                   )
        //                    ],
        //             ),
        //           ),
        //         ],
        //       ),
        //     )
        );
  }

  String _idlocal;
  String _localupdateusername;
  String _localupdatephone;
  String _localupdateaddress;
  String _localupdateemaill;
  String _localprofile;
  _localuserid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _idlocal = preferences.getString("id");
      _localupdateusername = preferences.getString("name");

      _localupdatephone = preferences.getString("phn");
      _localupdateaddress = preferences.getString("adrs");
      _localupdateemaill = preferences.getString("email");
      _localprofile = preferences.getString("profile");
    });
    updateusername = new TextEditingController(text: _localupdateusername);
    updatemail = new TextEditingController(text: _localupdateemaill);
    updatephone = new TextEditingController(text: _localupdatephone);
    updateaddress = new TextEditingController(text: _localupdateaddress);
    //  _image= File(_localprofile);
    //  print(_image.path);
  }

  String getimageurl;
  uploadImage(filename) async {
    var request =
        http.MultipartRequest('POST', Uri.parse(apipath + '/uploadImage'));
    request.fields['username'] = updateusername.text;
    request.files.add(await http.MultipartFile.fromPath('file', _image.path));
    var res = await request
        .send()
        .then((result) async {
          http.Response.fromStream(result).then((response) {
            if (response.statusCode == 200) {
              print("Uploaded! ");
              print('response.body ' + response.body);
            }

            //  return response.body;
            var userdata = json.decode(response.body);
            setState(() {
              getimageurl = userdata['path'];
            });
          });
        })
        .catchError((err) => print('error : ' + err.toString()))
        .whenComplete(() {});
  }

  String getprofile;
  List userdata;
  String imageUrl = 'http://34.220.96.188:3000';
  Future<List> _updatedata() async {
    final response = await http.post(apipath + '/updateuserdata', body: {
      "username": updateusername.text,
      "email": updatemail.text,
      "phone_number1": updatephone.text,
      // "address1": updateaddress.text,
      "user_id": _idlocal,
      // "user_profile": imageUrl+getimageurl,
    }).then((result) async {
      print(result.body);
      var userdata = json.decode(result.body);
// setState(() {
//   getprofile=userdata['user_profile'];
// });
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Upcomingappointment()));
      SharedPreferences localStorage = await SharedPreferences.getInstance();

      localStorage.setString('email', userdata['email']);
      localStorage.setString('phn', userdata['phone_number1']);
      localStorage.setString('name', userdata['username']);
      localStorage.setString('profile', userdata['user_profile']);
    });
    _localuserid();
  }
}
