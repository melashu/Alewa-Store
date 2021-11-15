
import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:boticshop/ads/ads.dart';
import 'package:boticshop/owner/PaymentHistory.dart';
import 'package:boticshop/owner/agreement.dart';
import 'package:boticshop/owner/servicecharge.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';

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
  bool isSub = Hive.box("setting").get("isSubscribed");
  BannerAd bannerAd = Ads().setAd3();

  @override
  Widget build(BuildContext context) {
    Utility.isValid();
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
      bottomNavigationBar: bannerAd != null && !isSub
          ? Container(
              height: bannerAd.size.height.toDouble(),
              width: bannerAd.size.width.toDouble(),
              child: AdWidget(
                ad: bannerAd,
              ),
            )
          : SizedBox(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
             !isSub
                ? Center(
                    child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "በቆሚነት አባል ከሆኑ በሆላ ሁሉም ማስታውቂያዎች ከሲስተሙ ይጠፋሉ፡፡",
                      style: TextStyle(fontSize: 10, color: Colors.redAccent),
                    ),
                  ))
                : SizedBox(),
             !isSub? Card(
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
                  'Subscribe peremantly ',
                  style: Style.style2,
                ),
                title: Text(
                  "በቆሚነት አባል መሆን እፈልጋለሁ ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return Agre(isForInfo: false);
                  }));
                },
              ),
            ):SizedBox(),
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
                  'Information About the service Charge',
                  style: Style.style2,
                ),
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
                  " ያለብዎትን የአገልግሎት ክፍያ ለማየት",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ServiceCharge();
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
                  'Your Payment History',
                  style: Style.style2,
                ),
                title: Text(
                  "የክፍያ ታሪኮች",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                 Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return PaymentHistory();
                  }));
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
