
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:print_currency/screen/home.dart';
import 'package:print_currency/screen/print.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';



// import 'package:api_curr/screen/curr_form.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency API Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/' : (context) => MyHomePage(),
        //'/print' : (context) => printApp(),
        // '/view' : (context) => viewPage (),
      },
      initialRoute: '/',
    );
  }
}
