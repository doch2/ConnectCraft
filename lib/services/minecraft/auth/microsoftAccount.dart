import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aad_oauth/flutter_aad_oauth.dart';
import 'package:flutter_aad_oauth/model/config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide Response;

class MicrosoftAccount {
  final Dio _dio = Get.find<Dio>();

  static const String TENANT_ID = "5bd56412-c6a0-4b29-b35d-373bea7976b6";
  static const String CLIENT_ID = "0ca0c3aa-4c60-4fe1-a904-e4f5a0c314ca";
  late Config config;
  late FlutterAadOauth oauth = FlutterAadOauth(config);

  String? microsoftAccessToken;
  String? xblAccessToken;
  String? xblUserHash;
  String? xstsAccessToken;
  String? xstsUserHash;
  String? realAccessToken;

  initMicrosoftAuth(BuildContext context) async {
    var redirectUri;
    late String scope;
    late String responseType;

    scope = "openid profile offline_access";
    responseType = "code";
    redirectUri = "https://login.live.com/oauth20_desktop.srf";

    config = new Config(
        azureTennantId: TENANT_ID,
        clientId: CLIENT_ID,
        scope: scope,
        redirectUri: "$redirectUri",
        responseType: responseType);

    oauth = FlutterAadOauth(config);
    oauth.setContext(context);
    checkIsLogged();
  }

  void checkIsLogged() async {
    if (await oauth.tokenIsValid()) {
      String? accessToken = await oauth.getAccessToken();
      Fluttertoast.showToast(
          msg: "Access token: ",
          textColor: Colors.black,
          backgroundColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM
      );
    }
  }



  webLogin() async {
    try {
      await oauth.login();
      String? accessToken = await oauth.getAccessToken();
      microsoftAccessToken = accessToken;
      Fluttertoast.showToast(
          msg: "Logged in successfully, your access token: $accessToken",
          textColor: Colors.black,
          backgroundColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM
      );
    } catch (e) {
    }
  }

  Future<bool> xblAuth() async {
    String xboxAuthServerPath = "https://user.auth.xboxlive.com/user/authenticate";

    try {
      print("ssssd");
      print("d=$microsoftAccessToken");
      Map<String, dynamic> params = {
        "Properties": {
          "AuthMethod": "RPS",
          "SiteName": "user.auth.xboxlive.com",
          "RpsTicket": "d=$microsoftAccessToken" // your access token from step 2 here
        },
        "RelyingParty": "http://auth.xboxlive.com",
        "TokenType": "JWT"
      };

      Response response = await _dio.post(
          xboxAuthServerPath,
          options: Options(
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
            headers: { HttpHeaders.acceptHeader: 'application/json', HttpHeaders.contentTypeHeader: "application/json" }
          ),
          data: jsonEncode(params),
      );

      print(response.data);
      print(response.statusCode);
      if (response.statusCode == 200) {
        xblAccessToken = response.data["Token"];
        xblUserHash = response.data["DisplayClaims"]["xui"][0]["uhs"];
        return true;
      } else {
        return false;
      }
    } catch(e) {
      Exception(e);
      print(e);
    }

    return false;
  }

  Future<String> xstsAuth() async {
    String xboxAuthServerPath = "https://xsts.auth.xboxlive.com/xsts/authorize";

    try {
      Response response = await _dio.post(
          xboxAuthServerPath,
          data: {
            "Properties": {
              "SandboxId": "RETAIL",
              "UserTokens": [
                xblAccessToken,
              ],
            },
            "RelyingParty": "rp://api.minecraftservices.com/",
            "TokenType": "JWT"
          }
      );

      if (response.statusCode == 200) {
        xstsAccessToken = response.data["Token"];
        xstsUserHash = response.data["DisplayClaims"]["xui"][0]["uhs"];
        return "success";
      } else {
        return response.data["XErr"];
      }
    } catch(e) {
      Exception(e);
    }

    return "fail";
  }

  Future<bool> minecraftAuth() async {
    String xboxAuthServerPath = "https://api.minecraftservices.com/authentication/login_with_xbox";

    try {
      Response response = await _dio.post(
          xboxAuthServerPath,
          data: {
            "identityToken": "XBL3.0 x=${xstsUserHash};${xstsAccessToken}",
          }
      );

      if (response.statusCode == 200) {
        realAccessToken = response.data["access_token"];
        return true;
      } else {
        return false;
      }
    } catch(e) {
      Exception(e);
    }

    return false;
  }

  void logout() async {
    await oauth.logout();
    Fluttertoast.showToast(
        msg: "Logged out",
        textColor: Colors.black,
        backgroundColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM
    );
  }
}