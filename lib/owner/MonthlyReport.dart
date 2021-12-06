import 'dart:io';

import 'package:abushakir/abushakir.dart';
import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/date.dart';
import 'package:boticshop/Utility/report.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:boticshop/owner/PdfInvoice.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_file/open_file.dart';

class MonthlyTransaction extends StatefulWidget {
  @override
  _MonthlyTransaction createState() => _MonthlyTransaction();
}

class _MonthlyTransaction extends State<MonthlyTransaction> {
  final formKey = GlobalKey<FormState>();
  Box catBox = Hive.box("categorie");
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Hive.box("setting").get("orgName"),
          style: Style.style1,
        ),
      ),
      persistentFooterButtons: [
        OutlinedButton(
          child: Text("Generate as PDF"),
          style: Style.outlinedButtonStyle,
          onPressed: () async {
            var soldItemList =
                await Report.getDailyTransaction(userName: 'owner');
            File lastPdf = await PdfInvoice.generatePDF(
                soldItemList,
                // "የቀን ${Dates.today} እላታዊ የሽያጭ ሪፖርት"
                "Daily Sales Report",
                Report.getDailyExpenes(),
                Dates.today);
            await OpenFile.open(lastPdf.path);
            // print("Pdf Generated");
          },
        ),
        OutlinedButton(
          child: Text("View Total"),
          style: Style.outlinedButtonStyle,
          onPressed: () async {
            var soldItemList =
                await Report.getMonthlyTransaction(userName: 'owner');
            Utility.showTotalSales(
                data: soldItemList,
                context: context,
                date:
                    "የቀን ${Dates.today} to ${EtDatetime.parse(Dates.today).subtract(Duration(days: 30))} ወርሃዊ የሽያጭ ሪፖርት",
                expenes: Report.getMonthlyExpenes());
          },
        )
      ],
      body: ListView(
        children: [
          Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.deepPurpleAccent)),
              child: Text(
                "የቀን ${Dates.today} to ${EtDatetime.parse(Dates.today).add(Duration(days: 30))} የሽያጭ ሪፖርት",
                style: Style.style1,
                textAlign: TextAlign.center,
              )),
          Divider(
            thickness: 1,
            color: Colors.deepPurpleAccent,
          ),
          Container(
              padding: EdgeInsets.all(15),
              child: FutureBuilder<List>(
                  future: Report.getMonthlyTransaction(userName: 'owner'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length == 0) {
                        return Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: Colors.deepPurpleAccent)),
                            child: Text(
                              "ይቅርታ ላለፉት 30 ቀናት ምንም አይነት ሽያጭ አልተካሂደም::",
                              style: Style.style1,
                              textAlign: TextAlign.center,
                            ));
                      }
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return ExpansionTile(
                              title: Text(
                                  "የእቃው አይነት ${snapshot.data[index]['brandName']}",
                                  style: Style.style1),
                              // subtitle: Text("የእቃው አይነት ${snapshot.data[index]['brandName']}"),
                              leading: Icon(
                                Icons.album_rounded,
                                color: Colors.deepPurpleAccent,
                              ),
                              tilePadding: EdgeInsets.only(left: 20),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "የእቃው አይነት ፡ ${snapshot.data[index]['brandName']} ቁጥር ${snapshot.data[index]['size']}",
                                          style: Style.style1,
                                        ),
                                        Text(
                                          "የተገዛበት ዋጋ ፡ ${snapshot.data[index]['buyPrices']} ብር",
                                          style: Style.style1,
                                        ),
                                        Text(
                                            "የተሸጠበት ዋጋ ፡ ${snapshot.data[index]['soldPrices']} ብር",
                                            style: Style.style1),
                                        Text(
                                            "የተሸጠው እቃ ብዛት ፡ ${snapshot.data[index]['amount']}",
                                            style: Style.style1),
                                        Text(
                                            "የሽያጭ ባለሙያው ስም ፡ ${snapshot.data[index]['salesPerson']}",
                                            style: Style.style1),
                                        Text(
                                            "ትርፍ ፡ ${int.parse(snapshot.data[index]['soldPrices']) - int.parse(snapshot.data[index]['buyPrices']) * int.parse(snapshot.data[index]['amount'])} ብር",
                                            style: Style.style1),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          });
                    } else
                      return Center(
                          child: CircularProgressIndicator.adaptive());
                  })),
        ],
      ),
    );
  }
}
