// import 'package:flutter/material.dart';
// import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
// import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
// import 'package:intl/intl.dart';
// import 'package:newagileapp/color.dart';

// class UpdateTimeDate extends StatefulWidget {
    
//   @override
//   _WidgetPageState createState() => _WidgetPageState();
// }

// class _WidgetPageState extends State<UpdateTimeDate> {

//   DateTime _selectedDate;
//   DateTime _dateTime = DateTime.now();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: BottomAppBar(child:   Container(
//                                   padding: EdgeInsets.only(left: 10, right: 10),
//                                   child: RaisedButton(
//                                     onPressed: () {
//                                       if(_selectedDate==null||_dateTime==null){
//                                         setState(() {
//                                           _timer=DateFormat('yyyy-MM-dd  HH:MM').format(DateTime.now());
//                                         //  DateTime.now().toString();
//                                         });
                                        
//                                       }else{
//                                          setState(() {
//                                         _timer =_selectedDate .year.toString() +
//                                             '-' +
//                                             _selectedDate.month.toString() +
//                                             '-' +
//                                             _selectedDate.day.toString() +
//                                             ' ' +
//                                             _dateTime.hour
//                                                 .toString()
//                                                 .padLeft(2, '0') +
//                                             ':' +
//                                             _dateTime.minute
//                                                 .toString()
//                                                 .padLeft(2, '0') ;
                                          
//                                       });}
                                  
                                      
//                                       Navigator.pop(
//                                         context,
//                                         _timer,
//                                       );
                                      
                                  
//                                     },
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(10.0)),
//                                     color: logincolr,
//                                     //  borderSide: BorderSide(color: selectedIndex == index ? Colors.cyan : Colors.grey),
//                                     child: Text(
//                                       'DONE',
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   )),),
//       body: SingleChildScrollView(child:
//       Container(
//         padding: EdgeInsets.only(top: 15),
//         color: backgroundthemecolor,
//         child: new Container(
//             decoration: new BoxDecoration(
//                 color: backgroundthemecolor,
//                 borderRadius: new BorderRadius.only(
//                   topLeft: const Radius.circular(40.0),
//                   topRight: const Radius.circular(40.0),
//                 )),
//             padding: EdgeInsets.only(
//               top: 0,
//             ),
//             child: new Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: <Widget>[
//                       Container(
//                         height: 73,
//                         decoration: new BoxDecoration(
//                             color: headerthemecolor,
//                             borderRadius: new BorderRadius.only(
//                               topLeft: const Radius.circular(40.0),
//                               topRight: const Radius.circular(40.0),
//                             )),
//                         child: Row(children: <Widget>[
//                           IconButton(
//                               icon: Icon(
//                                 Icons.arrow_back,
//                                 color: Colors.white,
//                               ),
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               }),
//                           SizedBox(
//                             width: 60,
//                           ),
//                           Text(
//                             'Select date and time',
//                             style: TextStyle(color: Colors.white, fontSize: 19),
//                           ),

//                           // IconButton(icon: Icon(Icons.power_settings_new,color: Colors.white,), onPressed: null),
//                         ]),
//                       ),
//                     ]),
//                 SizedBox(height: 0),
//                 Column(
//                   children: <Widget>[
//                     Container(
//                         height: 30,
//                         width: 450,
//                         color: Colors.grey[300],
//                         alignment: Alignment.center,
//                         child: Text(
//                           'Date',
//                           style: TextStyle(fontSize: 22),
//                         )),
//                     Container(
//                       padding: EdgeInsets.only(top: 30, left: 35, right: 35),
//                       child: DatePickerWidget(
//                         looping: false, // default is not looping
//                         firstDate:
//                         // DateTime.parse(widget.selectedtime)  ,
//                         DateTime.now(),
                        
