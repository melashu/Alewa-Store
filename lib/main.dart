import 'package:boticshop/Utility/Boxes.dart';
import 'package:boticshop/Utility/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Boxes.getCatBox();
  await Boxes.getItemBox();
  await Boxes.getSetting();
  await Boxes.getTransactionBox();
  await Boxes.getTotalItem();
  await Boxes.getExpenesBox();
  await Boxes.getUserAccount();
  await Boxes.getLocationBox();
  await Boxes.getMessageBox();
  await Boxes.getDebtBox();
  await Boxes.getPaymentBox();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Hive.box("setting").get("orgName") == null
        ? Hive.box("setting").put("orgName", "Alewa-Botic")
        : Hive.box("setting")
            .put("orgName", Hive.box("setting").get("orgName"));
    Hive.box('setting').get('mobSync') == null
        ? Hive.box("setting").put("mobSync", false)
        : Hive.box("setting")
            .put("mobSync", Hive.box('setting').get('mobSync'));
    Hive.box('setting').get('wifiSync') == null
        ? Hive.box("setting").put("wifiSync", false)
        : Hive.box("setting")
            .put("wifiSync", Hive.box('setting').get('wifiSync'));

    // print("Length=${Hive.box("setting").length}");
    // var orgList = Hive.box("setting").values.toList();
    // orgList.forEach((row) {
    //   // print(row + "\n");
    // });
    return MaterialApp(
        title: Hive.box("setting").get("orgName"),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.accent,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              )),
          primarySwatch: Colors.deepPurple,
        ),
        home: AnimatedSplashScreen(
          nextScreen: AnimatedSplashScreen(
              splashTransition: SplashTransition.fadeTransition,
              animationDuration: Duration(seconds: 2),
              splash: Container(
                width: double.infinity,
                height: double.infinity,
                child: const Center(
                    child: Text(
                  'ለተሻለ የቡቲክ ሱቅ አስተዳድር',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent),
                )),
                color: Colors.white,
              ),
              backgroundColor: Colors.redAccent,
              nextScreen: AnimatedSplashScreen(
                backgroundColor: Colors.redAccent,
                animationDuration: Duration(seconds: 2),
                splashTransition: SplashTransition.fadeTransition,

                nextScreen: Login(),
                splash: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: const Center(
                      child: Text(
                    'Alewa-Botic',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
                  )),
                  color: Colors.white,
                ),
                // const Center(child: Text('Alewa-Mobile')

                // ),
              )),
          splash: Container(
            width: double.infinity,
            height: double.infinity,
            child: const Center(
                child: Text(
              'እንኳን ደህና መጡ',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent),
            )),
            color: Colors.white,
          ),
          animationDuration: const Duration(seconds: 2),
          backgroundColor: Colors.redAccent,
          splashTransition: SplashTransition.fadeTransition,
        ));
  }
}
