import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:boticshop/Utility/date.dart';
import 'package:boticshop/Utility/login.dart';
import 'package:boticshop/Utility/setting.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:boticshop/owner/MonthlyReport.dart';
import 'package:boticshop/owner/Qr-Pdf.dart';
import 'package:boticshop/owner/RequiredItem.dart';
import 'package:boticshop/owner/Transaction.dart';
import 'package:boticshop/owner/WeeklyReport.dart';
import 'package:boticshop/owner/categorie.dart';
import 'package:boticshop/owner/expenes.dart';
import 'package:boticshop/owner/item.dart';
import 'package:boticshop/owner/store_level.dart';
import 'package:boticshop/owner/useraccont.dart';
import 'package:boticshop/sync/Item.dart';
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
        SyncItem().syncSelect(context);
        SyncItem.getTotalItem();
      } else if (event == ConnectivityResult.wifi) {
        SyncItem().syncInsertItemList(context);
        SyncItem().syncUpdateItem(context);
        SyncItem().syncDeleteItem(context);
        SyncItem().syncSelect(context);
        SyncItem.getTotalItem();
      } else {
        print("No Network");
      }
    });
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
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (contex) {
            return Item();
          }));
        },
        child: Icon(Icons.add_shopping_cart_outlined),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.white),
                child: UserAccountsDrawerHeader(
                    currentAccountPicture: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.people_outlined)),
                    accountName: Text("Meshu"),
                    accountEmail: Text("working"))),
            Card(
              child: ListTile(
                autofocus: true,
                title: Text("Add Branch"),
                subtitle: Text(""),
                leading: Icon(Icons.shop_two_outlined, color: Colors.blue[400]),
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (contex) {
                  //   return QRViewExample();
                  // }));
                },
              ),
            ),
            ExpansionTile(
              title: Text("ንብረት አስተዳደር", style: Style.style1),
              tilePadding: EdgeInsets.only(left: 20),
              leading: Icon(Icons.inventory, color: Colors.blue[400]),
              subtitle: Text("Inventory Management"),
              children: [
                Card(
                  child: ListTile(
                    horizontalTitleGap: 10,
                    autofocus: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    title: Text("Add Categorie"),
                    subtitle: Text(""),
                    leading: Icon(Icons.category_outlined,
                        color: Colors.deepPurpleAccent),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (contex) {
                        return Addcategorie();
                      }));
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    horizontalTitleGap: 10,
                    autofocus: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    title: Text("አዲስ እቃ መመዝገቢያ", style: Style.style1),
                    subtitle: Text("Register New Item"),
                    leading: Icon(Icons.add_box_outlined,
                        color: Colors.deepPurpleAccent),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (contex) {
                        return Item();
                      }));
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    horizontalTitleGap: 10,
                    autofocus: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    title: Text(
                      "የእቃ ብዛት",
                      style: Style.style1,
                    ),
                    subtitle: Text(""),
                    leading: Icon(Icons.store_outlined,
                        color: Colors.deepPurpleAccent),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return StoreLevel();
                      }));
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    horizontalTitleGap: 10,
                    autofocus: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    title: Text("የእቃ ዝርዝር", style: Style.style1),
                    subtitle: Text(""),
                    leading: Icon(
                      Icons.list_alt_outlined,
                      color: Colors.deepPurpleAccent,
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ItemList();
                      }));
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    horizontalTitleGap: 10,
                    autofocus: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    title: Text("አስፈላጊ እቃዎች", style: Style.style1),
                    subtitle: Text(""),
                    leading: Icon(
                      Icons.circle,
                      color: Colors.deepPurpleAccent,
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return RequiredItem();
                      }));
                    },
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                "የሒሳብ አስተዳደር ",
                style: Style.style1,
              ),
              subtitle: Text("Finacial Management"),
              leading: Icon(Icons.file_copy_outlined, color: Colors.blue[400]),
              children: [
                Card(
                  child: ListTile(
                    horizontalTitleGap: 12,
                    title: Text("የውጭ መመዝገቢያ ", style: Style.style1),
                    subtitle: Text("Register Expeness"),
                    leading: Icon(
                      Icons.money_off,
                      color: Colors.deepPurpleAccent,
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return Expeness();
                      }));
                    },
                  ),
                ),

                // ExpansionTile(
                //   title: Text("ትርፍ እና ኪሳራ", style: Style.style1),
                //   subtitle: Text("Income Statement"),
                //   leading: Icon(
                //     Icons.album_rounded,
                //     color: Colors.deepPurpleAccent,
                //   ),
                //   tilePadding: EdgeInsets.only(left: 20),
                //   children: [
                //     Card(
                //       elevation: 10,
                //       child: ListTile(
                //         horizontalTitleGap: 12,
                //         autofocus: true,
                //         title: Text("ዕለታዊ ሪፖርት", style: Style.style1),
                //         subtitle: Text("Daily Report"),
                //         leading: Icon(Icons.report, color: Colors.orangeAccent),
                //         contentPadding: EdgeInsets.symmetric(horizontal: 20),
                //         onTap: () {},
                //       ),
                //     ),
                //     Card(
                //       elevation: 5,
                //       child: ListTile(
                //         horizontalTitleGap: 12,
                //         title: Text("ሳምንታዊ ሪፖርት", style: Style.style1),
                //         subtitle: Text("Weekliy Report"),
                //         leading:
                //             Icon(Icons.view_week, color: Colors.orangeAccent),
                //         contentPadding: EdgeInsets.symmetric(horizontal: 20),
                //         onTap: () {},
                //       ),
                //     ),
                //     Card(
                //       elevation: 10,
                //       child: ListTile(
                //         horizontalTitleGap: 12,
                //         title: Text("ወራሃዊ ሪፖርት", style: Style.style1),
                //         subtitle: Text("Monthliy Report"),
                //         leading:
                //             Icon(Icons.next_week, color: Colors.orangeAccent),
                //         contentPadding: EdgeInsets.symmetric(horizontal: 20),
                //         onTap: () {},
                //       ),
                //     ),
                //   ],
                // ),

                ExpansionTile(
                  title: Text(
                    "የሽያጭ ሪፖርት",
                    style: Style.style1,
                  ),
                  subtitle: Text("Sales Report"),
                  leading: Icon(
                    Icons.album_rounded,
                    color: Colors.deepPurpleAccent,
                  ),
                  tilePadding: EdgeInsets.only(left: 20),
                  children: [
                    Card(
                      elevation: 5,
                      child: ListTile(
                        horizontalTitleGap: 12,
                        title: Text("ሳምንታዊ ሪፖርት", style: Style.style1),
                        subtitle: Text("Weekliy Report"),
                        leading:
                            Icon(Icons.view_week, color: Colors.orangeAccent),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return WekklyTransaction();
                          }));
                        },
                      ),
                    ),
                    Card(
                      elevation: 10,
                      child: ListTile(
                        horizontalTitleGap: 12,
                        title: Text("ወራሃዊ ሪፖርት", style: Style.style1),
                        subtitle: Text("Monthliy Report"),
                        leading:
                            Icon(Icons.next_week, color: Colors.orangeAccent),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return MonthlyTransaction();
                          }));
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
            Card(
              child: ListTile(
                horizontalTitleGap: 10,
                autofocus: true,
                title: Text("የብድር አስተዳደር", style: Style.style1),
                subtitle: Text("Debt Management"),
                leading: Icon(Icons.control_point_duplicate_outlined,
                    color: Colors.blue[400]),
                onTap: () {},
              ),
            ),
            ExpansionTile(
              title: Text(
                "የሰራተኞች አስተዳደር",
                style: Style.style1,
              ),
              subtitle: Text("Employee Management"),
              leading: Icon(
                Icons.album_rounded,
                color: Colors.deepPurpleAccent,
              ),
              tilePadding: EdgeInsets.only(left: 20),
              children: [
                Card(
                  elevation: 5,
                  child: ListTile(
                    horizontalTitleGap: 12,
                    title: Text("User Account ", style: Style.style1),
                    leading: Icon(Icons.view_week, color: Colors.deepPurpleAccent),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return Useraccount();
                      }));
                    },
                  ),
                ),
              ],
            ),
            Card(
              elevation: 10,
              child: ListTile(
                horizontalTitleGap: 10,
                autofocus: true,
                title: Text("Setting", style: Style.style1),
                leading: Icon(Icons.settings, color: Colors.blue[400]),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (contex) {
                    return Setting();
                  }));
                },
              ),
            ),
            Card(
              elevation: 10,
              child: ListTile(
                horizontalTitleGap: 10,
                autofocus: true,
                title: Text("Qr-Pdf Preparation", style: Style.style1),
                leading: Icon(Icons.settings, color: Colors.blue[400]),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (contex) {
                    return QrPdf();
                  }));
                },
              ),
            ),
             Card(
              elevation: 10,
              child: ListTile(
                horizontalTitleGap: 10,
                autofocus: true,
                title: Text("Logout", style: Style.style1),
                leading: Icon(Icons.settings, color: Colors.blue[400]),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (contex) {
                    return Login();
                  }));
                },
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Home();
          }));
          return Future.value(true);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: QRView(
                  key: key,
                  onQRViewCreated: onQRViewCreated,
                  overlayMargin: EdgeInsets.all(2),
                  overlay: QrScannerOverlayShape(
                    borderColor: Colors.red,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: 300,
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
                          '$qrText ሽያጩ በትክክል ተካሂዶል',
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
                  onChanged: (val) {},
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search_outlined),
                      onPressed: () {},
                    ),
                    labelText: "የእቃውን አይነት ያስገቡ",
                    labelStyle: Style.style1,
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
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
            label: 'ዋና',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: 'የእቃዎች ዝርዝር',
            // title:
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.deepPurpleAccent,
            icon: Icon(Icons.report),
            label: 'ዕለታዊ የሽያጭ ሪፖርት',
            // title:
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Home();
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
    );
  }

  @override
  void dispose() {
    super.dispose();
    // QRcontroler.dispose();
  }

  void onQRViewCreated(QRViewController controller) {
    this.QRcontroler = controller;
    controller.scannedDataStream.listen((scanData) async {
      var random = Random();
      var tID = random.nextInt(1000000);
      // var ecodedString = json.encode(scanData.code);
      // print(ecodedString);
      Map itemList = json.decode(scanData.code);
      // print(itemList);
      if (itemList.isEmpty) {}
      var today = Dates.today;
      var salesPerson = 'Meshu';
      var itemID = itemList['itemID'];
      itemList['salesPerson'] = salesPerson;
      itemList['salesDate'] = today;
      Map item = itemBox.get(itemID);
      var itemAmount = item['amount'].toString();
      if (item == null) {
        QRcontroler.pauseCamera();
        setState(() {
          finalMessage = "ይቅርታ " +
              itemList['brandName'] +
              " ባለ " +
              itemList['size'] +
              " ቁጥር ሲስትም ላይ ማግኝት አልተችለም፤ እባከወትን ማናጀሩን ያናግሩ፡፡";
          isFinished = true;
        });
      } else if (int.parse(itemAmount) > 0) {
        QRcontroler.pauseCamera();
        await transactionBox.put("T$tID", itemList);
        if (transactionBox.containsKey("T$tID")) {
          item['amount'] = (int.parse(itemAmount)) - 1;
          item["amountSold"] = (int.parse(itemAmount)) + 1;
          item['updateStatus'] = 'yes';
          itemBox.put(itemID, item);
          setState(() {
            qrText = itemList['brandName'];
            isSuccess = true;
          });
          // Timer(Duration(seconds: 10), () {
          //   Navigator.push(context, MaterialPageRoute(builder: (context) {
          //     return Home();
          //   }));
          // });
        }
      }
      //
      else {
        QRcontroler.pauseCamera();
        setState(() {
          finalMessage = itemList['brandName'] +
              " ባለ " +
              itemList['size'] +
              " ቁጥር ተሸጦ አልቆል";
          isFinished = true;
        });
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