//                         lastDate: DateTime(2040, 1, 1),
//                         initialDate: DateTime(1990),
//                         dateFormat: "dd-MMMM-yyyy",
//                         locale: DateTimePickerLocale.en_us,
//                         onChange: (DateTime newDate, _) {
//                           _selectedDate = newDate;
//                         },
//                         pickerTheme: DateTimePickerTheme(
//                           itemTextStyle:
//                               TextStyle(color: Colors.black, fontSize: 20),
//                           dividerColor: Colors.blue,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 40,
//                     ),
//                     Padding(padding: EdgeInsets.only(top:10),
//                     child:
//                     Container(
//                         height: 30,
//                         width: 450,
//                         color: Colors.grey[300],
//                         alignment: Alignment.center,
//                         child: Text(
//                           'Time',
//                           style: TextStyle(fontSize: 22),
//                         )),),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Padding(padding: EdgeInsets.only(top:10),
//                     child:
//                     Container(
//                       color: Colors.white,
//                       padding: EdgeInsets.only(top: 10),
//                       child: new Column(
//                         //    crossAxisAlignment: CrossAxisAlignment.center,
//                         // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: <Widget>[
// //            hourMinute12H(),
//                           hourMinute15Interval(),
// //            hourMinuteSecond(),
// //            hourMinute12HCustomStyle(),
//                           new Container(
//                             // padding: EdgeInsets.only(),
//                             margin: EdgeInsets.symmetric(vertical: 50),
//                             child: new Text(
//                               _dateTime.hour.toString().padLeft(2, '0') +
//                                   ':' +
//                                   _dateTime.minute.toString().padLeft(2, '0') 
//                                   ,
                          
//                               style: TextStyle(
//                                   fontSize: 20, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: <Widget>[
//                               // Container(
//                               //     padding: EdgeInsets.only(left: 10, right: 10),
//                               //     child: RaisedButton(
//                               //       onPressed: () {
//                               //         setState(() {
//                               //           _timer = _selectedDate.year.toString() +
//                               //               ':' +
//                               //               _selectedDate.month.toString() +
//                               //               ':' +
//                               //               _selectedDate.day.toString() +
//                               //               '   ' +
//                               //               _dateTime.hour
//                               //                   .toString()
//                               //                   .padLeft(2, '0') +
//                               //               ':' +
//                               //               _dateTime.minute
//                               //                   .toString()
//                               //                   .padLeft(2, '0') +
//                               //               ':' +
//                               //               _dateTime.second
//                               //                   .toString()
//                               //                   .padLeft(2, '0');
//                               //         });
//                               //         Navigator.pop(
//                               //           context,
//                               //           _timer,
//                               //         );
//                               //       },
//                               //       shape: RoundedRectangleBorder(
//                               //           borderRadius:
//                               //               BorderRadius.circular(10.0)),
//                               //       color: logincolr,
//                               //       //  borderSide: BorderSide(color: selectedIndex == index ? Colors.cyan : Colors.grey),
//                               //       child: Text(
//                               //         'DONE',
//                               //         style: TextStyle(color: Colors.white),
//                               //       ),
//                               //     )),
//                             ],
//                           )
//                         ],
//                       ),
//                     ))
//                   ],
//                 )
//               ],
//             )),
//       ),)
//     );
//   }

//   Widget hourMinute12H() {
//     return new TimePickerSpinner(
//       is24HourMode: false,
//       onTimeChange: (time) {
//         setState(() {
//           _dateTime = time;
//         });
//       },
//     );
//   }

//   Widget hourMinuteSecond() {
//     return new TimePickerSpinner(
//       isShowSeconds: true,
//       onTimeChange: (time) {
//         setState(() {
//           _dateTime = time;
//         });
//       },
//     );
//   }

//   String _timer;
//   Widget hourMinute15Interval() {
//     return new TimePickerSpinner(
//       spacing: 100,
//       itemHeight: 40,
//       minutesInterval: 15,
//       onTimeChange: (time) {
//         setState(() {
//           _dateTime = time;
//         });
//       },
//     );
//   }

//   Widget hourMinute12HCustomStyle() {
//     return new TimePickerSpinner(
//       is24HourMode: false,
//       normalTextStyle: TextStyle(fontSize: 24, color: Colors.deepOrange),
//       highlightedTextStyle: TextStyle(fontSize: 24, color: Colors.yellow),
//       spacing: 50,
//       itemHeight: 80,
//       isForce2Digits: true,
//       minutesInterval: 15,
//       onTimeChange: (time) {
//         setState(() {
//           _dateTime = time;
//         });
//       },
//     );
//   }
// }
