import 'package:connectcraft/services/minecraft/auth/mojangAccount.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MineAuthController extends GetxController {
  MojangAccount mojangAccount = MojangAccount();
  
  void mojangAccountLogin(String userName, String userPassword) async {
    bool responseResult = await mojangAccount.getAccountInfo(userName, userPassword);
    Map<String, dynamic>? apiResponse = mojangAccount.apiResponse;

    if (responseResult) {
      mojangAccount.saveAccountInfo(apiResponse!["clientToken"], apiResponse["accessToken"]);
      print("login successful");
      Fluttertoast.showToast(
          msg: "Login Successful.",
          textColor: Colors.black,
          backgroundColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM
      );
      Get.back();
    } else {
      print("login fail");
      Fluttertoast.showToast(
          msg: "Login Fail.",
        textColor: Colors.black,
        backgroundColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM
      );
    }
  }

  void callReadStoragePermission() async {
    await Permission.storage.request();
  }
}