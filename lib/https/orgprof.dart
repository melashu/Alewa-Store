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
    // print("response.body " + response.body);
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
  //nat
  Future<void> updateLocation(String orgId) async {
    var url = Uri.parse("https://keteraraw.com/ourbotic/index.php");
    var loc = Hive.box("location").get("location");
    if (loc != null) {
      var response = await client.post(url, body: loc);
      print("response.body====="+response.body);
      if(response.body=='ok'){
            Hive.box('setting').put("isWorkingLoc", true);
        
      }
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

  Future<bool> inserPaymentInfo(
      String orgId, String date, String amount, String monthID) async {
    var url = Uri.parse("https://keteraraw.com/ourbotic/index.php");
    var response = await client.post(url, body: {
      'action': "paymentInfo",
      'orgId': orgId,
      'date': date,
      'amount': amount,
      'monthID': monthID
    });
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
    Hive.box('setting').put('isActive', status);
    // print("Newtoekr is");
  }

  Future<bool> request4PaymentConfirmation(String orgId, String monthID) async {
    var url = Uri.parse("https://keteraraw.com/ourbotic/index.php");
    var response = await client.post(url, body: {
      "orgId": orgId,
      "monthID": monthID,
      "action": "payment_request"
    });
    bool val;
    if (response.body == 'ok') {
      val = true;
    } else {
      val = false;
    }
    return val;
  }

  Future<String> isConfirmation(String orgId, String monthID) async {
    var url = Uri.parse("https://keteraraw.com/ourbotic/index.php");
    var response = await client.post(url,
        body: {"orgId": orgId, "monthID": monthID, "action": "isConfirmed"});
    String val;
    // var paymentBox = Hive.box('payment');
    if (response.body != 'notOk') {
      var result = jsonDecode(response.body) as List;
      val = result[0]['renewStatus'];
      print(val);
      // paymentBox.put('month', {
      //   "date": Dates.today,
      //   "isRequest": false,
      //   "paidStatus": 'no',
      //   "monthID": monthID,
      //   "renewStatus": 'no',
      //   // "amount": amount
      // });
    }
    return val;
  }

  Future<List> getServiceCharge() async {
    var url = Uri.parse("https://keteraraw.com/ourbotic/index.php");
    var response = await client.post(url, body: {
      'action': "serviceCharge",
      'orgId': Hive.box('setting').get('orgId')
    });
    var mapResult = [];
    if (response.body != 'notOk') {
      var result = jsonDecode(response.body) as List;
      mapResult = result;
    }
    return mapResult;
  }

  Future<List> getPaymentHistory() async {
    var url = Uri.parse("https://keteraraw.com/ourbotic/index.php");
    var response = await client.post(url, body: {
      'action': "paymentHistory",
      'orgId': Hive.box('setting').get('orgId')
    });
    var mapResult = [];
    if (response.body != 'notOk') {
      var result = jsonDecode(response.body) as List;
      mapResult = result;
    }
    return mapResult;
  }
}
