import 'package:connectcraft/controllers/bindings/mineAuthBinding.dart';
import 'package:connectcraft/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: MineAuthBinding(),
      home: Home(),
    );
  }
}