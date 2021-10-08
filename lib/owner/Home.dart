import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/date.dart';
import 'package:boticshop/Utility/drawer.dart';
import 'package:boticshop/Utility/location.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:boticshop/https/Item.dart';
import 'package:boticshop/owner/MainPage.dart';
import 'package:boticshop/owner/Transaction.dart';
import 'package:boticshop/owner/item.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import "package:flutter/material.dart";
import 'package:hive/hive.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'itemList.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var itemBox = Hive.box("item");
  var transactionBox = Hive.lazyBox("transaction");
  var flash = "Flash On";
  var back = "Back Camera";
  var pause = "Pause Scanning";
  bool isSuccess = false;
  var dataRow = <DataRow>[];
  var key = GlobalKey(debugLabel: 'QR');
  QRViewController QRcontroler;
  List listOfData;
  String qrText = '';
  var finalMessage = '';
  var isFinished = false;
  final orderController = TextEditingController();
  final pricesController = TextEditingController();
  // var itemsList=Hive.box("item").values.toList();
  var selectedItem = [];

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      QRcontroler?.pauseCamera();
    } else if (Platform.isIOS) {
      QRcontroler?.resumeCamera();
    }
  }

  @override
  void initState() {
    super.initState();
    listOfData = itemBox.values.toList();
    Connectivity().onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile &&
          Hive.box("setting").get("mobSync")) {
        SyncItem().syncInsertItemList(context);
        SyncItem().syncUpdateItem(context);
        SyncItem().syncDeleteItem(context);
        // SyncItem.getTotalItem();
      } else if (event == ConnectivityResult.wifi &&
          Hive.box("setting").get("wifiSync")) {
        SyncItem().syncInsertItemList(context);
        SyncItem().syncUpdateItem(context);
        SyncItem().syncDeleteItem(context);
      } else {}
    });
    // startPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(onPressed: () {}, child: Text("Logout")),
          ],
          title: Text(
            Hive.box("setting").get("orgName"),
            style: Style.style1,
          ),
          elevation: 10,
        ),
        drawer: Drawers.getMainMenu(context),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: QRView(
                  key: key,
                  onQRViewCreated: onQRViewCreated,
                  overlayMargin: EdgeInsets.all(2),
                  overlay: QrScannerOverlayShape(
                    borderColor: Colors.red,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: 250,
                  ),
                ),
              ),
              Visibility(
                visible: isSuccess,
                child: Container(
                    margin: EdgeInsets.only(top: 5),
                    width: 350,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        // border: Border.all(),
                        color: Colors.lightGreenAccent,
                        borderRadius: BorderRadius.circular(5)),
                    child: ListTile(
                        title: Center(
                            child: Text(
                          'በትክክል 1 $qrText ሽጠዎል',
                          style: Style.style1,
                        )),
                        trailing: CircleAvatar(
                          child: IconButton(
                            icon: Icon(Icons.done),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return Home();
                              }));
                            },
                          ),
                        )

                        // Icon(Icons.done),

                        )),
              ),
              Visibility(
                visible: isFinished,
                child: Container(
                    margin: EdgeInsets.only(top: 5),
                    width: 350,
                    height: 70,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        // border: Border.all(),
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(5)),
                    child: ListTile(
                        title: Center(
                            child: Text(
                          '$finalMessage',
                          style: TextStyle(color: Colors.white),
                        )),
                        trailing: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: Icon(
                              Icons.close_outlined,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return Home();
                              }));
                            },
                          ),
                        )

                        // Icon(Icons.done),

                        )),
              ),
              // Divider(
              //   thickness: 4,
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        QRcontroler.toggleFlash();
                        if (isFlash(flash)) {
                          setState(() {
                            flash = "Flash Off";
                          });
                        } else {
                          setState(() {
                            flash = "Flash On";
                          });
                        }
                      },
                      child: Text(flash),
                      style: ElevatedButton.styleFrom(
                          elevation: 8,
                          textStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                          primary: Colors.deepPurple,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        QRcontroler.flipCamera();

                        if (isBack(back)) {
                          setState(() {
                            back = "Front Camera";
                          });
                        } else {
                          setState(() {
                            back = "Back Camera";
                          });
                        }
                      },
                      child: Text(back),
                      style: ElevatedButton.styleFrom(
                          // elevation: 10,
                          elevation: 8,
                          textStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                          primary: Colors.deepPurple,
                          onPrimary: Colors.white,
                          // side:  BorderSide(color: Colors.redAccent),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        if (isPause(pause)) {
                          QRcontroler.pauseCamera();
                          setState(() {
                            pause = "Keep Scanning";
                          });
                        } else {
                          QRcontroler.resumeCamera();
                          setState(() {
                            pause = "Pause Scanning";
                          });
                        }
                      },
                      child: Text(pause),
                      style: ElevatedButton.styleFrom(
                          // elevation: 10,
                          elevation: 8,
                          textStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                          primary: Colors.deepPurple,
                          onPrimary: Colors.white,
                          // side:  BorderSide(color: Colors.redAccent),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (val) {
                    if (Utility.isValid()) {
                      Utility.getValidationBox(context);
                    } else {
                       if (!Hive.box('setting').get("isWorkingLoc")) {
                        Utility.setCurrentWorkingLocation();
                      }
                      
                      var filtered = [];
                      if (val.isEmpty) {
                        filtered = [];
                      } else {
                        filtered = listOfData
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
                      setState(() {
                        selectedItem = filtered;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                        icon: Icon(Icons.search_outlined), onPressed: () {}),
                    labelText: "የሚሸጡትን እቃ ከዚህ ላይ ይፈልጉ ",
                    labelStyle: Style.style1,
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),

              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: selectedItem.length,
                    itemBuilder: (context, index) {
                      // if (selectedItem.length == 0)
                      //   return Text("Sorry item is not found");
                      if (selectedItem[index]['deleteStatus'] == 'no' &&
                          int.parse(selectedItem[index]['amount'].toString()) >
                              0) {
                        return ExpansionTile(
                          subtitle: Text(
                            "Number of Items: ${selectedItem[index]['amount']}",
                          ),
                          title: Text(
                              "Item Name ${selectedItem[index]['brandName']}",
                              style: Style.style1),
                          tilePadding: EdgeInsets.only(left: 20),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Item ID: ${selectedItem[index]['itemID']} ",
                                        style: Style.style1),
                                    Text(
                                        "Item Category: ${selectedItem[index]['catName']}",
                                        style: Style.style1),
                                    Text(
                                        "Item Name: ${selectedItem[index]['brandName']}",
                                        style: Style.style1),
                                    Text("Size: ${selectedItem[index]['size']}",
                                        style: Style.style1),
                                    Text(
                                        "Qunatity: ${selectedItem[index]['amount']}",
                                        style: Style.style1),
                                    Text(
                                        "Buy Price: ${selectedItem[index]['buyPrices']} ",
                                        style: Style.style1),
                                    Text(
                                        "Retailer Prices : ${selectedItem[index]['soldPrices']} ",
                                        style: Style.style1),
                                    Text(
                                        "Registered Date: ${selectedItem[index]['createDate']} ",
                                        style: Style.style1),
                                    OutlinedButton(
                                      onPressed: () async {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                  content: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: ListView(
                                                      shrinkWrap: true,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: TextField(
                                                            onChanged: (val) {
                                                              var quantity =
                                                                  int.parse(
                                                                      val.isEmpty
                                                                          ? '0'
                                                                          : val);
                                                              var prices = int.parse(
                                                                  selectedItem[
                                                                              index]
                                                                          [
                                                                          'soldPrices']
                                                                      .toString());
                                                              var total =
                                                                  quantity *
                                                                      prices;
                                                              pricesController
                                                                ..text = total
                                                                    .toString();
                                                            },
                                                            controller:
                                                                orderController
                                                                  ..text = '1',
                                                            decoration:
                                                                InputDecoration(
                                                                    labelText:
                                                                        'Quantity',
                                                                    border:
                                                                        OutlineInputBorder()),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: TextField(
                                                            controller: pricesController
                                                              ..text = selectedItem[
                                                                          index]
                                                                      [
                                                                      'soldPrices']
                                                                  .toString(),
                                                            decoration:
                                                                InputDecoration(
                                                                    labelText:
                                                                        'Prices',
                                                                    border:
                                                                        OutlineInputBorder()),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // ),
                                                  actions: [
                                                    OutlinedButton(
                                                      onPressed: () async {
                                                        var amountOrder =
                                                            int.parse(
                                                                orderController
                                                                    .text);

                                                        var amount = int.parse(
                                                            selectedItem[index]
                                                                    ['amount']
                                                                .toString());
                                                        var selectedItemSoldPrices =
                                                            selectedItem[index][
                                                                    'soldPrices']
                                                                .toString();

                                                        if (int.tryParse(
                                                                    orderController
                                                                        .text) ==
                                                                null ||
                                                            amountOrder == 0) {
                                                          Utility.showSnakBar(
                                                              context,
                                                              "Please Enter Number only ",
                                                              Colors.redAccent);
                                                        } else if (amount <
                                                            amountOrder) {
                                                          Utility.showDialogBox(
                                                              context,
                                                              "You have limited item",
                                                              Colors.redAccent);
                                                        } else {
                                                          var itemList =
                                                              selectedItem[
                                                                  index];
                                                          var random = Random();
                                                          var tID = random
                                                              .nextInt(1000000);
                                                          var today =
                                                              Dates.today;
                                                          // var salesPerson =
                                                          //     'Meshu';
                                                          var itemID = itemList[
                                                              'itemID'];
                                                          var order =
                                                              orderController
                                                                  .text;
                                                          itemList[
                                                              'salesPerson'] = Hive
                                                                  .box(
                                                                      "setting")
                                                              .get(
                                                                  "deviceUser");
                                                          itemList[
                                                                  'salesDate'] =
                                                              today;
                                                          itemList[
                                                                  'soldPrices'] =
                                                              pricesController
                                                                  .text;
                                                          itemList['amount'] =
                                                              order;
                                                          Map item = itemBox
                                                              .get(itemID);

                                                          await transactionBox
                                                              .put("T$tID",
                                                                  itemList);
                                                          if (transactionBox
                                                              .containsKey(
                                                                  "T$tID")) {
                                                            item['amount'] =
                                                                (amount -
                                                                        amountOrder)
                                                                    .toString();
                                                            item["amountSold"] =
                                                                (int.parse(item[
                                                                            "amountSold"]
                                                                        .toString()) +
                                                                    amountOrder);
                                                            item['soldPrices'] =
                                                                selectedItemSoldPrices;
                                                            item['updateStatus'] =
                                                                'yes';
                                                            itemBox.put(
                                                                itemID, item);
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    content:
                                                                        Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              8),
                                                                      child:
                                                                          Text(
                                                                        " ${itemList['brandName']} is sold::",
                                                                        style: Style
                                                                            .style1,
                                                                      ),
                                                                    ),
                                                                    actions: [
                                                                      OutlinedButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).push(MaterialPageRoute(builder:
                                                                                (context) {
                                                                              return ItemList();
                                                                            }));
                                                                          },
                                                                          style: Style
                                                                              .smallButton,
                                                                          child:
                                                                              Text(
                                                                            "Ok",
                                                                            style:
                                                                                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      style: Style.smallButton,
                                                    ),
                                                    OutlinedButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('Close',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      style: Style.smallButton,
                                                    )
                                                  ]);
                                            });
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
                      }
                      return SizedBox();
                    }),
              )
            ],
          ),
        ),
        bottomNavigationBar: Drawers.getBottomNavigationBar(context, 0));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onQRViewCreated(QRViewController controller) {
    this.QRcontroler = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (Utility.isValid()) {
        Utility.getValidationBox(context);
      } else {
        /**
         * This is to get the worring co-ordinates of the customer 
         */
        if (!Hive.box('setting').get("isWorkingLoc")) {
          Utility.setCurrentWorkingLocation();
        }

        var random = Random();
        var tID = random.nextInt(1000000);
        Map itemList = json.decode(scanData.code);
        var today = Dates.today;
        var itemID = itemList['itemID'];
        itemList['salesPerson'] = Hive.box("setting").get("deviceUser");
        itemList['salesDate'] = today;
        itemList['amount'] = '1';
        Map item = itemBox.get(itemID);
        var itemAmount = item['amount'].toString();
        if (item == null) {
          QRcontroler.pauseCamera();
          setState(() {
            finalMessage = "Sorry " +
                itemList['brandName'] +
                " with size " +
                itemList['size'] +
                " is not found፡";
            isFinished = true;
          });
        } else if (int.parse(itemAmount) > 0) {
          QRcontroler.pauseCamera();
          await transactionBox.put("T$tID", itemList);
          if (transactionBox.containsKey("T$tID")) {
            item['amount'] = (int.parse(itemAmount)) - 1;
            item["amountSold"] = (int.parse(item["amountSold"].toString())) + 1;
            item['updateStatus'] = 'yes';
            itemBox.put(itemID, item);
            setState(() {
              qrText = itemList['brandName'];
              isSuccess = true;
            });
          }
        }
        //
        else {
          QRcontroler.pauseCamera();
          setState(() {
            finalMessage = itemList['brandName'] +
                ", size " +
                itemList['size'] +
                " finished";
            isFinished = true;
          });
        }
      }
    });
  }

  bool isFlash(String flash) {
    return flash == "Flash On";
  }

  bool isBack(String back) {
    return back == "Back Camera";
  }

  bool isPause(String pause) {
    return pause == "Pause Scanning";
  }
}
