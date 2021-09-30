import 'dart:convert';

import 'package:boticshop/Utility/Utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class SyncItem {
  static var client = http.Client();
  var itemBox = Hive.box('item');

  void syncInsertItemList(BuildContext context) async {
    var url = Uri.parse("https://keteraraw.com/ourbotic/index.php");

    var selectedList = [];
    var itemList = itemBox.values.toList();
    itemList.forEach((item) {
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
    if (selectedList.length > 0) {
      var response = await client.post(url,
          body: {"data": json.encode(selectedList), "action": "asyncinsert"});
      // print("Data => " + response.body);
      if (response.body == "ok") {
        // print("Done");
        selectedList.forEach((select) async {
          var itemID = select['itemID'];
          select['insertStatus'] = "yes";
          await itemBox.put(itemID, select);
        });
      } else {
        Utility.showSnakBar(context, response.body, Colors.redAccent);
      }
    } else {
      // print("Nothing to sync");
    }
  }

  void syncUpdateItem(BuildContext context) async {
    var url = Uri.parse("https://keteraraw.com/ourbotic/item_update.php");
    var selectedList = [];
    var itemList = itemBox.values.toList();
    itemList.forEach((item) {
      if ((item['insertStatus'] == 'yes') && (item['updateStatus'] == 'yes')) {
        selectedList.add(item);
      }
    });
    if (selectedList.length > 0) {
      var response = await client.post(url,
          body: {"data": json.encode(selectedList), "action": "asyncupdate"});
      if (response.body == "ok") {
        selectedList.forEach((select) {
          var itemID = select['itemID'];
          select['updateStatus'] = "no";
          itemBox.put(itemID, select);
        });
      } else {
        Utility.showSnakBar(context, response.body, Colors.redAccent);
      }
    }
  }

  void syncDeleteItem(BuildContext context) async {
    var url = Uri.parse("https://keteraraw.com/ourbotic/item_delete.php");

    var selectedList = [];
    var itemList = itemBox.values.toList();
    itemList.forEach((item) async {
      if ((item['insertStatus'] == 'no') && (item['deleteStatus'] == 'yes')) {
        var itemID = item['itemID'];
        await itemBox.delete(itemID);
      } else if ((item['insertStatus'] == 'yes') &&
          (item['deleteStatus'] == 'yes')) {
        selectedList.add(item['itemID']);
      }
    });

    if (selectedList.length > 0) {
      var response = await client.post(url,
          body: {"data": json.encode(selectedList), "action": "syncdelete"});
      if (response.body == "ok") {
        selectedList.forEach((itemID) {
          print("Deleted <==>" + itemID);

          itemBox.delete(itemID);
        });
      } else {
        Utility.showSnakBar(context, response.body, Colors.redAccent);
      }
    }
  }

  static Future<void> getTotalItem() async {
    var totalItemBox = Hive.lazyBox("totalitem");
    var url = Uri.parse("https://keteraraw.com/ourbotic/index.php");
    var response = await client.post(url, body: {"action": "GET_ITEM_LEVLE"});
    List itemLevel = json.decode(response.body) as List;
    // print(itemLevel);
    itemLevel.forEach((item) async {
      await totalItemBox.put(item['itemID'], item);
    });
    // print("Length=${totalItemBox.length}");
  }

  int itemSyncStatus(String status, String result) {
    int count = 0;
    var itemList = itemBox.values.toList();
    for (var item in itemList) {
      if (item[status] == result) {
        count = count + 1;
      }
    }
    return count;
  }

  Future<int> syncSelect(BuildContext context) async {
    var url = Uri.parse("https://keteraraw.com/ourbotic/index.php");
    var response = await client.post(url, body: {
      "action": "update_item",
      'orgId': Hive.box('setting').get("orgId")
    });
    // print(response.body);
    var val = 0;
    if (response.body == 'notOk') {
      val = -1;
    } else {
      var itemList = jsonDecode(response.body) as List;
      for (Map item in itemList) {
        String itemCode = item['itemID'];
        if (!itemBox.containsKey(itemCode)) {
          val = val + 1;
          // item[]
          // item['insertStatus'] = 'no';
          // item['updateStatus'] = 'no';
          item['deleteStatus'] = 'no';
          itemBox.put(itemCode, item);

          // print(itemBox.get(itemCode));
        }
      }
    }
    // itemBox.put("Item_$itemID", itemMap);
    return val;
  }

  Future<int> cleanBox(BuildContext context) async {
    var itemLists = itemBox.values.toList();
    int val = 0;
    for (var item in itemLists) {
      if ((item['insertStatus'] == 'no') ||
          (item['updateStatus'] == 'yes') ||
          (item['deleteStatus'] == 'yes')) {
        val = val + 1;
      }
    }
    return val;
  }
}
