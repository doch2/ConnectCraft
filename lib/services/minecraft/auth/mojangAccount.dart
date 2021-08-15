import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide Response;

class MojangAccount {
  final Dio _dio = Get.find<Dio>();
  Map<String, dynamic>? apiResponse;
  final FlutterSecureStorage _storage = Get.find<FlutterSecureStorage>();

  Future<bool> getAccountInfo(String accountName, String accountPassword) async {
    String mojangAuthServerPath = "https://authserver.mojang.com/authenticate";

    try {
      Response response = await _dio.post(
          mojangAuthServerPath,
          data: { "username": accountName, "password": accountPassword }
      );

      if (response.statusCode == 200) {
        apiResponse = response.data;
        return true;
      } else {
        return false;
      }
    } catch(e) {
      Exception(e);
    }

    return false;
  }

  void saveAccountInfo(String clientToken, String accessToken) async {
    await _storage.write(key: "clientToken", value: clientToken);
    await _storage.write(key: "accessToken", value: accessToken);
  }
}