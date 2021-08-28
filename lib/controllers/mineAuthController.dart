import 'package:connectcraft/services/minecraft/auth/microsoftAccount.dart';
import 'package:connectcraft/services/minecraft/auth/mojangAccount.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MineAuthController extends GetxController {
  MojangAccount mojangAccount = MojangAccount();
  MicrosoftAccount microsoftAccount = MicrosoftAccount();

  
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

  void initMicrosoftAuth(BuildContext context) async {
    microsoftAccount.initMicrosoftAuth(context);
  }

  void microsoftAccountLogin() async {
    await microsoftAccount.webLogin();
    bool xblLoginResult = await microsoftAccount.xblAuth();
    if (xblLoginResult) {
      String xstsLoginResult = await microsoftAccount.xstsAuth();
      if (xstsLoginResult == "success") {
        await microsoftAccount.minecraftAuth();
      } else if (xstsLoginResult == "2148916233") {
        print("xbox 프로필이 없으므로 불가능");
      } else if (xstsLoginResult == "2148916238") {
        print("어린이 계정으로 불가능");
      }
    } else {
      print("안됨 ㅌㅌ");
    }
  }

  void microsoftAccountLogout() {
    microsoftAccount.logout();
  }

  void callReadStoragePermission() async {
    await Permission.storage.request();
  }
}