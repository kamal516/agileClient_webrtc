import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:doctoragileapp/api.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../homescreen.dart';

class WebViewExample extends StatefulWidget {
  final String paymenttoken;
  final int appointmentid;
  WebViewExample({this.paymenttoken, this.appointmentid});
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  WebViewController _webcontroller;

  void startTimer() {
    _timer = new Timer.periodic(new Duration(seconds: 1), (time) {
      _paymentdone();
    });
  }

  var data;
  Timer _timer;
  void _paymentdone() async {
    http.post(apipath + '/getAppointmentDetails', body: {
      'appointment_id': widget.appointmentid.toString(),
    }).then((result) async {
      print(result.body);
      data = jsonDecode(result.body);
      if (data['payment_status'] == "Confirmed") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => Upcomingappointment()),
            (Route<dynamic> route) => false);
      }
      if (data['appointment_status'] == "Confirm") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => Upcomingappointment()),
            (Route<dynamic> route) => false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    // _webcontroller.canGoBack().then((value) {
    //   if (value) {
    //     _webcontroller.goBack();
    //   } else {
    //     Navigator.pop(context);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          //  PreferredSize(
          // preferredSize: Size.fromHeight(25),
          // child:

          AppBar(
        backgroundColor: Colors.black,
        title: const Text('PAYMENT'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => Upcomingappointment()),
                  (Route<dynamic> route) => false);
            }),
      ),

      //),
      body: Builder(builder: (BuildContext context) {
        return
//            WebviewScaffold(

//           url:
//  "http://34.220.96.188:3000/payment/"+ widget.paymenttoken,
// http://52.37.166.43:3000/payment/
//         );
            WebView(
          initialUrl:
              "https://www.lacimasoftware.com/payment/" + widget.paymenttoken,
          // "http://52.37.166.43:80/payment/",
          javascriptMode: JavascriptMode.unrestricted,
        );
      }),
    );
  }
}
