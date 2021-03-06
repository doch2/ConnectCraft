import 'package:connectcraft/controllers/mineAuthController.dart';
import 'package:connectcraft/themes/text_theme.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class MineAccountLogin extends GetWidget<MineAuthController> {
  MineAccountLogin({Key? key}) : super(key: key);

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    controller.initMicrosoftAuth(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Mojang Account\nLogin",
              style: title,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: _height * 0.1,
            ),
            SizedBox(
              width: _width * 0.8,
              child: TextField(
                  controller: userNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'UserName',
                  )
              ),
            ),
            SizedBox(
              height: _height * 0.05,
            ),
            SizedBox(
              width: _width * 0.8,
              child: TextField(
                  controller: userPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  )
              ),
            ),
            GestureDetector(
                onTap: () => controller.mojangAccountLogin(userNameController.text, userPasswordController.text),
                child: Container(
                    margin: EdgeInsets.only(right: 40, top: 30),
                    width: _width * 0.25,
                    height: _height * 0.1,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color(0xffD99FF6),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xffE4CBFF),
                              blurRadius: 10,
                              spreadRadius: 3)
                        ]),
                    child: Center(
                      child: Text(
                        "?????????",
                        style: test1,
                      ),
                    )
                )
            ),
            GestureDetector(
              onTap: () { controller.microsoftAccountLogin(); },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    color: Color(0xff000000)
                ),
                child: Text(
                  "Microsoft Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: _height * 0.15,
            ),
          ],
        ),
      ),
    );
  }
}