import 'dart:convert';

import 'package:boticshop/Utility/location.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

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

  Future checkVersion(String orgId) async {
    var url = Uri.parse("https://keteraraw.com/ourbotic/index.php");
    var response = await client.post(url, body: {'action': "versionUpdate"});
    return response.body;
  }
}
