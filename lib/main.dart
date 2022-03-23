// ignore_for_file: use_key_in_widget_constructors, prefer_final_fields, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_googlemap/map_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapSample(),
    );
  }
}
