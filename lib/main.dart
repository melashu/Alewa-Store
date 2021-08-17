import 'package:boticshop/Utility/Boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'owner/Home.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Boxes.getCatBox();
  await Boxes.getItemBox();
  await Boxes.getSetting();
  await Boxes.getTransactionBox();
  await Boxes.getTotalItem();
  await Boxes.getExpenesBox();

  // var result = await (Connectivity().checkConnectivity());

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Hive.box("setting").put("orgName", "IMount Plc");
    Hive.box("setting").put("mobSync", false);

    // print("Length=${Hive.box("setting").length}");
    // var orgList = Hive.box("setting").values.toList();
    // orgList.forEach((row) {
    //   // print(row + "\n");
    // });
    return MaterialApp(
        title: Hive.box("setting").get("orgName"),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          buttonColor: Colors.purple,
          buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.accent,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              )),
          primarySwatch: Colors.deepPurple,
        ),
        home: Home());
  }
}
