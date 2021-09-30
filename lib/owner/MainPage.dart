import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/login.dart';
import 'package:boticshop/Utility/setting.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:boticshop/owner/Home.dart';
import 'package:boticshop/owner/MonthlyReport.dart';
import 'package:boticshop/owner/RequiredItem.dart';
import 'package:boticshop/owner/Transaction.dart';
import 'package:boticshop/owner/WeeklyReport.dart';
import 'package:boticshop/owner/asset.dart';
import 'package:boticshop/owner/categorie.dart';
import 'package:boticshop/owner/expenes.dart';
import 'package:boticshop/owner/item.dart';
import 'package:boticshop/owner/itemList.dart';
import 'package:boticshop/owner/store_level.dart';
import 'package:boticshop/owner/useraccont.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MainPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Hive.box('setting').get("orgName")),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.deepPurple,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white60,
          selectedLabelStyle: TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(
              color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
          iconSize: 25,
          elevation: 10,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'ዋና',
              // label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
              label: 'የእቃዎች ዝርዝር',
              // label: 'Item List',
              // title:
            ),

            BottomNavigationBarItem(
              backgroundColor: Colors.deepPurpleAccent,
              icon: Icon(Icons.report),
              label: 'ዕለታዊ ሽያጭ',
              // label: 'Daily Sales',

              // title:
            ),
            // BottomNavigationBarItem(
            //   backgroundColor: Colors.deepPurpleAccent,
            //   icon: Icon(Icons.report),
            //   // label: 'ዕለታዊ የሽያጭ ሪፖርት',
            //   label: 'inpox',
            //   // title:
            // ),
          ],
          currentIndex: 0,
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
            } else if (index == 3) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return Transaction();
              }));
            }
          },
        ),
        body: ListView(children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return Home();
                  }));
                },
                icon: Icon(Icons.qr_code_scanner_outlined),
                label: Text('Scan (መሸጫ)'),
                style: ElevatedButton.styleFrom(primary: Colors.blue),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: Utility.getBoxDecoration(),
              child: Column(
                children: [
                  Text(
                    "ንብረት አስተዳደር",
                    style: Style.mainStyle1,
                  ),
                  Divider(
                    color: Colors.deepPurpleAccent,
                    thickness: 1,
                  ),
                  // GridView(
                  //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //       crossAxisCount: 2),
                  //       children: [
                  //           OutlinedButton(
                  //         onPressed: () {},
                  //         child: Text("ምድብ ያክሉ\n Add Category")),
                  //     OutlinedButton(
                  //         onPressed: () {},
                  //         child: Text("ምድብ ያክሉ\n Add Category")),
                  //       ],
                  // ),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    addAutomaticKeepAlives: true,
                    childAspectRatio: 4 / 2,
                    // crossAxisSpacing: 5,
                    children: [
                      Card(
                        margin: EdgeInsets.all(5),
                        elevation: 10,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          title: Text(
                            "ምድብ ያክሉ",
                            style: Style.mainStyle1,
                          ),
                          subtitle: Text(
                            "Add Category",
                            style: Style.mainStyle2,
                          ),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (contex) {
                              return Addcategorie();
                            }));
                          },
                        ),
                      ),
                      Card(
                        elevation: 10,
                        child: ListTile(
                          autofocus: true,
                          title: Text("አዲስ እቃ ", style: Style.mainStyle1),
                          subtitle:
                              Text("Add New Product", style: Style.mainStyle2),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (contex) {
                              return Item();
                            }));
                          },
                        ),
                      ),
                      Card(
                        elevation: 10,
                        child: ListTile(
                          horizontalTitleGap: 10,
                          autofocus: true,
                          title: Text(
                            "የእቃ ብዛት",
                            style: Style.mainStyle1,
                          ),
                          subtitle:
                              Text("Product Category", style: Style.mainStyle2),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return StoreLevel();
                            }));
                          },
                        ),
                      ),
                      Card(
                        elevation: 10,
                        child: ListTile(
                          tileColor: Colors.white,
                          horizontalTitleGap: 10,
                          autofocus: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          title: Text("የእቃ ዝርዝር", style: Style.mainStyle1),
                          subtitle:
                              Text("Product List", style: Style.mainStyle2),
                          // leading: Icon(
                          //   Icons.list_alt_outlined,
                          //   color: Colors.deepPurpleAccent,
                          // ),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ItemList();
                            }));
                          },
                        ),
                      ),
                      Card(
                        elevation: 10,
                        child: ListTile(
                          horizontalTitleGap: 10,
                          autofocus: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          title: Text("አስፈላጊ እቃዎች", style: Style.mainStyle1),
                          subtitle:
                              Text("Required Product", style: Style.mainStyle2),
                          // leading: Icon(
                          //   Icons.circle,
                          //   color: Colors.deepPurpleAccent,
                          // ),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return RequiredItem();
                            }));
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: Utility.getBoxDecoration(),
              child: Column(
                children: [
                  Text(
                    "የሒሳብ አስተዳደር ",
                    style: Style.mainStyle1,
                  ),
                  Divider(
                    color: Colors.deepPurpleAccent,
                    thickness: 1,
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    addAutomaticKeepAlives: true,
                    childAspectRatio: 4 / 2,
                    physics: ClampingScrollPhysics(),
                    children: [
                      Card(
                        elevation: 10,
                        child: ListTile(
                          title: Text("ውጭ መመዝገቢያ ", style: Style.mainStyle1),
                          subtitle:
                              Text("Add Expeness ", style: Style.mainStyle2),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return Expeness();
                            }));
                          },
                        ),
                      ),
                      Card(
                        elevation: 10,
                        child: ListTile(
                          horizontalTitleGap: 12,
                          autofocus: true,
                          title: Text("አጠቃላይ ንብረት", style: Style.mainStyle2),
                          subtitle: Text(
                            "Total Asset",
                            style: Style.mainStyle1,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return Asset();
                            }));
                          },
                        ),
                      ),
                      Card(
                        elevation: 10,
                        child: ListTile(
                          horizontalTitleGap: 12,
                          title: Text("ሳምንታዊ ሪፖርት", style: Style.mainStyle1),
                          subtitle:
                              Text("Weekliy Report", style: Style.mainStyle2),
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
                          title: Text("ወራሃዊ ሪፖርት", style: Style.mainStyle1),
                          subtitle:
                              Text("Monthliy Report", style: Style.mainStyle2),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return MonthlyTransaction();
                            }));
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          horizontalTitleGap: 10,
                          autofocus: true,
                          title: Text("የብድር አስተዳደር", style: Style.mainStyle2),
                          subtitle: Text("Add Debt", style: Style.mainStyle1),
                          onTap: () {},
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: Utility.getBoxDecoration(),
              child: Column(
                children: [
                  Text(
                    "ሰራተኞች",
                    style: Style.mainStyle1,
                  ),
                  Divider(
                    color: Colors.deepPurpleAccent,
                    thickness: 1,
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    childAspectRatio: 4 / 2,
                    addAutomaticKeepAlives: true,
                    crossAxisCount: 2,
                    children: [
                      Card(
                        elevation: 10,
                        child: ListTile(
                          horizontalTitleGap: 12,
                          title: Text("User Account ", style: Style.mainStyle1),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return Useraccount();
                            }));
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              decoration: Utility.getBoxDecoration(),
              child: Column(
                children: [
                  Text(
                    "Other",
                    style: Style.mainStyle1,
                  ),
                  Divider(
                    color: Colors.deepPurpleAccent,
                    thickness: 1,
                  ),
                  GridView.count(
                    childAspectRatio: 4 / 2,
                    addAutomaticKeepAlives: true,
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    children: [
                      Card(
                        elevation: 10,
                        child: ListTile(
                          horizontalTitleGap: 10,
                          autofocus: true,
                          title: Text("Setting", style: Style.mainStyle1),
                          // leading: Icon(Icons.settings, color: Colors.blue[400]),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (contex) {
                              return Setting();
                            }));
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ]));
    // SliverGrid(delegate: delegate, gridDelegate: gridDelegate)
    // ],
  }
}
