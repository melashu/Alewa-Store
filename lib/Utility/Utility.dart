import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:boticshop/Utility/Boxes.dart';
import 'package:boticshop/Utility/report.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
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
           Product Code: ${qr['itemID']}
           Product Name : ${qr['brandName']}
           Size:  ${qr['size']}
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

  static Future<bool> saveToGalary(Uint8List image, String itemID,
      [String pre]) async {
    await [Permission.storage].request();
    String path;
    path = pre == null ? '$itemID' : pre + "_" + '$itemID';
    var result =
        await ImageGallerySaver.saveImage(image, name: path, quality: 50);
    return result['isSuccess'];
  }

  static Widget showTotalAssetinBirr(BuildContext context) {
    var itemB = Utility().itemBox.values.toList();
    var totalBirr = 0.0;
    for (var i in itemB) {
      if (i['deleteStatus'] == 'no') {
        totalBirr = totalBirr +
            (double.parse(i['amount'].toString()) *
                double.parse(i['buyPrices']));
      }
    }
    return Center(
      child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              border: Border.all(
                color: Colors.deepPurpleAccent,
                width: 1,
              )),
          child: Text(
            "አጠቃላይ ያለው ንብረት በብር ሲተመን  $totalBirr ብር ነው፡፡ ",
            style: Style.style1,
            textAlign: TextAlign.center,
          )),
    );
  }

  static void showDialogBox(BuildContext context, String message, Color color) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            contentPadding: EdgeInsets.all(10),
            actions: [
              Center(
                  child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Ok',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                style: Style.smallButton,
              ))
            ],
            content: Text(
              message,
              style: Style.style1,
            ),
            backgroundColor: color,
          );
        });
  }

  static void showProgress(BuildContext context) {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(
        max: 100,
        msg: "Wait",
        backgroundColor: Colors.white,
        barrierDismissible: true,
        borderRadius: 20,
        msgColor: Colors.deepPurple,
        msgFontSize: 14,
        progressBgColor: Colors.white,
        progressType: ProgressType.valuable);
  }

  static Widget saveOrgProfile(Map orgMap, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: MediaQuery.of(context).size.width * .8,
        height: MediaQuery.of(context).size.height * .8,
        padding: EdgeInsets.all(15),
        // margin: EdgeInsets.only(top: 60),
        child: ListView(
          children: [
            Text("ይህ መረጃ ለሌላ ጊዜ ስለሚስፈልገዎ፡፡\n በጥንቃቂ ያስቀምጡ፡፡",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Divider(
              color: Colors.deepPurpleAccent,
              thickness: 1,
            ),
            Text(" የድርጅትዎ ስም፡ ${orgMap['orgName']}",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Divider(
              color: Colors.deepPurpleAccent,
              thickness: 1,
            ),
            Text(
              '''    
መታወቂያ (Company ID)፡ ${orgMap['orgId']}  

E-mail: ${orgMap['email']}

Phone 1: +251${orgMap['phone1']}

Phone 2: +251${orgMap['phone2']}

Username: ${orgMap['userName']}

Password: ${orgMap['password']}
                    ''',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.justify,
            ),
            Divider(
              color: Colors.deepPurpleAccent,
              thickness: 1,
            ),
            Text(
              "Generated By: Mount Digital Solution",
              style: TextStyle(
                  fontStyle: FontStyle.italic, fontWeight: FontWeight.w200),
            ),
            SizedBox(
              height: 1,
            ),
            Text(
              "Website: www.keteraraw.com\nEmail: meshu102@outlook.com",
              style: TextStyle(
                  fontStyle: FontStyle.italic, fontWeight: FontWeight.w200),
            ),
            SizedBox(
              height: 1,
            ),
            SizedBox(
              height: 1,
            ),
            Text(
              "Phone Number: \n+251980631983\n+251925989771\n+251925197526",
              style: TextStyle(
                  fontStyle: FontStyle.italic, fontWeight: FontWeight.w200),
            ),
          ],
        ),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.deepPurpleAccent, width: 1)),
      ),
    );
  }

  static void successMessage(BuildContext context, String message) {
    SuccessAlertBoxCenter(
        messageText: message,
        buttonColor: Colors.deepPurpleAccent,
        buttonText: 'Ok',
        context: context);
  }

  static void infoMessage(BuildContext context, String message) {
    InfoAlertBoxCenter(
      context: context,
      title: "Wifi / Mobile Data",
      infoMessage: message,
      buttonText: 'Ok',
      buttonColor: Colors.deepPurpleAccent,
      titleTextColor: Colors.deepPurple,
    );
  }

  static BoxDecoration getBoxDecoration() {
    return BoxDecoration(
      color: Colors.grey[200],
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.deepPurpleAccent, width: 1),
    );
  }
}
