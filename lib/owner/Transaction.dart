import 'dart:io';

import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/date.dart';
import 'package:boticshop/Utility/drawer.dart';
import 'package:boticshop/Utility/report.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:boticshop/owner/PdfInvoice.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_file/open_file.dart';

class Transaction extends StatefulWidget {
  @override
  _TransactionState createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  final formKey = GlobalKey<FormState>();
  Box catBox = Hive.box("categorie");
  final pricesController = TextEditingController();
  final orderController = TextEditingController();
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
        title: Utility.getTitle(),
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
          },
        ),
        OutlinedButton(
          child: Text("View Total"),
          style: Style.outlinedButtonStyle,
          onPressed: () async {
            var soldItemList =
                await Report.getDailyTransaction(userName: 'owner');
            Utility.showTotalSales(
                data: soldItemList,
                context: context,
                date: "Today sales report",
                expenes: Report.getDailyExpenes());
          },
        )
      ],
      bottomNavigationBar: Drawers.getBottomNavigationBar(context, 2),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                "የቀን ${Dates.today}  የሽያጭ ሪፖርት",
                // "Daily Sales Report",
                style: Style.style1,
              ),
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.deepPurpleAccent,
          ),
          Container(
              padding: EdgeInsets.all(15),
              child: FutureBuilder<List>(
                  future: Report.getDailyTransaction(userName: 'owner'),
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
                              "Sorry, sales is not done yet!",
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
                                            "ትርፍ ፡ ${int.parse(snapshot.data[index]['soldPrices']) - (int.parse(snapshot.data[index]['buyPrices']) * int.parse(snapshot.data[index]['amount']))} ብር",
                                            style: Style.style1),
                                        OutlinedButton(
                                          onPressed: () async {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    content: Text(
                                                        "  ${snapshot.data[index]['brandName']} ቁጥር ${snapshot.data[index]['size']} መመለስ ይፈልጋሉ? "),
                                                    actions: [
                                                      OutlinedButton(
                                                        autofocus: true,
                                                        style: OutlinedButton
                                                            .styleFrom(
                                                                minimumSize:
                                                                    Size(100,
                                                                        30),
                                                                backgroundColor:
                                                                    Colors
                                                                        .deepPurple,
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(3),
                                                                elevation: 5,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                )),
                                                        onPressed: () async {
                                                          Navigator.of(context)
                                                              .pop();
/***
 * This Dialog box is poped to accept 
 * the amount of item user want to return 
 */
                                                          var itemAmount =
                                                              snapshot
                                                                  .data[index]
                                                                      ['amount']
                                                                  .toString();
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                    title: Text(
                                                                      "እባክዎትን መመለስ የሚፈልጉትን የእቃ ብዛት ያስገቡ",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                    content:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          SingleChildScrollView(
                                                                        child:
                                                                            Column(
                                                                          // shrinkWrap: true,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: TextFormField(
                                                                                onChanged: (val) {},
                                                                                validator: (val) {
                                                                                  if (int.tryParse(val) == null || val.isEmpty) {
                                                                                    return "እባክዎትን ትክክለኛ ቁጥር ያስገቡ";
                                                                                  } else if (int.parse(itemAmount) < int.parse(val)) {
                                                                                    return "ከተሽጠው በላይ ለመመለስ እየሙክሩ ነው";
                                                                                  }
                                                                                  return null;
                                                                                },
                                                                                controller: orderController..text = itemAmount,
                                                                                decoration: InputDecoration(labelText: 'ብዛት', border: OutlineInputBorder()),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    // ),
                                                                    actions: [
                                                                      OutlinedButton(
                                                                        onPressed:
                                                                            () async {
                                                                          if (int.tryParse(orderController.text) == null ||
                                                                              orderController.text.isEmpty) {
                                                                            Utility.showDangerMessage(context,
                                                                                "እባክዎትን ትክክለኛ ቁጥር ያስገቡ");
                                                                            // return "እባክዎትን ትክክለኛ ቁጥር ያስገቡ";
                                                                          } else if (int.parse(itemAmount) <
                                                                              int.parse(orderController.text)) {
                                                                            Utility.showDangerMessage(context,
                                                                                "ከተሽጠው በላይ ለመመለስ እየሙክሩ ነው");
                                                                            // return "";
                                                                          } else {
                                                                            var itemBox =
                                                                                Hive.box("item");
                                                                            var itemID =
                                                                                snapshot.data[index]['itemID'];
                                                                            var tID =
                                                                                snapshot.data[index]['tID'];
                                                                            Map item =
                                                                                itemBox.get(itemID);
                                                                            item['deleteStatus'] =
                                                                                'no';
                                                                            item['amount'] =
                                                                                ((int.parse(orderController.text)) + (int.parse(item['amount'].toString())));
                                                                            item["amountSold"] =
                                                                                ((int.parse(orderController.text)) - (int.parse(item['amount'].toString())));
                                                                            item['updateStatus'] =
                                                                                'yes';
                                                                            itemBox.put(itemID,
                                                                                item);
                                                                            if (int.parse(itemAmount) - int.parse(orderController.text) ==
                                                                                0) {
                                                                              await Hive.lazyBox("transaction").delete(tID);
                                                                            } else {
                                                                              var thisTrasaction = snapshot.data[index];
                                                                              thisTrasaction['amount'] = (int.parse(itemAmount) - int.parse(orderController.text)).toString();
                                                                              await Hive.lazyBox("transaction").put(tID, thisTrasaction);
                                                                            }
//delete it if it is less than zero
                                                                            Navigator.of(context).push(MaterialPageRoute(builder:
                                                                                (context) {
                                                                              return Transaction();
                                                                            }));
                                                                          }
                                                                        },
                                                                        autofocus:
                                                                            true,
                                                                        child:
                                                                            Text(
                                                                          'ይመለስ',
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        style: Style
                                                                            .smallButton,
                                                                      ),
                                                                      OutlinedButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: Text(
                                                                            'Close',
                                                                            style:
                                                                                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                                                        style: Style
                                                                            .smallButton,
                                                                      )
                                                                    ]);
                                                              });
                                                        },
                                                        child: Text(
                                                          'Yes',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      OutlinedButton(
                                                        style: OutlinedButton
                                                            .styleFrom(
                                                                // minimumSize: Size(100, 30),
                                                                backgroundColor:
                                                                    Colors
                                                                        .deepPurple,
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(3),
                                                                elevation: 5,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                )),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('No',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      )
                                                    ],
                                                  );
                                                });
                                          },
                                          child: Text(
                                            "ይመልሱ",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                              minimumSize: Size(100, 30),
                                              backgroundColor:
                                                  Colors.deepPurple,
                                              padding: EdgeInsets.all(3),
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          });
                    } else
                      return Center(child: CircularProgressIndicator());
                  })),
        ],
      ),
    );
  }
}
