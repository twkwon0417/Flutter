import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'FlutterNotification.dart';
import 'MainPage.dart';
import 'Map_Page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  final List<Widget> _children = [MtWidget(), MapPage()];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.add),
        //   onPressed: (){print("hi");},
        // ),
          appBar: AppBar(
            title: Text("위치기반 알람"),
          ),
          body: _children[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              onTap: _onTap,
              currentIndex: _currentIndex,
              items: const[
                BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label :"How to use"
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.map),
                    label: 'Map'
                ),
              ])),
    );
  }

}
