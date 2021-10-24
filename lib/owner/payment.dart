import 'dart:ui';

import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:boticshop/owner/agreement.dart';
import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  // var message = ".Data Off ነው. ሞባይል ዳታወትን ኦን እስከሚያደርጉ ዳታው ከስልክው ላይ የቀመጣል";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Utility.getTitle(),
        // actions: [
        //   Row(
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.only(right: 12.0),
        //         child: Icon(Icons.settings),
        //       )
        //     ],
        //   )
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Card(
              elevation: 10,
              child: ListTile(
                selectedTileColor: Colors.grey,
                leading: Icon(
                  Icons.keyboard_arrow_right_outlined,
                  color: Colors.blueAccent,
                  size: 35,
                ),
                horizontalTitleGap: 5,
                contentPadding: EdgeInsets.all(1),
                subtitle: Text('Information About the service Charge',style: Style.style2,),
                title: Text(
                  "ስለ አገልግሎት ክፍያ መረጃ ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return Agre(isForInfo: true);
                  }));
                },
              ),
            ),
            Card(
              elevation: 10,
              child: ListTile(
                selectedTileColor: Colors.grey,
                leading: Icon(
                  Icons.keyboard_arrow_right_outlined,
                  color: Colors.blueAccent,
                  size: 35,
                ),
                horizontalTitleGap: 5,
                contentPadding: EdgeInsets.all(1),
                subtitle: Text(
                  'Your Service Charge',
                  style: Style.style2,
                ),
                title: Text(
                  " ያለብዎትን የአገልግሎት ክፍያ ለማይት",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  // Navigator.of(context)
                  //     .push(MaterialPageRoute(builder: (context) {
                  //   return Agre(isForInfo: true);
                  // }));
                },
              ),
            ),
                Card(
              elevation: 10,
              child: ListTile(
                selectedTileColor: Colors.grey,
                leading: Icon(
                  Icons.keyboard_arrow_right_outlined,
                  color: Colors.blueAccent,
                  size: 35,
                ),
                horizontalTitleGap: 5,
                contentPadding: EdgeInsets.all(1),
                subtitle: Text(
                  'Your Payment History',
                  style: Style.style2,
                ),
                title: Text(
                  "የክፍያ ታሪኳች",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  // Navigator.of(context)
                  //     .push(MaterialPageRoute(builder: (context) {
                  //   return Agre(isForInfo: true);
                  // }));
                },
              ),
            ),
            // Card(
            //   child: ListTile(
            //     // horizontalTitleGap: 5,
            //     autofocus: true,
            //     contentPadding: EdgeInsets.all(1),
            //     title: Text(
            //       "Storge Management",
            //     ),

            //     leading: Icon(
            //       Icons.file_present,
            //       size: 30,
            //       color: Colors.deepPurpleAccent,
            //     ),
            //     onTap: () {
            //       Navigator.of(context)
            //           .push(MaterialPageRoute(builder: (context) {
            //         return Storage();
            //       }));
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
