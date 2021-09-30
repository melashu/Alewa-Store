import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/report.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:boticshop/https/Item.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Storage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StorageState();
  }
}

class _StorageState extends State<Storage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            Hive.box("setting").get("orgName"),
            style: Style.style1,
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Storage();
            }));
            return Future.value(true);
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              children: [
                Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text("Item Box",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple)),
                      Divider(
                        color: Colors.redAccent,
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "Save  መደረግ የሚፈልግ የእቃ ብዛት = ${SyncItem().itemSyncStatus("insertStatus", 'no')} ",
                            style: Style.style1),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "Delete መደረግ የሚፈልግ የእቃ ብዛት = ${SyncItem().itemSyncStatus("deleteStatus", 'yes')} ",
                            style: Style.style1),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "Update መደረግ የሚፈልግ የእቃ ብዛት = ${SyncItem().itemSyncStatus("updateStatus", 'yes')} ",
                            style: Style.style1),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          onPressed: () async {
                            ConnectivityResult connectivityResult =
                                await Connectivity().checkConnectivity();
                            if (connectivityResult != ConnectivityResult.none) {
                              SyncItem().syncInsertItemList(context);
                              SyncItem().syncUpdateItem(context);
                              SyncItem().syncDeleteItem(context);
                              Utility.successMessage(
                                  context, "ዳታዎት በትክክል ሴብ ተደርጎል፡፡");
                              MaterialPageRoute(builder: (context) {
                                return Storage();
                              });
                            } else {
                              Utility.infoMessage(context,
                                  "ዳታዎትን ሴብ ሲያደርጉ wifi or Data ያስፈልገዉታል፡፡");
                            }
                          },
                          child: Text("Sync"),
                          style: Style.outlinedButtonStyle,
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () async {
                          ConnectivityResult connectivityResult =
                              await Connectivity().checkConnectivity();
                          if (connectivityResult != ConnectivityResult.none) {
                            var result = await SyncItem().syncSelect(context);
                            if (result >= 1) {
                              Utility.successMessage(context,
                                  'በትክክል $result እቃዎችን ስልክዎት ላይ አስቀምጠዋል፡፡ ');
                            } else {
                              DangerAlertBoxCenter(
                                  context: context,
                                  buttonColor: Colors.deepPurpleAccent,
                                  buttonText: 'Ok',
                                  messageText: 'ሁሉም እቃ ስልክዎት ላይ ነው ያለው፡፡');
                            }
                          } else {
                            Utility.infoMessage(context,
                                "ዳታዎትን ሴብ ሲያደርጉ wifi or Data ያስፈልገዉታል፡፡");
                          }
                        },
                        child: Text("Refresh Local Storage"),
                        style: Style.outlinedButtonStyle,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          onPressed: () async {
                            ConfirmAlertBox(
                                context: context,
                                title: 'Message',
                                infoMessage: 'ስልክዎት ላይ የተመዘገበዎን እቃ ማጥፋት ይፈልጋሉ?',
                                buttonColorForNo: Colors.deepPurple,
                                buttonColorForYes: Colors.deepPurpleAccent,
                                onPressedYes: () async {
                                  var result =
                                      await SyncItem().cleanBox(context);
                                  if (result == 0) {
                                    Hive.box('item').clear();
                                    Utility.successMessage(context,
                                        "በትክክል ስልክዎ ላይ ያለውን ዳታ አጥፍተዎል፡፡");
                                  } else {
                                    WarningAlertBoxCenter(
                                      messageText:
                                          'ሲብ ያልተደረገ $result እቃ አለ እባክዎት ከላይ ያለውን Sync የሚለዎን ይጫኑ፡፡',
                                      buttonText: 'Ok',
                                      context: context,
                                    );
                                  }
                                },
                                onPressedNo: () {
                                  Navigator.of(context).pop();
                                  // Navigator.of(context).pop();
                                });
                          },
                          child: Text("Clean Local Storage"),
                          style: Style.outlinedButtonStyle,
                        ),
                      )
                    ],
                  ),
                  // height: 200,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.redAccent, width: 1)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text("Trasaction Box",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple)),
                        Divider(
                          color: Colors.redAccent,
                          thickness: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlinedButton(
                            onPressed: () async {
                              var listT = await Report.getTransaction();
                              print(listT);
                            },
                            child: Text("Sync"),
                            style: Style.outlinedButtonStyle,
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          child: Text("Clean Local Storage"),
                          style: Style.outlinedButtonStyle,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlinedButton(
                            onPressed: () {},
                            child: Text("Refresh Local Storage"),
                            style: Style.outlinedButtonStyle,
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.redAccent, width: 1)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text("Levle Box",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple)),
                        Divider(
                          color: Colors.redAccent,
                          thickness: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlinedButton(
                            onPressed: () {
                              MaterialPageRoute(builder: (context) {
                                return Storage();
                              });
                            },
                            child: Text("Clean Local Storage"),
                            style: Style.outlinedButtonStyle,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlinedButton(
                            onPressed: () {},
                            child: Text("Referesh Local Storage"),
                            style: Style.outlinedButtonStyle,
                          ),
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.redAccent, width: 1)),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
