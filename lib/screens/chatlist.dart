// ignore_for_file: missing_return

import 'dart:async';
import 'dart:convert';

import 'package:doctoragileapp/testvideo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:intl/intl.dart';
import 'package:doctoragileapp/api.dart';
import 'package:doctoragileapp/color.dart';
import 'package:http/http.dart' as http;
import 'package:doctoragileapp/messagelist.dart';
import 'package:doctoragileapp/screens/webviewvideo.dart';
import 'package:doctoragileapp/webrtc_videoCall/signaling.dart';
import 'package:doctoragileapp/webrtc_videoCall/video_page.dart';
import 'package:doctoragileapp/widgets/ZoomMeeting.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:io' as io;

import '../color.dart';

class Chatlist extends StatefulWidget {
  final String doctorname;
  final String holderid;
  Chatlist({this.doctorname, this.holderid});
  @override
  _TestcatState createState() => _TestcatState();
}

class _TestcatState extends State<Chatlist>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();
    // requestPermissions();
    // startTimer();
    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });
    signaling.openUserMedia(_localRenderer, _remoteRenderer);
    super.initState();

    getid();
    startTimer();
  }

  void deactivate() {
    if (_timer.isActive) {
      _timer.cancel();
    } else {
      startTimer();
    }
    super.deactivate();
  }

  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String roomId;
  TextEditingController textEditingController = TextEditingController(text: '');
  bool recording = false;
  int _time = 0;
