import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class Debt {
  static var client = http.Client();
  var debtBox = Hive.box('debt');
  Future<bool> syncInsertItemList() async {
    var url = Uri.parse("https://keteraraw.com/ourbotic/index.php");
    var selectedList = [];
    var itemList = debtBox.values.toList();
    bool isDone = false;
    itemList.forEach((item) {
      // print(item);
      if ((item['insertStatus'] == 'no') &&
          (item['updateStatus'] == 'no') &&
          (item['deleteStatus'] == 'no')) {
        selectedList.add(item);
      } else if ((item['insertStatus'] == 'no') &&
          (item['updateStatus'] == 'yes')) {
        item['updateStatus'] = 'no';
        selectedList.add(item);
      }
    });
    // print("Length== ${itemList.length}");
    if (selectedList.length > 0) {
      var response = await client.post(url,
          body: {"data": json.encode(selectedList), "action": "ADD_DEBT"});
      if (response.body == "ok") {
        isDone = true;
        selectedList.forEach((select) async {
          var debtID = select['debtID'];
          select['insertStatus'] = "yes";
          await debtBox.put(debtID, select);
        });
      }
    }
    return isDone;
  }

  Future<bool> syncUpdateItem() async {
    var url = Uri.parse("https://keteraraw.com/ourbotic/index.php");
    var selectedList = [];
    var itemList = debtBox.values.toList();
    bool isDone = false;
    itemList.forEach((item) {
      if ((item['insertStatus'] == 'yes') && (item['updateStatus'] == 'yes')) {
        selectedList.add(item);
      }
    });
    if (selectedList.length > 0) {
      var response = await client.post(url, body: {
        "data": json.encode(selectedList),
        "action": "EDIT_DEBT",
        // 'orgId': Hive.box('setting').get('orgId')
      });
      if (response.body == "ok") {
        isDone=true;
        selectedList.forEach((select) {
          var debtID = select['debtID'];
          select['updateStatus'] = "no";
          debtBox.put(debtID, select);
        });
      }
    }
    return isDone;
  }
}
