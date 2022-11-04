import 'package:doctoragileapp/homescreen.dart';
import 'package:doctoragileapp/webrtc_videoCall/signaling.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class TestVideo extends StatefulWidget {
  String videoToken;
  TestVideo({Key key, this.videoToken}) : super(key: key);

  @override
  State<TestVideo> createState() => _TestVideoState();
}

class _TestVideoState extends State<TestVideo> {
  @override
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String roomId;
  TextEditingController textEditingController = TextEditingController(text: '');
  bool recording = false;
  int _time = 0;

  // requestPermissions() async {
  //   await PermissionHandler().requestPermissions([
  //     PermissionGroup.storage,
  //     PermissionGroup.photos,
  //     PermissionGroup.microphone,
  //   ]);
  // }

  // void startTimer() {
  //   CountdownTimer countDownTimer = new CountdownTimer(
  //     new Duration(seconds: 1000),
  //     new Duration(seconds: 1),
  //   );

  //   var sub = countDownTimer.listen(null);
  //   sub.onData((duration) {
  //     setState(() => _time++);
  //   });

  //   sub.onDone(() {
  //     print("Done");
  //     sub.cancel();
  //   });
  // }

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
    signaling.joinRoom(
      widget.videoToken,
      _remoteRenderer,
    );
    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  int vt = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
          child: IconButton(
              onPressed: () {
                signaling.hangUp(_localRenderer);
                //  Navigator.pop(context);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            Upcomingappointment()),
                    (Route<dynamic> route) => false);
              },
              icon: Icon(
                Icons.call_end_outlined,
                color: Colors.white,
              )),
        ),
        body: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  vt != 1
                      ? Stack(
                          children: [
                            AspectRatio(
                                aspectRatio: 1 / 1.8,
                                child: Column(
                                  children: [
                                    Expanded(
                                        child: RTCVideoView(_localRenderer,
                                            mirror: true)),
                                  ],
                                )),
                            Positioned(
                                bottom: 10,
                                right: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      vt = 1;
                                    });
                                    print(vt);
                                  },
                                  child: Container(
                                      width: 150,
                                      height: 200,
                                      // color: Colors.red,
                                      child: AspectRatio(
                                          aspectRatio: 2,
                                          child: Column(
                                            children: [
                                              Expanded(
                                                  child: RTCVideoView(
                                                      _remoteRenderer)),
                                            ],
                                          ))),
                                )),
                          ],
                        )
                      : Stack(
                          children: [
                            AspectRatio(
                                aspectRatio: 1 / 1.8,
                                child: Column(
                                  children: [
                                    Expanded(
                                        child: RTCVideoView(_remoteRenderer,
                                            mirror: true)),
                                  ],
                                )),
                            Positioned(
                                bottom: 10,
                                right: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      vt = 0;
                                    });
                                    print(vt);
                                  },
                                  child: Container(
                                      width: 150,
                                      height: 200,
                                      // color: Colors.red,
                                      child: AspectRatio(
                                          aspectRatio: 2,
                                          child: Column(
                                            children: [
                                              Expanded(
                                                  child: RTCVideoView(
                                                      _localRenderer)),
                                            ],
                                          ))),
                                )),
                          ],
                        )
                ],
              ),
            ),
          ],
        )
        //      Column(
        //   crossAxisAlignment: CrossAxisAlignment.stretch,
        //   children: [
        //     Expanded(
        //       child: Padding(
        //         padding: const EdgeInsets.all(0.0),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.stretch,
        //           children: [
        //             Expanded(child: RTCVideoView(_localRenderer, mirror: true)),
        //             Expanded(child: RTCVideoView(_remoteRenderer)),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // )

        );
  }
}
