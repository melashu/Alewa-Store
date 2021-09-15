
import 'package:boticshop/Utility/style.dart';
import 'package:boticshop/sync/Item.dart';
import 'package:flutter/material.dart';
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
                            "${SyncItem().itemSyncStatus("insertStatus", 'no')} item Looking for inseration synchronization",
                            style: Style.style1),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "${SyncItem().itemSyncStatus("deleteStatus", 'yes')} item looking for deletion synchronization",
                            style: Style.style1),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "${SyncItem().itemSyncStatus("updateStatus", 'yes')} item looking for updation synchronization",
                            style: Style.style1),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          onPressed: () {
                            SyncItem().syncInsertItemList(context);
                            SyncItem().syncUpdateItem(context);
                            SyncItem().syncDeleteItem(context);
                            MaterialPageRoute(builder: (context) {
                              return Storage();
                            });
                          },
                          child: Text("Sync"),
                          style: Style.outlinedButtonStyle,
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          SyncItem().syncSelect(context);
                        },
                        child: Text("Refresh Local Storage"),
                        style: Style.outlinedButtonStyle,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          onPressed: () {},
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
                            onPressed: () {
                           
                              MaterialPageRoute(builder: (context) {
                                return Storage();
                              });
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
                            onPressed: () {
                            },
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
