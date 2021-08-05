import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  var message = ".Data Off ነው. ሞባይል ዳታወትን ኦን እስከሚያደርጉ ዳታው ከስልክው ላይ የቀመጣል";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Hive.box("setting").get("orgName")),
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Icon(Icons.settings),
              )
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            ListTile(
              horizontalTitleGap: 5,
              contentPadding: EdgeInsets.all(1),
              subtitle: Text(
                message,
                style: TextStyle(fontSize: 12),
              ),
              title: Text(
                "ሞባይል ዳታ በመጠቀም ዳታን ሴብ ማድርግ",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              leading: Icon(
                Icons.network_cell,
                color: Colors.lightBlueAccent,
                size: 30,
              ),
              trailing: Hive.box("setting").get("mobSync")
                  ? IconButton(
                      icon: Icon(
                        Icons.toggle_on_outlined,
                        size: 50,
                        color: Colors.lightBlueAccent,
                      ),
                      onPressed: () {
                        setState(() {
                          Hive.box("setting").put("mobSync", false);
                          message =
                              ".Data Off ነው. ሞባይል ዳታወትን ኦን እስከሚያደርጉ ዳታው ከስልክው ላይ የቀመጣል";
                        });
                      })
                  : IconButton(
                      icon: Icon(Icons.toggle_off_outlined,
                          size: 50, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          Hive.box("setting").put("mobSync", true);
                          message =
                              "Data On ነው. ሞባይል ዳታን በመጠቀም ዳታወትን ወድ ሰርበር እየላኩ ነው፡፡";
                        });
                      }),
            ),
            Divider(
              color: Colors.grey,
              // color:
            )
          ],
        ),
      ),
    );
  }
}
