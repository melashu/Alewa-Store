import 'dart:io';

import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/date.dart';
import 'package:boticshop/Utility/report.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:boticshop/owner/Home.dart';
import 'package:boticshop/owner/MainPage.dart';
import 'package:boticshop/owner/PdfInvoice.dart';
import 'package:boticshop/owner/itemList.dart';
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepPurple,
        // selectedFontSize: 12,
        selectedItemColor: Colors.white,
        // unselectedFontSize: 12,
        unselectedItemColor: Colors.white60,
        selectedLabelStyle: TextStyle(
            color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(
            color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
        iconSize: 40,
        elevation: 10,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            // label: 'ዋና',
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            // label: 'የእቃዎች ዝርዝር',
            label: 'Item List',
            // title:
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.deepPurpleAccent,
            icon: Icon(Icons.report),
            // label: 'ዕለታዊ የሽያጭ ሪፖርት',
            label: 'Daily Sales',

            // title:
          ),
        ],

        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MainPage();
            }));
          } else if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ItemList();
            }));
          } else if (index == 2) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Transaction();
            }));
          }
        },
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                // "የቀን ${Dates.today}  የሽያጭ ሪፖርት",
                "Daily Sales Report",
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
                                  "Item Name ${snapshot.data[index]['brandName']}",
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
                                          "Item Name፡ ${snapshot.data[index]['brandName']} Size ${snapshot.data[index]['size']}",
                                          style: Style.style1,
                                        ),
                                        Text(
                                          "Orginal Prices፡ ${snapshot.data[index]['buyPrices']} Birr",
                                          style: Style.style1,
                                        ),
                                        Text(
                                            "Retailer Prices፡ ${snapshot.data[index]['soldPrices']} Birr",
                                            style: Style.style1),
                                        Text(
                                            "Qunatity ፡ ${snapshot.data[index]['amount']}",
                                            style: Style.style1),
                                        Text(
                                            "Sales Person ፡ ${snapshot.data[index]['salesPerson']}",
                                            style: Style.style1),
                                        Text(
                                            "Difference ፡ ${int.parse(snapshot.data[index]['soldPrices']) - (int.parse(snapshot.data[index]['buyPrices']) * int.parse(snapshot.data[index]['amount'].toString()))} Birr",
                                            style: Style.style1),
                                        OutlinedButton(
                                          onPressed: () async {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    content: Text(
                                                        "  ${snapshot.data[index]['brandName']} Size ${snapshot.data[index]['size']} Do you want return back? "),
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
                                                          var itemBox =
                                                              Hive.box("item");

                                                          var itemID = snapshot
                                                                  .data[index]
                                                              ['itemID'];
                                                          var tID = snapshot
                                                                  .data[index]
                                                              ['tID'];

                                                          // Map item = itemBox.get(
                                                          //             itemID) ==
                                                          //         null
                                                          //     ? await Hive.lazyBox(
                                                          //             "transaction")
                                                          //         .get(tID)
                                                          // :

                                                          Map item = itemBox
                                                              .get(itemID);
                                                          item['deleteStatus'] =
                                                              'no';
                                                          var itemAmount =
                                                              snapshot
                                                                  .data[index]
                                                                      ['amount']
                                                                  .toString();

                                                          item['amount'] = ((int
                                                                  .parse(
                                                                      itemAmount)) +
                                                              (int.parse(item[
                                                                      'amount']
                                                                  .toString())));
                                                          item[
                                                              "amountSold"] = ((int
                                                                  .parse(
                                                                      itemAmount)) -
                                                              (int.parse(item[
                                                                      'amount']
                                                                  .toString())));
                                                          item['updateStatus'] =
                                                              'yes';
                                                          itemBox.put(
                                                              itemID, item);
                                                          await Hive.lazyBox(
                                                                  "transaction")
                                                              .delete(tID);
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                            return Transaction();
                                                          }));
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
                                            "Return Back",
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
