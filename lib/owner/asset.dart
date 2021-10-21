import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/style.dart';
import "package:flutter/material.dart";
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final levelFutureProvider = FutureProvider<List>((ref) {
  return getStoreLevel();
});

Future<List> getStoreLevel() async {
  var store = [];
  final storeLevel = Hive.lazyBox("totalitem");

  var keys = storeLevel.keys.toList();
  for (var key in keys) {
    var item = await storeLevel.get(key);
    store.add(item);
  }
  return store;
}

// final selectedLevelFutureProvider = FutureProvider<List>((ref) {
//   var se = [];
//   ref.watch(levelFutureProvider).whenData((value) {
//     se = value;
//   });
//   // return se;
// });

class Asset extends ConsumerWidget {
  final setting = Hive.box("setting");
  final dataRow = <DataRow>[];
  final filltered = [];
  @override
  Widget build(BuildContext context, watch) {
    return Scaffold(
        appBar: AppBar(
          title: Text(setting.get("orgName")),
        ),
        // persistentFooterButtons: [
        //   OutlinedButton(
        //     child: Text("በሱቁ ውስጥ ያለው አጠቃላይ ሀብት በ ብር"),
        //     style: Style.outlinedButtonStyle,
        //     onPressed: () async {
        //       Utility.showTotalAssetinBirr(context);
        //     },
        //   )
        // ],
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Text(
                "በሱቁ ውስጥ ያለው አጠቃላይ ሀብት በ ብር ",
                style: Style.style1,
              ),
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.lightBlue,
          ),
          Center(child: Utility.showTotalAssetinBirr(context))
        ]));
  }
}
