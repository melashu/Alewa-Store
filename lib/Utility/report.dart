import 'package:abushakir/abushakir.dart';
import 'package:boticshop/Utility/date.dart';
import 'package:hive/hive.dart';

class Report {
  static Future<List> getDailyTransaction() async {
    var transactionBox = Hive.lazyBox("transaction");
    var keyList = transactionBox.keys.toList();
    var itemLists = [];
    for (var key in keyList) {
      var items = await transactionBox.get(key);
      items['tID'] = key;
      if (Dates.today == items['salesDate']) {
        itemLists.add(items);
      }
    }

    return itemLists;
  }

  static Future<List> getWeeklyTransaction() async {
    var transactionBox = Hive.lazyBox("transaction");
    var keyList = transactionBox.keys.toList();
    var itemLists = [];
    for (var key in keyList) {
      var items = await transactionBox.get(key);
      // items['tID'] = key;
      if ((EtDatetime.parse(Dates.today)
              .difference(EtDatetime.parse(items['salesDate']))
              .inDays) <=
          7) {
        itemLists.add(items);
      }
    }

    return itemLists;
  }

    static Future<List> getMonthlyTransaction() async {
    var transactionBox = Hive.lazyBox("transaction");
    var keyList = transactionBox.keys.toList();
    var itemLists = [];
    for (var key in keyList) {
      var items = await transactionBox.get(key);
      // items['tID'] = key;
      if ((EtDatetime.parse(Dates.today)
              .difference(EtDatetime.parse(items['salesDate']))
              .inDays) <=
          30) {
        itemLists.add(items);
      }
    }

    return itemLists;
  }
  
}
