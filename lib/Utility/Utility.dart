import 'dart:convert';
import 'dart:typed_data';
import 'package:boticshop/Utility/Boxes.dart';
import 'package:boticshop/Utility/report.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

// final monthlyFutureProvider = FutureProvider<double>((ref) {});

final monthlyStateProvider = StateProvider<double>((ref) {
  // var totalstate = ref.watch(monthlyFutureProvider);
  // var total = 0.0;
  // totalstate.whenData((value) {
  //   total = value;
  // });
  return Report.getDailyExpenessPerMonth() / 30;
});

class Utility {
  var itemBox = Hive.box("item");
  var expenes = Hive.box("expenes");
  static showSnakBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, style: Style.style1),
      elevation: 5,
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
          textColor: Colors.white,
          label: "Close",
          onPressed: () {
            ScaffoldMessengerState().removeCurrentSnackBar();
          }),
      backgroundColor: color,
      padding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(),
      duration: Duration(seconds: 8),
    ));
  }

  static void showConfirmDialog({BuildContext context, Map itemMap}) {
    var _focusNode = FocusNode();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Delete"),
            content: Text(" ማጥፋት ይፈልጋሉ?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("No"),
                focusNode: _focusNode,
                style: TextButton.styleFrom(
                    side: BorderSide(width: 1, color: Colors.lightBlueAccent)),
              ),
              TextButton(
                onPressed: () async {
                  var id = itemMap['itemID'];
                  itemMap['deleteStatus'] = 'yes';
                  Utility().itemBox.put(id, itemMap);
                  if (Utility().itemBox.containsKey(id)) {
                    Navigator.of(context).pop();
                    Utility.showSnakBar(
                        context, "በትክክል ተስርዞል", Colors.greenAccent);
                  } else {
                    Utility.showSnakBar(
                        context,
                        "አልተሰረዘም እባክወትን ለእርዳታ ወደ 0980631983 ይደወሉ ",
                        Colors.redAccent);
                  }
                },
                child: Text("Yes"),
                style: TextButton.styleFrom(
                    side: BorderSide(width: 1, color: Colors.lightBlueAccent)),
              )
            ],
          );
        });
  }

  static Widget qrCodetoImage(Map<String, String> qr) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: 250,
        height: 400,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(color: Colors.deepPurpleAccent, width: 1),
            color: Colors.white),
        child: Column(
          children: [
            QrImage(
              backgroundColor: Colors.grey,
              data: json.encode(qr),
              padding: EdgeInsets.all(25),
              size: 250,
              version: QrVersions.auto,
            ),
            Center(
              child: Text(
                '''
           መለያ ቁጥር: ${qr['itemID']}
           የእቃው አይነት: ${qr['brandName']}
           የእቃው መጠን:  ${qr['size']}
                         ''',
                style: TextStyle(color: Colors.red),
              ),
            )
          ],
        ),
      ),
    );
  }

  static Future<List> getListOf() async {
    var box = await Boxes.getItemBox();
    var itemList = box.keys.toList();
    List valueList;
    for (var i in itemList) {
      valueList.add(await box.get(i));
    }
    return valueList;
  }

  static void showTotalSales(
      {List data, BuildContext context, String date, double expenes}) {
    var total = Report.getDailyExpenessPerMonth() / 30;

    showModalBottomSheet(
        enableDrag: true,
        context: context,
        isScrollControlled: true,
        builder: (context) {

          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.8,
            builder: (BuildContext context, ScrollController scrollController) {

              var content = '';
              var totalBuy = 0.0;
              var totalSell = 0.0;
              data.forEach((row) {
                totalBuy = totalBuy +
                    (double.parse(row['buyPrices']) * int.parse(row['amount']));
                totalSell = totalSell +
                    (double.parse(row['soldPrices']) *
                        int.parse(row['amount']));

                content = content +
                    "\n የእቃው ስም፡ " +
                    row['brandName'] +
                    " : "
                        " የተገዛበት ዋጋ፡ " +
                    row['buyPrices'] +
                    " የተሽጠበት ዋጋ፡ " +
                    row['soldPrices'] +
                    " ብር ";
              });
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: Colors.deepPurpleAccent)),
                        child: Text(
                          date,
                          style: Style.style1,
                          textAlign: TextAlign.center,
                        )),
                    Divider(
                      thickness: 1,
                      color: Colors.deepPurpleAccent,
                    ),
                    Text(
                      content,
                      style: Style.style1,
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.deepPurpleAccent,
                    ),
                    Text(
                      "አጠቃላይ ሽያጭ: $totalSell ብር",
                      style: Style.style1,
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.deepPurpleAccent,
                    ),
                    Text(
                      "አጠቃላይ እቃው የተገዛበት: $totalBuy ብር",
                      style: Style.style1,
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.deepPurpleAccent,
                    ),
                    Text(
                      "አጠቃላይ ያልተጣራ ትርፍ: ${totalSell - totalBuy} ብር",
                      style: Style.style1,
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.deepPurpleAccent,
                    ),
                    Text('ወርሃዊ ወጭ፡  $total ብር', style: Style.style1),
                    Divider(
                      thickness: 1,
                      color: Colors.deepPurpleAccent,
                    ),
                    Text('ዕለታዊ ወጭ፡  $expenes ብር', style: Style.style1),
                    Divider(
                      thickness: 1,
                      color: Colors.deepPurpleAccent,
                    ),
                    Text(
                      'የተጣራ ትርፍ ${(totalSell - totalBuy) - (total + expenes)} ብር',
                      style: Style.style1,
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  static Future<String> saveToGalary(Uint8List image, String itemID,
      [String pre]) async {
    await [Permission.storage].request();
    String path;
    path = pre == null ? '$itemID' : pre + "_" + '$itemID';
    var result =
        await ImageGallerySaver.saveImage(image, name: path, quality: 50);
    print("Success ${result['isSuccess']}");
    return result['filePath'];
  }

  static void showTotalAssetinBirr(BuildContext context) {
    var itemB = Utility().itemBox.values.toList();
    var totalBirr = 0.0;
    for (var i in itemB) {
      if (i['deleteStatus'] == 'no') {
        totalBirr = totalBirr +
            (double.parse(i['amount'].toString()) *
                double.parse(i['buyPrices']));
      }
    }
    // totalBirr=double.parse(source)
    showModalBottomSheet(
        enableDrag: true,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.4,
            // minChildSize: 0.5,
            builder: (context, ScrollController scrollController) {
              return Padding(
                padding: EdgeInsets.all(5),
                child: Center(
                    child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: Colors.deepPurpleAccent)),
                        child: Text(
                          "አጠቃላይ ያለው ንብረት በብር ሲተመን  $totalBirr ብር ይሆናል፡፡ ",
                          style: Style.style1,
                          textAlign: TextAlign.center,
                        ))),
              );
            },
          );
        });
  }
}
