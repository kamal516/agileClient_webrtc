// import 'package:flutter/material.dart';
// import 'package:newagileapp/screens/login.dart';
// import 'package:newagileapp/triage/aptmntriage.dart';
// import 'package:newagileapp/triage/categories.dart';


// class BottomBarScreen extends StatefulWidget {
// @override
// _BottomBarScreenState createState() => _BottomBarScreenState();
// }

// class _BottomBarScreenState extends State<BottomBarScreen> {
// int _currentIndex=0;

// var pages = <Widget>[
// Loginpage(),
// Categoryset(),
// EventSelect(),
// Text('TRIAGESCREEN'),

// ];


// @override
// Widget build(BuildContext context) {
// return Scaffold(
// body: Center(child: pages.elementAt(_currentIndex),),
// bottomNavigationBar: BottomNavigationBar(
// currentIndex: _currentIndex,
// items: [
// BottomNavigationBarItem(
// icon: Icon(Icons.home),
// title:  Text("SERVICE"),
// backgroundColor: Colors.blue
// ),
// BottomNavigationBarItem(
// icon: Icon(Icons.search),
// title: Text("APPOINTMENT"),
// backgroundColor: Colors.blue
// ),
// BottomNavigationBarItem(
// icon: Icon(Icons.message),
// title: Text("TRIAGE"),
// backgroundColor: Colors.blue
// ),
// BottomNavigationBarItem(

// icon: Icon(Icons.hotel),
// title: Text("CHAT"),
// backgroundColor: Colors.blue
// )

// ],
// onTap: (index){
// setState(() {
// _currentIndex =index;
// });

// },
// ),
// );
// }
// }