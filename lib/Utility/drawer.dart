import 'package:boticshop/Utility/setting.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:boticshop/owner/MainPage.dart';
import 'package:boticshop/owner/MonthlyReport.dart';
import 'package:boticshop/owner/Qr-Pdf.dart';
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
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'login.dart';

class Drawers {
  static Drawer getMainMenu(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              child: UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.people_outlined)),
                  accountName:
                      Text("Welecome ${Hive.box("setting").get('deviceUser')}"),
                  accountEmail: Text("working"))),
          Card(
            child: ListTile(
              autofocus: true,
              subtitle: Text("ቅርንጭፍ ያክሉ", style: Style.style2),
              title: Text(
                "Add Branch",
                style: Style.style1,
              ),
              leading: Icon(Icons.shop_two_outlined, color: Colors.blue[400]),
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (contex) {
                //   return QRViewExample();
                // }));
              },
            ),
          ),
          ExpansionTile(
            subtitle: Text("ንብረት አስተዳደር", style: Style.style2),
            tilePadding: EdgeInsets.only(left: 20),
            leading: Icon(Icons.inventory, color: Colors.blue[400]),
            title: Text("Inventory ", style: Style.style1),
            children: [
              Card(
                child: ListTile(
                  horizontalTitleGap: 10,
                  autofocus: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  subtitle: Text("ምድብ ያክሉ", style: Style.style2),
                  title: Text("Add Categorie", style: Style.style1),
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
                  subtitle: Text("አዲስ እቃ መመዝገቢያ", style: Style.style2),
                  title: Text("Register New Product", style: Style.style1),
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
                  subtitle: Text(
                    "የእቃ ብዛት",
                    style: Style.style2,
                  ),
                  title: Text("Product by Category", style: Style.style1),
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
                  subtitle: Text("የእቃ ዝርዝር", style: Style.style2),
                  title: Text("Product List", style: Style.style1),
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
                  subtitle: Text("አስፈላጊ እቃዎች", style: Style.style2),
                  title: Text("Required Product", style: Style.style1),
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
            subtitle: Text(
              "የሒሳብ አስተዳደር ",
              style: Style.style2,
            ),
            title: Text("Finance  ", style: Style.style1),
            leading: Icon(Icons.file_copy_outlined, color: Colors.blue[400]),
            children: [
              Card(
                child: ListTile(
                  horizontalTitleGap: 12,
                  subtitle: Text("የውጭ መመዝገቢያ ", style: Style.style2),
                  title: Text("Expeness Registration", style: Style.style1),
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
              Card(
                elevation: 10,
                child: ListTile(
                  horizontalTitleGap: 12,
                  autofocus: true,
                  subtitle: Text("አጠቃላይ ንብረት", style: Style.style2),
                  title: Text(
                    "Total Asset",
                    style: Style.style1,
                  ),
                  leading: Icon(Icons.assessment_outlined,
                      color: Colors.deepPurpleAccent),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return Asset();
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
                subtitle: Text(
                  "የሽያጭ ሪፖርት",
                  style: Style.style2,
                ),
                title: Text("Sales Reports", style: Style.style1),
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
                      subtitle: Text("ሳምንታዊ ሪፖርት", style: Style.style2),
                      title: Text("Weekliy Report", style: Style.style1),
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
                      subtitle: Text("ወራሃዊ ሪፖርት", style: Style.style2),
                      title: Text("Monthliy Report", style: Style.style1),
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
              subtitle: Text("የብድር አስተዳደር", style: Style.style2),
              title: Text("Debt Management", style: Style.style1),
              leading: Icon(Icons.control_point_duplicate_outlined,
                  color: Colors.blue[400]),
              onTap: () {},
            ),
          ),
          ExpansionTile(
            subtitle: Text(
              "የሰራተኞች አስተዳደር",
              style: Style.style2,
            ),
            title: Text("Employee Management", style: Style.style1),
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
                  leading:
                      Icon(Icons.view_week, color: Colors.deepPurpleAccent),
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
    );
  }

  static BottomNavigationBar getBottomNavigationBar(
      BuildContext context, int index) {
    return BottomNavigationBar(
      backgroundColor: Colors.blue,
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
          // label: 'Product List',
          // title:
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.deepPurpleAccent,
          icon: Icon(Icons.report),
          label: 'ዕለታዊ የሽያጭ ሪፖርት',
          // label: 'Daily Sales',

          // title:
        ),
        // BottomNavigationBarItem(
        //   backgroundColor: Colors.deepPurpleAccent,
        //   icon: Icon(Icons.report),
        //   // label: 'ዕለታዊ የሽያጭ ሪፖርት',
        //   label: 'Message',
        //   // title:
        // ),
      ],
      currentIndex: index,
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
    );
  }

  static CurvedNavigationBar getNaviagtedBar() {
    return CurvedNavigationBar(
        items: [
          IconButton(onPressed: () {}, icon: Icon(Icons.home)),
          IconButton(onPressed: () {}, icon: Icon(Icons.list)),
          IconButton(onPressed: () {}, icon: Icon(Icons.facebook))


          
          ],
        onTap: (index){

        },
        );
  }
}
