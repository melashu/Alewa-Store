import 'package:abushakir/abushakir.dart';
import 'package:boticshop/Utility/date.dart';
import 'package:hive/hive.dart';

class Report {
  static Future<List> getDailyTransaction({String userName}) async {
    var transactionBox = Hive.lazyBox("transaction");
    var keyList = transactionBox.keys.toList();
    var itemLists = [];
    for (var key in keyList) {
      var items = await transactionBox.get(key);
      items['tID'] = key;
      if (Dates.today == items['salesDate'] && userName == null) {
        itemLists.add(items);
      } else if (Dates.today == items['salesDate'] &&
          userName == items['salesPerson']) {
        itemLists.add(items);
      }
    }

    return itemLists;
  }

  static Future<List> getWeeklyTransaction({String userName}) async {
    var transactionBox = Hive.lazyBox("transaction");
    var keyList = transactionBox.keys.toList();
    var itemLists = [];
    for (var key in keyList) {
      var items = await transactionBox.get(key);
      // items['tID'] = key;
      if (((EtDatetime.parse(Dates.today)
                  .difference(EtDatetime.parse(items['salesDate']))
                  .inDays) <=
              7) &&
          userName == null) {
        itemLists.add(items);
      } else if (((EtDatetime.parse(Dates.today)
                  .difference(EtDatetime.parse(items['salesDate']))
                  .inDays) <=
              7) &&
          userName == items['salesPerson']) {
        itemLists.add(items);
      }
    }

    return itemLists;
  }

  static Future<List> getMonthlyTransaction({String userName}) async {
    var transactionBox = Hive.lazyBox("transaction");
    var keyList = transactionBox.keys.toList();
    var itemLists = [];
    for (var key in keyList) {
      var items = await transactionBox.get(key);
      // items['tID'] = key;
      if ((EtDatetime.parse(Dates.today)
              .difference(EtDatetime.parse(items['salesDate']))
              .inDays) <=
          30 && userName==null) {
        itemLists.add(items);
      } else if (((EtDatetime.parse(Dates.today)
                  .difference(EtDatetime.parse(items['salesDate']))
                  .inDays) <=
              30) &&
          userName == items['salesPerson']) {
        itemLists.add(items);
      }
    }

    return itemLists;
  }

  static double getDailyExpenessPerMonth() {
    var expenessBox = Hive.box("expenes");
    var valList = expenessBox.values;
    var totalExpeness = 0.0;

    for (var val in valList) {
      // var items =  expenessBox.get(key);
      if (val['payementType'] == 'ወርሃዊ') {
        totalExpeness = totalExpeness + double.parse(val['paidAmount']);
      }
    }
    return totalExpeness;
  }

  static double getDailyExpenes() {
    var expenessBox = Hive.box("expenes");
    var valList = expenessBox.values;
    var totalDailyExpeness = 0.0;

    for (var val in valList) {
      if ((Dates.today == val['date']) &&
          (val['payementType'] == 'ዕለታዊ') &&
          (val['deleteStatus'] == 'no')) {
        totalDailyExpeness =
            totalDailyExpeness + double.parse(val['paidAmount']);
      }
    }
    return totalDailyExpeness;
  }

  static double getMonthlyExpenes() {
    var expenessBox = Hive.box("expenes");
    var valList = expenessBox.values;
    var totalExpeness = 0.0;
    for (var val in valList) {
      if (((EtDatetime.parse(Dates.today)
                  .difference(EtDatetime.parse(val['date']))
                  .inDays) <=
              30) &&
          (val['payementType'] == 'ዕለታዊ') &&
          (val['deleteStatus'] == 'no')) {
        totalExpeness = totalExpeness + double.parse(val['paidAmount']);
      }
    }
    return totalExpeness;
  }

  static double getWeeklyExpenes() {
    var expenessBox = Hive.box("expenes");
    var valList = expenessBox.values;
    var totalExpeness = 0.0;
    for (var val in valList) {
      if (((EtDatetime.parse(Dates.today)
                  .difference(EtDatetime.parse(val['date']))
                  .inDays) <=
              7) &&
          (val['payementType'] == 'ዕለታዊ') &&
          (val['deleteStatus'] == 'no')) {
        totalExpeness = totalExpeness + double.parse(val['paidAmount']);
      }
    }
    return totalExpeness;
  }
}
