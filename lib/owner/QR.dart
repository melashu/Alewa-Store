


void main(List<String> args) {
  print("Melashu");
}


// import 'dart:io';

// import 'package:boticshop/Utility/setting.dart';
// import 'package:boticshop/Utility/style.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// // import 'package:flutter_qrcode_scanner/flutter_qrcode_scanner.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// import 'Home.dart';
// import 'categorie.dart';
// import 'item.dart';
// import 'itemList.dart';

// void main() => runApp(MaterialApp(home: QRViewExample()));


// class QRViewExample extends StatefulWidget {
//   const QRViewExample({
//     Key key,
//   }) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _QRViewExampleState();
// }

// class _QRViewExampleState extends State<QRViewExample> {
//   var qrText = '';

//   QRViewController controller;
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   var itemBox = Hive.box("item");
//   var dataRow = <DataRow>[];
//     // String qrText = '';
//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller?.pauseCamera();
//     } else if (Platform.isIOS) {
//       controller?.resumeCamera();
//     }
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     //   if (Platform.isAndroid) {
//     //   controller.pauseCamera();
//     // } else if (Platform.isIOS) {
//     //   controller.resumeCamera();
//     // }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//      appBar: AppBar(
//         actions: [
//           TextButton(onPressed: () {}, child: Text("Logout")),
//         ],
//         title: Text(
//           Hive.box("setting").get("orgName"),
//           style: Style.style1,
//         ),
//         elevation: 10,
//         primary: true,
//       ),
//       floatingActionButton: FloatingActionButton(
//         elevation: 10,
//         onPressed: () {
//           Navigator.push(context, MaterialPageRoute(builder: (contex) {
//             return Item();
//           }));
//         },
//         child: Icon(Icons.add_shopping_cart_outlined),
//       ),
//       floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
//       drawer: Drawer(
//         child: ListView(
//           children: [
//             DrawerHeader(
//                 decoration: BoxDecoration(color: Colors.white),
//                 child: UserAccountsDrawerHeader(
//                     currentAccountPicture: CircleAvatar(
//                         radius: 20,
//                         backgroundColor: Colors.white,
//                         child: Icon(Icons.people_outlined)),
//                     accountName: Text("Meshu"),
//                     accountEmail: Text("working"))),
//             Card(
//               child: ListTile(
//                 autofocus: true,
//                 title: Text("Add Branch"),
//                 subtitle: Text(""),
//                 leading: Icon(Icons.shop_two_outlined, color: Colors.blue[400]),
//                 onTap: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (contex) {
//                     return QRViewExample();
//                   }));
//                 },
//               ),
//             ),
//             ExpansionTile(
//               title: Text("ንብረት አስተዳደር", style: Style.style1),
//               tilePadding: EdgeInsets.only(left: 20),
//               leading: Icon(Icons.inventory, color: Colors.blue[400]),
//               subtitle: Text("Inventory Management"),
//               children: [
//                 Card(
//                   child: ListTile(
//                     horizontalTitleGap: 10,
//                     autofocus: true,
//                     contentPadding: EdgeInsets.symmetric(horizontal: 20),
//                     title: Text("Add Categorie"),
//                     subtitle: Text(""),
//                     leading: Icon(Icons.category_outlined,
//                         color: Colors.deepPurpleAccent),
//                     onTap: () {
//                       Navigator.push(context,
//                           MaterialPageRoute(builder: (contex) {
//                         return Addcategorie();
//                       }));
//                     },
//                   ),
//                 ),
//                 Card(
//                   child: ListTile(
//                     horizontalTitleGap: 10,
//                     autofocus: true,
//                     contentPadding: EdgeInsets.symmetric(horizontal: 20),
//                     title: Text("አዲስ እቃ መመዝገቢያ", style: Style.style1),
//                     subtitle: Text("Register New Item"),
//                     leading: Icon(Icons.add_box_outlined,
//                         color: Colors.deepPurpleAccent),
//                     onTap: () {
//                       Navigator.push(context,
//                           MaterialPageRoute(builder: (contex) {
//                         return Item();
//                       }));
//                     },
//                   ),
//                 ),
//                 Card(
//                   child: ListTile(
//                     horizontalTitleGap: 10,
//                     autofocus: true,
//                     contentPadding: EdgeInsets.symmetric(horizontal: 20),
//                     title: Text(
//                       "የእቃ ብዛት",
//                       style: Style.style1,
//                     ),
//                     subtitle: Text(""),
//                     leading: Icon(Icons.store_outlined,
//                         color: Colors.deepPurpleAccent),
//                     onTap: () {
//                       // Navigator.push(context,
//                       //     MaterialPageRoute(builder: (context) {
//                       //   return ItemList();
//                       // }));
//                     },
//                   ),
//                 ),
//                 Card(
//                   child: ListTile(
//                     horizontalTitleGap: 10,
//                     autofocus: true,
//                     contentPadding: EdgeInsets.symmetric(horizontal: 20),
//                     title: Text("የእቃ ዝርዝር", style: Style.style1),
//                     subtitle: Text(""),
//                     leading: Icon(
//                       Icons.list_alt_outlined,
//                       color: Colors.deepPurpleAccent,
//                     ),
//                     onTap: () {
//                       Navigator.push(context,
//                           MaterialPageRoute(builder: (context) {
//                         return ItemList();
//                       }));
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             ExpansionTile(
//               title: Text(
//                 "የሒሳብ አስተዳደር ",
//                 style: Style.style1,
//               ),
//               subtitle: Text("Finacial Management"),
//               leading: Icon(Icons.file_copy_outlined, color: Colors.blue[400]),
//               children: [
//                 Card(
//                   child: ListTile(
//                     horizontalTitleGap: 12,
//                     title: Text("የውጭ መመዝገቢያ ", style: Style.style1),
//                     subtitle: Text("Register Expeness"),
//                     leading: Icon(
//                       Icons.money_off,
//                       color: Colors.deepPurpleAccent,
//                     ),
//                     onTap: () {},
//                   ),
//                 ),
//                 ExpansionTile(
//                   title: Text("ትርፍ እና ኪሳራ", style: Style.style1),
//                   subtitle: Text("Income Statement"),
//                   leading: Icon(
//                     Icons.album_rounded,
//                     color: Colors.deepPurpleAccent,
//                   ),
//                   tilePadding: EdgeInsets.only(left: 20),
//                   children: [
//                     Card(
//                       elevation: 10,
//                       child: ListTile(
//                         horizontalTitleGap: 12,
//                         autofocus: true,
//                         title: Text("ዕለታዊ ሪፖርት", style: Style.style1),
//                         subtitle: Text("Daily Report"),
//                         leading: Icon(Icons.report, color: Colors.orangeAccent),
//                         contentPadding: EdgeInsets.symmetric(horizontal: 20),
//                         onTap: () {},
//                       ),
//                     ),
//                     Card(
//                       elevation: 5,
//                       child: ListTile(
//                         horizontalTitleGap: 12,
//                         title: Text("ሳምንታዊ ሪፖርት", style: Style.style1),
//                         subtitle: Text("Weekliy Report"),
//                         leading:
//                             Icon(Icons.view_week, color: Colors.orangeAccent),
//                         contentPadding: EdgeInsets.symmetric(horizontal: 20),
//                         onTap: () {},
//                       ),
//                     ),
//                     Card(
//                       elevation: 10,
//                       child: ListTile(
//                         horizontalTitleGap: 12,
//                         title: Text("ወራሃዊ ሪፖርት", style: Style.style1),
//                         subtitle: Text("Monthliy Report"),
//                         leading:
//                             Icon(Icons.next_week, color: Colors.orangeAccent),
//                         contentPadding: EdgeInsets.symmetric(horizontal: 20),
//                         onTap: () {},
//                       ),
//                     ),
//                   ],
//                 ),
//                 ExpansionTile(
//                   title: Text(
//                     "የሽያጭ ሪፖርት",
//                     style: Style.style1,
//                   ),
//                   subtitle: Text("Sales Report"),
//                   leading: Icon(
//                     Icons.album_rounded,
//                     color: Colors.deepPurpleAccent,
//                   ),
//                   tilePadding: EdgeInsets.only(left: 20),
//                   children: [
//                     Card(
//                       elevation: 10,
//                       child: ListTile(
//                         horizontalTitleGap: 12,
//                         autofocus: true,
//                         title: Text("ዕለታዊ ሪፖርት", style: Style.style1),
//                         subtitle: Text("Daily Report"),
//                         leading: Icon(Icons.report, color: Colors.orangeAccent),
//                         contentPadding: EdgeInsets.symmetric(horizontal: 20),
//                         onTap: () {},
//                       ),
//                     ),
//                     Card(
//                       elevation: 5,
//                       child: ListTile(
//                         horizontalTitleGap: 12,
//                         title: Text("ሳምንታዊ ሪፖርት", style: Style.style1),
//                         subtitle: Text("Weekliy Report"),
//                         leading:
//                             Icon(Icons.view_week, color: Colors.orangeAccent),
//                         contentPadding: EdgeInsets.symmetric(horizontal: 20),
//                         onTap: () {},
//                       ),
//                     ),
//                     Card(
//                       elevation: 10,
//                       child: ListTile(
//                         horizontalTitleGap: 12,
//                         title: Text("ወራሃዊ ሪፖርት", style: Style.style1),
//                         subtitle: Text("Monthliy Report"),
//                         leading:
//                             Icon(Icons.next_week, color: Colors.orangeAccent),
//                         contentPadding: EdgeInsets.symmetric(horizontal: 20),
//                         onTap: () {},
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//             Card(
//               child: ListTile(
//                 horizontalTitleGap: 10,
//                 autofocus: true,
//                 title: Text("የብድር አስተዳደር", style: Style.style1),
//                 subtitle: Text("Debt Management"),
//                 leading: Icon(Icons.control_point_duplicate_outlined,
//                     color: Colors.blue[400]),
//                 onTap: () {},
//               ),
//             ),
//             Card(
//               elevation: 10,
//               child: ListTile(
//                 horizontalTitleGap: 10,
//                 autofocus: true,
//                 title: Text("Setting", style: Style.style1),
//                 leading: Icon(Icons.settings, color: Colors.blue[400]),
//                 onTap: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (contex) {
//                     return Setting();
//                   }));
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//        bottomNavigationBar: BottomNavigationBar(
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home_outlined),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.account_circle),
//             label: 'My Profile',
//           ),
//         ],
//         currentIndex: 0,
//         onTap: (index) {
//           if (index == 0) {
//             Navigator.push(context, MaterialPageRoute(builder: (context) {
//               return Home();
//             }));
//           } else if (index == 1) {}
//         },
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             flex: 4,
//             child: QRView(
//               key: qrKey,
//               onQRViewCreated: _onQRViewCreated,
//               overlay: QrScannerOverlayShape(
//                 borderColor: Colors.red,
//                 borderRadius: 10,
//                 borderLength: 30,
//                 borderWidth: 10,
//                 cutOutSize: 300,
//               ),
//             ),
//           ),
          
