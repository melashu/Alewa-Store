import 'dart:math';
import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/date.dart';
import 'package:boticshop/Utility/drawer.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:boticshop/owner/editItem.dart';
import 'package:boticshop/owner/item.dart';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

final itemListStateProvider = StateProvider.autoDispose<List>((ref) {
  var item = Hive.box("item").values.toList();
  return item;
});

final selectedItemStateProvider = StateProvider.autoDispose<List>((ref) {
  var selected = ref.watch(itemListStateProvider).state;
  return selected;
});

class ItemList extends ConsumerWidget {
  final setting = Hive.box("setting");
  final itemBox = Hive.box('item');
  final orderController = TextEditingController();
  final pricesController = TextEditingController();
  final transactionBox = Hive.lazyBox("transaction");

  @override
  Widget build(BuildContext context, watch) {
    return Scaffold(
      appBar: AppBar(
        title: Utility.getTitle(),
      ),
      floatingActionButton: SpeedDial(
        label: Text("Add New Product"),
        onPress: () {
          Navigator.push(context, MaterialPageRoute(builder: (contex) {
            return Item();
          }));
        },
      ),
      bottomNavigationBar: Drawers.getBottomNavigationBar(context, 1),
      body: Container(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Text(
                  "የተመዘገቡ እቃዎች ዝርዝር",
                  style: Style.style1,
                ),
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.blue,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextFormField(
                onChanged: (val) {
                  List filtered = [];
                  if (val.isEmpty) {
                    filtered = watch(itemListStateProvider).state;
                  } else {
                    var itemes = watch(itemListStateProvider).state;
                    filtered = itemes
                        .where((row) =>
                            (row['brandName']
                                .toString()
                                .toLowerCase()
                                .contains(val.toLowerCase())) ||
                            (row['catName']
                                .toString()
                                .toLowerCase()
                                .contains(val.toLowerCase())))
                        .toList();
                  }
                  watch(selectedItemStateProvider).state = filtered;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search_outlined),
                    onPressed: () {},
                  ),
                  labelText: "Search here ",
                  labelStyle: Style.style1,
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
            dataTable(context)
            // ValueListenableBuilder(
            //     valueListenable: itemBox.listenable(),
            //     builder: (context, box, _) {
            //       List data = box.values.toList();
            //       return dataTable(context, data);
            //     }),
          ],
        ),
      ),
    );
  }

  Widget dataTable(BuildContext context) {
    // Widget dataTable(BuildContext context, selectedItem) {

    var selectedItem = context.read(selectedItemStateProvider).state;
    // print("Result =$selectedItem");
    // Hive.box('item').clear();

    return ListView.builder(
        itemCount: selectedItem.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          if (selectedItem[index]['deleteStatus'] == 'no' &&
              int.parse(selectedItem[index]['amount'].toString()) > 0) {
            return ExpansionTile(
              subtitle: Text(
                "እቃ ብዛት: ${selectedItem[index]['amount']}",
              ),
              title: Text(
                  "የእቃው አይነት  ${selectedItem[index]['brandName']}, ${selectedItem[index]['catName']}",
                  style: Style.style1),
              leading: PopupMenuButton(
                  color: Colors.deepPurple,
                  initialValue: 0,
                  onSelected: (i) {
                    if (i == 0) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return EditItem(selectedItem[index]);
                      }));
                    } else if (i == 1) {
                      Utility.showConfirmDialog(
                          context: context, itemMap: selectedItem[index]);
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                          value: 0,
                          child: Text("Edit",
                              style: TextStyle(color: Colors.white))),
                      PopupMenuItem(
                          value: 1,
                          child: Text("Delete",
                              style: TextStyle(color: Colors.white))),
                    ];
                  }),
              tilePadding: EdgeInsets.only(left: 20),
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "የእቃው አይነት ፡ ${selectedItem[index]['brandName']} ቁጥር ${selectedItem[index]['size']}",
                          style: Style.style1,
                        ),
                        Text(
                          "የተገዛበት ዋጋ ፡ ${selectedItem[index]['buyPrices']} ብር",
                          style: Style.style1,
                        ),
                        Text("መሽጫ ዋጋ ፡ ${selectedItem[index]['soldPrices']} ብር",
                            style: Style.style1),
                        // Text("የተሸጠው እቃ ብዛት ፡ ${selectedItem[index]['amount']}",
                        //     style: Style.style1),
                        // Text(
                        //     "የሽያጭ ባለሙያው ስም ፡ ${selectedItem[index]['salesPerson']}",
                        //     style: Style.style1),
                        // Text(
                        //     "ልዮነት ፡ ${int.parse(selectedItem[index]['soldPrices']) - int.parse(selectedItem[index]['buyPrices'])} ብር",
                        //     style: Style.style1),
                        OutlinedButton(
                          onPressed: () async {
                            if (Utility.isValid()) {
                              Utility.getValidationBox(context);
                            } else if (Utility.isPaymentDone()) {
                                     Utility.setServicePayment(context);

                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        content: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              // shrinkWrap: true,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextField(
                                                    onChanged: (val) {
                                                      var quantity = int.parse(
                                                          val.isEmpty
                                                              ? '0'
                                                              : val);
                                                      var prices = int.parse(
                                                          selectedItem[index]
                                                                  ['soldPrices']
                                                              .toString());
                                                      var total =
                                                          quantity * prices;
                                                      pricesController
                                                        ..text =
                                                            total.toString();
                                                    },
                                                    controller: orderController
                                                      ..text = '1',
                                                    decoration: InputDecoration(
                                                        labelText: 'Quantity',
                                                        border:
                                                            OutlineInputBorder()),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextField(
                                                    controller: pricesController
                                                      ..text =
                                                          selectedItem[index]
                                                                  ['soldPrices']
                                                              .toString(),
                                                    decoration: InputDecoration(
                                                        labelText: 'Prices',
                                                        border:
                                                            OutlineInputBorder()),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // ),
                                        actions: [
                                          OutlinedButton(
                                            onPressed: () async {
                                              if (!Hive.box('setting')
                                                  .get("isWorkingLoc")) {
                                                Utility
                                                    .setCurrentWorkingLocation();
                                              }
                                              var amountOrder = int.parse(
                                                  orderController.text);

                                              var amount = int.parse(
                                                  selectedItem[index]['amount']
                                                      .toString());
                                              var selectedItemSoldPrices =
                                                  selectedItem[index]
                                                          ['soldPrices']
                                                      .toString();
                                              if (int.tryParse(orderController
                                                          .text) ==
                                                      null ||
                                                  amountOrder == 0) {
                                                Utility.showSnakBar(
                                                    context,
                                                    "እባክዎትን ",
                                                    Colors.redAccent);
                                              } else if (amount < amountOrder) {
                                                Utility.showDialogBox(
                                                    context,
                                                    "የቀረው እቃ ከታዘዘው ያነሰ ነው፡፡",
                                                    Colors.redAccent);
                                              } else {
                                                var itemList =
                                                    selectedItem[index];
                                                var random = Random();
                                                var tID =
                                                    random.nextInt(1000000);
                                                var today = Dates.today;
                                                var itemID = itemList['itemID'];
                                                var order =
                                                    orderController.text;
                                                itemList['salesPerson'] =
                                                    Hive.box("setting")
                                                        .get("deviceUser");
                                                itemList['salesDate'] = today;
                                                itemList['soldPrices'] =
                                                    pricesController.text;
                                                itemList['amount'] = order;
                                                Map item = itemBox.get(itemID);

                                                await transactionBox.put(
                                                    "T$tID", itemList);
                                                if (transactionBox
                                                    .containsKey("T$tID")) {
                                                  item['amount'] =
                                                      (amount - amountOrder)
                                                          .toString();
                                                  item["amountSold"] =
                                                      (int.parse(
                                                              item["amountSold"]
                                                                  .toString()) +
                                                          amountOrder);
                                                  item['soldPrices'] =
                                                      selectedItemSoldPrices;
                                                  item['updateStatus'] = 'yes';
                                                  itemBox.put(itemID, item);
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          content: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8),
                                                            child: Text(
                                                              " ${itemList['brandName']} ሽያጭ ተካሄዶል፡፡",
                                                              style:
                                                                  Style.style1,
                                                            ),
                                                          ),
                                                          actions: [
                                                            OutlinedButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                style: Style
                                                                    .smallButton,
                                                                child: Text(
                                                                  "Ok",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ))
                                                          ],
                                                        );
                                                      });
                                                }
                                              }
                                            },
                                            autofocus: true,
                                            child: Text(
                                              'Sell',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            style: Style.smallButton,
                                          ),
                                          OutlinedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Close',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            style: Style.smallButton,
                                          )
                                        ]);
                                  });
                            }
                          },
                          child: Text(
                            "Order",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: OutlinedButton.styleFrom(
                              minimumSize: Size(100, 30),
                              backgroundColor: Colors.deepPurple,
                              padding: EdgeInsets.all(3),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return SizedBox();
        });
  }
}
