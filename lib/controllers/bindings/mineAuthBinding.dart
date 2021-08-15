import 'package:connectcraft/controllers/mineAuthController.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class MineAuthBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<MineAuthController>(() => MineAuthController());
    Get.lazyPut(() => Dio());
    Get.lazyPut(() => FlutterSecureStorage());
  }

}