//           Expanded(
//             flex: 1,
//             child: FittedBox(
//               fit: BoxFit.contain,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   Text('This is the result of scan: $qrText'),
//                 ],
//               ),
//             ),
//           ),
//           Divider(
//             thickness: 4,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               onChanged: (val) {},
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.search_outlined),
//                   onPressed: () {},
//                 ),
//                 labelText: "የእቃውን አይነት ያስገቡ",
//                 labelStyle: Style.style1,
//                 contentPadding: EdgeInsets.all(10),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(5.0),
//             child: SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: ValueListenableBuilder(
//                   valueListenable: itemBox.listenable(),
//                   builder: (context, box, _) {
//                     var data = box.values.toList();

//                     return dataTable(data);
//                   }),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   // bool _isFlashOn(String current) {
//   //   return flashOn == current;
//   // }

//   // bool _isBackCamera(String current) {
//   //   return backCamera == current;
//   // }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         qrText = scanData.code;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   Widget dataTable(data) {
//     dataRow.clear();

//     for (var itemMap in data) {
//       if ((int.parse(itemMap['amount']) > 0) &&
//           (itemMap['deleteStatus'] == 'no')) {
//         dataRow.add(DataRow(cells: [
//           DataCell(TextButton(onPressed: () {}, child: Text("Sell"))),
//           DataCell(Text("${itemMap['catName']}")),
//           DataCell(Text("${itemMap['brandName']}")),
//           DataCell(Text("${itemMap['size']}")),
//           DataCell(Text("${itemMap['itemID']}")),
//           DataCell(Text("${itemMap['amount']}")),
//           DataCell(Text("${itemMap['buyPrices']}")),
//           DataCell(Text("${itemMap['soldPrices']}")),
//         ]));
//       }
//     }
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: DataTable(
//         showBottomBorder: true,
//         columns: [
//           DataColumn(
//               label: Text(
//             "ማስተካከያ",
//             style: Style.style1,
//           )),
//           DataColumn(label: Text("የእቃው ምድብ", style: Style.style1)),
//           DataColumn(label: Text("የእቃው አይነት", style: Style.style1)),
//           DataColumn(label: Text("መጠን", style: Style.style1)),
//           DataColumn(label: Text("መለያ ቁጥር ", style: Style.style1)),
//           DataColumn(label: Text("ብዛት", style: Style.style1)),
//           DataColumn(label: Text("የተገዛበት ዋጋ ", style: Style.style1)),
//           DataColumn(label: Text("መሽጫ ዋጋ ", style: Style.style1)),
//         ],
//         rows: dataRow,
//       ),
//     );
//   }
// }
