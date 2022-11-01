import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewVideo extends StatefulWidget {
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewVideo> {
  WebViewController _webcontroller;

  var data;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('VIDEO'),
      ),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          
          initialUrl: "http://192.168.1.14:9999/",
          javascriptMode: JavascriptMode.unrestricted,
        );
      }),
    );
  }
}
