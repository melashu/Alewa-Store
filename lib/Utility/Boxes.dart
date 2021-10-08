import 'package:hive/hive.dart';

class Boxes {
  static Future<Box> getCatBox() async {
    var box = await Hive.openBox("categorie");
    return box;
  }

  static Future<Box> getSetting() async {
    var box = await Hive.openBox("setting");

    return box;
  }

  static Future<LazyBox> getTransactionBox() async {
    var box = await Hive.openLazyBox("transaction");
    return box;
  }

  static Future<Box> getItemBox() async {
    var box = await Hive.openBox("item");
    return box;
  }

  static Future<LazyBox> getTotalItem() async {
    var box = await Hive.openLazyBox("totalitem");
    return box;
  }

  static Future<Box> getExpenesBox() async {
    var box = await Hive.openBox("expenes");
    return box;
  }

  static Future<Box> getUserAccount() async {
    var box = await Hive.openBox("useraccount");
    return box;
  }

  static Future<Box> getOrgProfileBox() async {
    var box = await Hive.openBox("orgprofile");
    return box;
  }

  static Future<LazyBox> getMessageBox() async {
    var box = await Hive.openLazyBox("orgprofile");
    return box;
  }

  static Future<Box> getLocationBox() async {
    var box = await Hive.openBox("location");
    return box;
  }

  // static Future<List<Map>> getItemValue() async {
  //   var values = <Map>[];
  //   var box = await getItemBox();
  //   var keys = box.keys.toList();
  //   keys.forEach((key) async {
  //     var val = await box.get(key);
  //     values.add(val);
  //   });
  //   return values;
  // }
}
