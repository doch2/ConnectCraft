import 'package:connectcraft/controllers/mineAuthController.dart';
import 'package:connectcraft/screens/mineAccountLogin.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class Home extends GetWidget<MineAuthController> {
  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    controller.callReadStoragePermission();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("ConnectCraft"),
            SizedBox(
              height: _height * 0.2,
            ),
            GestureDetector(
              onTap: () => Get.to(MineAccountLogin()),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    color: Color(0xff000000)
                ),
                child: Text(
                  "Mojang Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}