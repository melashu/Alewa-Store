import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/date.dart';
import 'package:boticshop/Utility/drawer.dart';
import 'package:boticshop/Utility/setting.dart';
import 'package:boticshop/Utility/storage.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:boticshop/owner/Home.dart';
import 'package:boticshop/owner/MonthlyReport.dart';
import 'package:boticshop/owner/WeeklyReport.dart';
import 'package:boticshop/owner/asset.dart';
import 'package:boticshop/owner/categorie.dart';
import 'package:boticshop/owner/debt.dart';
import 'package:boticshop/owner/expenes.dart';
import 'package:boticshop/owner/item.dart';
import 'package:boticshop/owner/itemList.dart';
import 'package:boticshop/owner/loweritem.dart';
import 'package:boticshop/owner/payment.dart';
import 'package:boticshop/owner/store_level.dart';
import 'package:boticshop/owner/useraccont.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );
  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        switchLabelPosition: true,
        animatedIcon: AnimatedIcons.menu_close,
        label: Text("Contact Us"),
        child: Icon(Icons.message_outlined),
        overlayOpacity: 0.6,
        animationSpeed: 100,
        children: [
          SpeedDialChild(
              backgroundColor: Colors.blue,
              labelBackgroundColor: Colors.redAccent,
              labelStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              child: Icon(Icons.facebook_outlined),
              label: "Facebook",
              foregroundColor: Colors.white,
              onTap: () async {
                // https://t.me/mounttechnology
                var url =
                    'https://www.facebook.com/Mount-Technology-106144511830363';
                if (await canLaunch(url)) {
                  await launch(url,
                      forceSafariVC: false,
                      statusBarBrightness: Brightness.dark,
                      forceWebView: true);
                } else {
                  Utility.showDangerMessage(
                      context, "ይቅርታ Facebookን መክፈት አልተቻለም");
                }
              }),
          SpeedDialChild(
              backgroundColor: Colors.blue,
              // labelBackgroundColor: Colors.blueAccent,
              labelBackgroundColor: Colors.redAccent,
              labelStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              child: Icon(Icons.youtube_searched_for_outlined),
              label: "YouTube",
              onTap: () async {
                //
                var url =
                    'https://www.youtube.com/channel/UCovij6lsj-lZp2AbTEtKHDQ';
                // var url = 'tel:$phone';
                if (await canLaunch(url)) {
                  await launch(url, forceSafariVC: false);
                } else {
                  Utility.showDangerMessage(
                      context, "ይቅርታ YouTubeን መክፈት አልተቻለም");
                }
              },
              foregroundColor: Colors.white),
          SpeedDialChild(
              backgroundColor: Colors.blue,
              labelBackgroundColor: Colors.redAccent,
              labelStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              child: Icon(Icons.table_chart),
              onTap: () async {
                //
                var url = 'https://t.me/mounttechnology';
                // var url = 'tel:$phone';
                if (await canLaunch(url)) {
                  await launch(url, forceSafariVC: false);
                } else {
                  Utility.showDangerMessage(
                      context, "ይቅርታ Telegramnን መክፈት አልተቻለም");
                }
              },
              label: "Telegram",
              foregroundColor: Colors.white),
          SpeedDialChild(
              backgroundColor: Colors.blue,
              labelBackgroundColor: Colors.redAccent,
              labelStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              child: Icon(Icons.phone),
              label: "Phone",
              foregroundColor: Colors.white,
              onTap: () async {
                var phone = '+251986806930';
                var url = 'tel:$phone';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  Utility.showDangerMessage(
                      context, "ይቅርታ ወደ $phone መደውል አልቻልኩም፡፡");
                }
              })
        ],
      ),

      // FloatingActionButton(
      //   backgroundColor: Colors.blueAccent,
      //   tooltip: 'Do you have Question?',
      //   elevation: 10,
      //   onPressed: () {
      //     Navigator.push(context, MaterialPageRoute(builder: (contex) {
      //       return Item();
      //     }));
      //   },
      //   child: Icon(Icons.message_outlined),
      // ),
      // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      bottomNavigationBar: Drawers.getBottomNavigationBar(context, 0),
      // BottomNavigationBarItem(
      //   backgroundColor: Colors.deepPurpleAccent,
      //   icon: Icon(Icons.report),
      //   // label: 'ዕለታዊ የሽያጭ ሪፖርት',
      //   label: 'inpox',
      //   // title:
      // ),
      // ],
      // currentIndex: 0,
      // onTap: (index) {
      //   if (index == 0) {
      //     Navigator.push(context, MaterialPageRoute(builder: (context) {
      //       return MainPage();
      //     }));
      //   } else if (index == 1) {
      //     Navigator.push(context, MaterialPageRoute(builder: (context) {
      //       return ItemList();
      //     }));
      //   } else if (index == 2) {
      //     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      //       return Transaction();
      //     }));
      //   } else if (index == 3) {
      //     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      //       return Transaction();
      //     }));
      //   }
      // },
      // ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 100,
            decoration: Utility.getBoxDecoration(),
            child: Center(
                child: Text(
              "${Hive.box('setting').get("orgName").toString().toUpperCase()}\n@${Hive.box("setting").get("deviceUser")} እንኳን ደህና መጡ!\n ስዓት፡ ${Dates.time}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )),
          ),
        ),
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
                        subtitle: Text("Product List", style: Style.mainStyle2),
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
                        tileColor: Colors.white,
                        horizontalTitleGap: 10,
                        autofocus: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        title: Text("ዝቅተኛ እቃዎች", style: Style.mainStyle1),
                        subtitle:
                            Text("Lower Product", style: Style.mainStyle2),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Lower();
                          }));
                        },
                      ),
                    ),

                    // Card(
                    //   elevation: 10,
                    //   child: ListTile(
                    //     horizontalTitleGap: 10,
                    //     autofocus: true,
                    //     contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    //     title: Text("አስፈላጊ እቃዎች", style: Style.mainStyle1),
                    //     subtitle:
                    //         Text("Required Product", style: Style.mainStyle2),
                    //     // leading: Icon(
                    //     //   Icons.circle,
                    //     //   color: Colors.deepPurpleAccent,
                    //     // ),
                    //     onTap: () {
                    //       Navigator.push(context,
                    //           MaterialPageRoute(builder: (context) {
                    //         return RequiredItem();
                    //       }));
                    //     },
                    //   ),
                    // )
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
                      elevation: 10,
                      child: ListTile(
                        tileColor: Colors.white,
                        horizontalTitleGap: 10,
                        autofocus: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        title: Text("ብድር እና ዱቤ", style: Style.mainStyle1),
                        subtitle:
                            Text("Debt Management", style: Style.mainStyle2),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Debt();
                          }));
                        },
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
                        title: Text("My Profile", style: Style.mainStyle1),
                        trailing: Icon(Icons.people_alt_outlined,
                            color: Colors.blue[400]),
                        onTap: () async {
                          // String appName = _packageInfo.appName;
                          // String packageName = _packageInfo.packageName;
                          // String version = _packageInfo.version;
                          // String buildNumber = _packageInfo.buildNumber;
                          // print(" version " + version);
                          // print(" packageName " + packageName);
                          // print(" appName " + appName);
                          // print(" buildNumber " + buildNumber);
                        },
                      ),
                    ),
                    Card(
                      elevation: 10,
                      child: ListTile(
                        horizontalTitleGap: 10,
                        autofocus: true,
                        title: Text("Setting", style: Style.mainStyle1),
                        trailing: Icon(Icons.settings, color: Colors.blue[400]),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (contex) {
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
                        title: Text("Storage", style: Style.mainStyle1),
                        trailing: Icon(Icons.storage, color: Colors.blue[400]),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (contex) {
                            return Storage();
                          }));
                        },
                      ),
                    ),
                    Card(
                      elevation: 10,
                      child: ListTile(
                        horizontalTitleGap: 10,
                        autofocus: true,
                        title: Text("አባልነት ", style: Style.mainStyle1),
                        subtitle: Text("Membership ", style: Style.mainStyle2),
                        trailing: Icon(Icons.card_membership, color: Colors.blue[400]),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (contex) {
                            return Payment();
                          }));
                        },
                      ),
                    ),
                    Card(
                      elevation: 10,
                      child: ListTile(
                        horizontalTitleGap: 10,
                        autofocus: true,
                        title: Text("QR-Pdf Preparation", style: Style.mainStyle1),
                        trailing: Icon(Icons.document_scanner, color: Colors.blue[400]),
                        onTap: () {
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (contex) {
                          //   return Storage();
                          // }));
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 80,
        )
      ]),
    );
  }
}