//        _scrollController.animateTo(
// _scrollController.position.maxScrollExtent,
// duration: const Duration(milliseconds: 1),
// curve: Curves.easeOut);

  final ScrollController _scrollController = ScrollController();
  static Database _db;
  static const String DB_NAME = "chat.db";

  static const String TABLE = "message";
  static const String Messagelist = "messagelist";
  static const String To = "to_id";
  static const String From = "from_id";
  static const String MessageDate = "messagedate";
  // static const DateTime MessageDate = "messagedate";
  static int Messageid = "messagechat_id" as int;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await chatdb();
    return _db;
  }

  chatdb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _createchatdb);
    return db;
  }

  _createchatdb(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE(   messageid  INTEGER PRIMARY KEY  ,  $To TEXT,$From TEXT,$MessageDate TEXT DEFAULT CURRENT_TIMESTAMP,$Messagelist TEXT)");
  }

  List messagelist = [];
  var selectmaxid;

  _chatlist() async {
    var dbClient = await db;

    var test = await dbClient.rawQuery(
        //   "Select * from $TABLE  where ($From=$_localid and $To='${widget.holderid}')"+
        // " or ($From='${widget.holderid}'  and $To=$_localid)  and"+
        //         "(messagelist not like '**meeting%' or "+
        //        " (messagelist  like '**meeting%' and (messagedate >= datetime('now','-20 minutes')))) order by messageid desc Limit 15");
        "Select * from $TABLE  where ($From=$_localid and $To='${widget.holderid}') or ($From='${widget.holderid}'  and $To=$_localid) order by messageid desc Limit 15");
    print(test);
    setState(() {
      messagelist = test;
    });
//     if (_scrollController.hasClients) {
//     _scrollController.animateTo(messagelist.length.toDouble(),
//      duration: const Duration(milliseconds: 1),
//  curve: Curves.easeInOut);
// }

    selectmaxid = await dbClient.rawQuery(
        "select Max(messageid) AS maxid  FROM $TABLE  where ($From=$_localid and $To='${widget.holderid}') or ($From='${widget.holderid}'  and $To=$_localid)");
    print(selectmaxid[0]["maxid"].toString());
//    if (_scrollController.hasClients) {
//     _scrollController.animateTo(selectmaxid[0]["maxid"],
//      duration: const Duration(milliseconds: 1),
//  curve: Curves.easeInOut);
// }
    print(messagelist);

    _getmessage();
  }

  void startTimer() {
    _timer = new Timer.periodic(new Duration(seconds: 2), (time) {
      _chatlist();
    });
  }

  Timer _timer;

  String _localid;
  String _loginedusername;
  getid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _localid = preferences.getString("id");
      _loginedusername = preferences.getString("name");
    });
    _chatlist();
  }

  List fetchmeassagedata;
  String messagedata;
  int modifyList;
  int donelist;

  TextEditingController message = new TextEditingController();
  DateTime dateTime = DateTime.now();
  Future<List> _getmessage() async {
    var dbClient = await db;

    final response = await http.post(apipath + '/getAllMessage', body: {
      "from_user_id": _localid,
      "to_user_id": widget.holderid,
      "messagechat_id": selectmaxid[0]["maxid"].toString(),
      'timezone': dateTime.timeZoneName
    }).then((result) async {
      print(result.body);

      setState(() {
        fetchmeassagedata = jsonDecode(result.body);
      });

      for (int i = 0; i <= fetchmeassagedata.length - 1; i++) {
        var table =
            ("INSERT OR REPLACE INTO $TABLE (  'messageid' , $To , $From ,$MessageDate  ,$Messagelist )   VALUES ( ${fetchmeassagedata[i]['messagechat_id']}, ${fetchmeassagedata[i]['to_user_id']},'${fetchmeassagedata[i]['from_user_id']}','${fetchmeassagedata[i]['created_at']}','${fetchmeassagedata[i]['message_summary']}')");
        dbClient.transaction((txn) async {
          print(table);

          return await txn.rawInsert(table);
        });
      }
    });
  }

  Future<List> _sendmessage() async {
    final response = await http.post(apipath + '/addMessage', body: {
      "from_user_id": _localid,
      "to_user_id": widget.holderid,
      "message_summary": message.text,
      'timezone': dateTime.timeZoneName
    }).then((value) async {
      print(value.body);
      setState(() {
        messagedata = value.body;
      });
      print(messagedata);
      _getmessage();
    });
  }

  List<String> lst = ['MODIFY', 'DONE'];
  int selectedIndex = 0;
  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget _senderbuttton(BuildContext context) {
    return Container(
      // color: kPrimaryLightColour,
      margin: EdgeInsets.all(15.0),
      height: 61,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35.0),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 3), blurRadius: 5, color: Colors.grey)
                ],
              ),
              child: Row(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(right: 20)),
                  Expanded(
                    child: TextFormField(
                      controller: message,
                      decoration: InputDecoration(
                          hintText: "Type Something...",
                          border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // IconButton(icon: Icon(Icons.video_call), onPressed: (){
          //   Navigator.push(context, MaterialPageRoute(builder: (context)=>WebViewVideo()));
          // }),
          SizedBox(width: 15),
          Container(
              padding: const EdgeInsets.all(10.0),
              decoration:
                  BoxDecoration(color: buttonColor, shape: BoxShape.circle),
              child: IconButton(
                  icon: Icon(Icons.send),
                  color: iconColor,
                  onPressed: () {
                    _sendmessage();
                    message.clear();
                  }))
        ],
      ),
    );
  }

  Widget chatdata(BuildContext context) {
    return Container(
        color: greyContainer,
        height: (MediaQuery.of(context).size.height - 180),
        padding: EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
            child: ListView.builder(
                itemCount: messagelist == null ? 0 : messagelist.length,
                shrinkWrap: true,
                reverse: true,
                controller: _scrollController,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  String messagefrom = messagelist[index]['messagelist'];
                  String _messageTime = messagelist[index]['messagedate'];
                  var _currentDate = DateFormat("yyyy-MM-dd hh:mm:ss")
                      .format(DateTime.now().subtract(Duration(hours: 5)));
                  var _time = DateFormat("yyyy-MM-dd hh:mm:ss")
                      .format(DateTime.parse(_messageTime));
                  var _replaceMeeting = messagefrom
                      .replaceAll(":", "&")
                      .replaceAll("?", "&")
                      .replaceAll("=", "&");
                  var _getMeetingCred = _replaceMeeting.split("&");
                  var _replace = messagefrom
                      .replaceAll("/", "&")
                      .replaceAll("?", "&")
                      .replaceAll("#", "&");
                  // ignore: unused_local_variable
                  var _splittext = _replace.split("&");
                  if (_localid == messagelist[index]['from_id']) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 7,
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * .6),
                          padding: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            color: buttonColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                            ),
                          ),
                          child: Text(
                            messagelist[index]['messagelist'],
                            style: Theme.of(context).textTheme.bodyText2.apply(
                                  color: Colors.white,
                                ),
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        )
                      ],
                    );
                  } else if (_localid != messagelist[index]['from_id']) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * .6),
                          padding: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25),
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                            ),
                          ),
                          child: _getMeetingCred[0]
                                  .toString()
                                  .startsWith("start"
                                      //"**meeting"
                                      )
                              ? IconButton(
                                  tooltip: "zoom meeting",
                                  icon: Icon(
                                    Icons.videocam,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    print(_getMeetingCred[0]
                                        .replaceAll("start", ""));
                                    // print(
                                    //     messagelist[index]['messagelist'].last);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TestVideo(
                                                  videoToken: _getMeetingCred[0]
                                                      .replaceAll("start", ""),
                                                )
                                            //  VideoPage(
                                            //       videoToken: _getMeetingCred[0]
                                            //           .replaceAll("start", ""),
                                            //       localvideo: _localRenderer,
                                            //       remotevideo: _remoteRenderer,
                                            //     )
                                            ));
                                    // signaling.joinRoom(
                                    //   textEditingController.text,
                                    //   _remoteRenderer,
                                    // );
                                    // if (DateTime.parse(_time).isBefore(
                                    //     DateTime.parse(_currentDate))) {
                                    //   Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //           builder: (context) => VideoPage(
                                    //                 videoToken:
                                    //                     _getMeetingCred[0]
                                    //                         .replaceAll(
                                    //                             "start", ""),
                                    //                 localvideo: _localRenderer,
                                    //                 remotevideo:
                                    //                     _remoteRenderer,
                                    //               )));
                                    // }
                                    // setState(() {
                                    //   message.text=_getMeetingCred[1].toString();
                                    // });

                                    // if (DateTime.parse(_time).isBefore(
                                    //     DateTime.parse(_currentDate))) {
                                    //   Navigator.of(context).push(
                                    //     MaterialPageRoute(
                                    //       builder: (context) {
                                    //         return MeetingWidget(
                                    //             displayname: _loginedusername,
                                    //             meetingId: _getMeetingCred[1]
                                    //             .toString(),
                                    //             meetingPassword:
                                    //             _getMeetingCred[3]
                                    //             .toString()
                                    //          );
                                    //       },
                                    //     ),
                                    //   );
                                    // }
                                    // else {
                                    //   return;
                                    // }
                                  })
                              // Text(
                              //   messagelist[index]['messagelist'],
                              //   style: Theme.of(context).textTheme.body1.apply(
                              //    color: Colors.blue,
                              //   ),
                              // )
                              : Text(
                                  messagelist[index]['messagelist'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .apply(
                                        color: Colors.black87,
                                      ),
                                ),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                      ],
                    );
                  }
                })));
  }

  // Widget chatdata(BuildContext context) {

  //   return Container(
  //       color: kPrimaryLightColour,
  //       height: (MediaQuery.of(context).size.height - 180),
  //       padding: EdgeInsets.only(left: 10, right: 10),
  //       child: SingleChildScrollView(

  //           child: ListView.builder(
  //               itemCount: messagelist == null ? 0 : messagelist.length,
  //               shrinkWrap: true,
  //               reverse: true,
  //               controller: _scrollController,
  //               physics: NeverScrollableScrollPhysics(),
  //               itemBuilder: (BuildContext context, int index) {

  //                 if (_localid == messagelist[index]['from_id']) {
  //                   return
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.end,
  //                     children: [
  //                       SizedBox(
  //                         height: 7,
  //                       ),

  //                       Container(
  //                         constraints: BoxConstraints(
  //                             maxWidth: MediaQuery.of(context).size.width * .6),
  //                         padding: const EdgeInsets.all(15.0),
  //                         decoration: BoxDecoration(
  //                           color: kPrimaryDarkColor,
  //                           borderRadius: BorderRadius.only(
  //                             topLeft: Radius.circular(25),
  //                             bottomLeft: Radius.circular(25),
  //                             bottomRight: Radius.circular(25),
  //                           ),
  //                         ),
  //                         child: Text(
  //                           messagelist[index]['messagelist'],
  //                           style: Theme.of(context).textTheme.body1.apply(
  //                                 color: Colors.white,
  //                               ),
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 7,
  //                       )
  //                     ],
  //                   );

  //                 } else if (_localid != messagelist[index]['from_id']) {
  //                   return Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Container(
  //                         constraints: BoxConstraints(
  //                             maxWidth: MediaQuery.of(context).size.width * .6),
  //                         padding: const EdgeInsets.all(15.0),
  //                         decoration: BoxDecoration(
  //                           color: Colors.white,
  //                           borderRadius: BorderRadius.only(
  //                             topRight: Radius.circular(25),
  //                             bottomLeft: Radius.circular(25),
  //                             bottomRight: Radius.circular(25),
  //                           ),
  //                         ),
  //                         child: Text(
  //                           messagelist[index]['messagelist'],
  //                           style: Theme.of(context).textTheme.body1.apply(
  //                                 color: Colors.black87,
  //                               ),
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 7,
  //                       ),
  //                     ],
  //                   );
  //                 }
  //               })

  //               ));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 6, left: 0, right: 0, bottom: 1),
        // color: kPrimaryDarkColor,
        child: new Container(
            decoration: new BoxDecoration(
                // color: kPrimaryLightColour,
                borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(40.0),
              topRight: const Radius.circular(40.0),
              bottomLeft: const Radius.circular(1.0),
              bottomRight: const Radius.circular(1.0),
            )),
            child: Column(
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
                                // SizedBox(
                                //   width: 100,
                                // ),
                                Center(
                                    child: Text(
                                  widget.doctorname,
                                  style: TextStyle(
                                      color: buttonTextColor, fontSize: 19),
                                )),
                                // SizedBox(
                                //   width: 100,
                                // ),
                              ]),
                        ),
                        chatdata(context),
                        _senderbuttton(context)
                      ]),
                ])),
      ),
    ));
  }
}
