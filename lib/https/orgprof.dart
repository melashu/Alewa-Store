import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class OrgProfHttp {
  var client = http.Client();
  Future<String> insertOrgProf(Map orgMap) async {
    orgMap['action'] = 'insertorg';
    var url = Uri.parse("https://keteraraw.com/ourbotic/index.php");
    var response = await client.post(url, body: orgMap);
    return response.body;
  }

  Future<void> getSubStatus(String orgId) async {
    var url = Uri.parse("https://keteraraw.com/ourbotic/index.php");
    var response =
        await client.post(url, body: {"action": 'getsub', "orgId": orgId});
    if (response.body != 'notOk') {
      var info = jsonDecode(response.body) as List;
      var subInfo = info[0];
      subInfo['freeDay'] = int.parse(subInfo['freeDay']);
      subInfo['exteraDay'] = int.parse(subInfo['exteraDay']);
      subInfo["isExtended"] = false;
      var status = subInfo['subStatus'] == '0' ? false : true;
      Hive.box("setting").put("isSubscribed", status);
      Hive.box("setting").put("subInfo", subInfo);
    }
  }

  Future<void> updateLocation(String orgId) async {
    var url = Uri.parse("https://keteraraw.com/ourbotic/index.php");
    var loc = Hive.box("location").get("location");
    if (loc != null) {
      var response = await client.post(url, body: loc);
      
    }
  }

  Future<String> checkVersion() async {
    var url = Uri.parse("https://keteraraw.com/ourbotic/index.php");
    var response = await client.post(url, body: {'action': "versionUpdate"});
    return response.body;
  }

  static void showVersionUpdate(
      String message, String title, String link, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(message),
            title: Text(title),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("አልፈልግም")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Update Now")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Update Later")),
            ],
          );
        });
  }

  Future<Map> getAgreement() async {
    var url = Uri.parse("https://keteraraw.com/ourbotic/index.php");
    var response = await client.post(url, body: {'action': "agreement"});
    var mapResult = {};
    if (response.body != 'notOk') {
      var result = jsonDecode(response.body) as List;
      mapResult = result[0];
    }
    return mapResult;
  }

  Future<bool> inserPaymentInfo(String orgId, String date) async {
    var url = Uri.parse("https://keteraraw.com/ourbotic/index.php");
    var response = await client.post(url,
        body: {'action': "paymentInfo", 'orgId': orgId, 'date': date});
    var result = false;
    if (response.body == 'ok') {
      result = true;
    }
    return result;
  }

  Future<String> insertUserAccount(Map users) async {
    var url = Uri.parse("https://keteraraw.com/ourbotic/index.php");
    var response = await client.post(url, body: users);
    return response.body;
  }

  Future<void> getOrgBlockStatus(String orgId) async {
    var url = Uri.parse("https://keteraraw.com/ourbotic/index.php");
    var response =
        await client.post(url, body: {'orgId': orgId, "action": "orgblock"});
    var result = jsonDecode(response.body) as List;
    var status = result[0]['isActive'] as String;
    print("status=$status");
    Hive.box('setting').put('isActive', status);
  }
}
