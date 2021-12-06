import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:abushakir/abushakir.dart';
import 'package:boticshop/Utility/Boxes.dart';
import 'package:boticshop/Utility/date.dart';
import 'package:boticshop/Utility/location.dart';
import 'package:boticshop/Utility/report.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:boticshop/https/orgprof.dart';
import 'package:boticshop/owner/MainPage.dart';
import 'package:boticshop/owner/agreement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final monthlyFutureProvider = FutureProvider<double>((ref) {});

final monthlyStateProvider = StateProvider<double>((ref) {
  var totalstate = ref.watch(monthlyFutureProvider);
  var total = 0.0;
  totalstate.whenData((value) {
    total = value;
  });
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
                    (double.parse(row['soldPrices']));
                // (double.parse(row['soldPrices']) * int.parse(row['amount']));
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
        msg: "እባክዎትን ትንሽ ይጠብቁ",
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

  static void showDangerMessage(BuildContext context, String message) {
    DangerAlertBoxCenter(
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

  static Text getTitle() {
    return Text(
      Hive.box('setting').get("orgName").toString().toUpperCase(),
      style: TextStyle(fontSize: 18),
    );
  }

/**
 * 
 */
  static bool isPaymentDone() {
    var paymentBox = Hive.box('payment');
    var month = paymentBox.get("month");
    bool isDate;
    if (month == null) {
      isDate = false;
    } else {
      isDate = (EtDatetime.parse(Dates.today)
              .difference(EtDatetime.parse(month['date']))
              .inDays >=
          30);
    }
    return isDate;
  }

  static bool isValid() {
    var isSub = Hive.box("setting").get("isSubscribed");
    Map subInfo = Hive.box("setting").get("subInfo");
    bool isValid = (!isSub &&
        (EtDatetime.parse(Dates.today)
                .difference(EtDatetime.parse(subInfo['regDate']))
                .inDays ==
            subInfo['freeDay']));
    return isValid;
  }

  static void getValidationBox(BuildContext context) {
    Map subInfo = Hive.box("setting").get("subInfo");
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Warning Message",
              style: Style.style1,
            ),
            content: subInfo['isExtended']
                ? Text("እናመሰናለን፣ የሙከራ ጊዜዎትን ጭርስዋል፡፡ እባክዎት በቋሚነት አባል ይሆኑ፡፡")
                : Text(
                    "${subInfo['message']} ",
                    style: Style.mainStyle1,
                  ),
            elevation: 10,
            buttonPadding: EdgeInsets.all(5),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return Agre(
                        isForInfo: false,
                      );
                    }));
                  },
                  child: Text("ቋሚ አባል ልሁን")),
              subInfo['isExtended']
                  ? SizedBox()
                  : ElevatedButton(
                      onPressed: () {
                        subInfo['freeDay'] =
                            subInfo['freeDay'] + subInfo['exteraDay'];
                        subInfo['isExtended'] = true;
                        Hive.box("setting").put("subInfo", subInfo);
                        Navigator.of(context).pop();
                      },
                      child: Text("ለ ${subInfo['exteraDay']} ቀን ይራዘምልኝ")),
              ElevatedButton(
                  onPressed: () async {
                    var phone = '+251986806930';
                    var url = 'tel:$phone';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      showDangerMessage(
                          context, "ይቅርታ ወደ $phone መደውል አልቻልኩም፡፡");
                    }
                  },
                  child: Text("እርዳታ እፈልጋለሁ")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("አልፈልግም")),
            ],
          );
        });
  }

// ignore: slash_for_doc_comments
/***
 * this is for checking wether 
 * service renewal is done or not 
 * and asking for renewal 
 */
  static void setServicePayment(BuildContext context) {
    Map subInfo = Hive.box("payment").get("month");
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              " ወርሃዊ ክፍያ",
              style: Style.style1,
            ),
            content: !subInfo['isRequest']
                ? Text(
                    "እባክዎትን ወርሃዊ ክፍያዎትን በመክፈል አገልግልዎትን ያድሱ",
                    style: Style.mainStyle1,
                  )
                : Text(
                    "የክፍያ ማመልከቻዎ እየታየ ነው፡፡ እባክዎትን ለ1 ስዓት ያክል በትግስት ይጠብቁ፡፡",
                    style: Style.mainStyle1,
                  ),
            elevation: 10,
            buttonPadding: EdgeInsets.all(5),
            actions: [
              subInfo['isRequest']
                  ? ElevatedButton(
                      onPressed: () async {
                        if (await Utility.isConnection()) {
                          Utility.showProgress(context);
                          var val = await OrgProfHttp().isConfirmation(
                              Hive.box("setting").get("orgId"),
                              subInfo['monthID']);
                          if (val == 'yes') {
                            var orgId = Hive.box('setting').get("orgId");
                            var today = Dates.today;
                            Navigator.of(context).pop();
                            var random = Random();
                            var monthID = random.nextInt(1000000).toString();
                            var newAmount = await OrgProfHttp().getAgreement();
                            var result = await OrgProfHttp().inserPaymentInfo(
                                orgId, today, newAmount['amount'], monthID);
                            Utility.showProgress(context);
                            if (result) {
                              /**
                                       * Register the payment record on local 
                                       * device with paymentBox 
                                       */
                              var paymentBox = Hive.box('payment');
                              paymentBox.put('month', {
                                "date": today,
                                "isRequest": false,
                                "paidStatus": 'no',
                                "monthID": monthID,
                                "renewStatus": 'no',
                                "amount": newAmount['amount']
                              });
                              Utility.infoMessage(context,
                                  "እናመሰናለን ከ ቀን $today ጀምሮ እስከ ሚቀጥለው ወር ድርስ ታድሶለዎታል::");
                              Timer(Duration(seconds: 2), () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return MainPage();
                                }));
                              });
                            }
                          } else {
                            Navigator.of(context).pop();
                            Utility.successMessage(context,
                                'የክፍያ  ማመልከቻዎ እየታየ ነው፡፡ እባክዎትን ለ1 ስዓት ያክል በትዕግስት ይጠብቁ፡፡');
                          }
                        } else {
                          Utility.showDangerMessage(context,
                              "ይህን አገልግሎት በሚፈልጉበት ጊዜ wifi or Data ያስፈልገዉታል፡፡");
                        }
                      },
                      child: Text("ድጋሜ ያረጋግጡ"))
                  : ElevatedButton(
                      onPressed: () async {
                        if (await Utility.isConnection()) {
                          Utility.showProgress(context);
                          var val = await OrgProfHttp()
                              .request4PaymentConfirmation(
                                  Hive.box("setting").get("orgId"),
                                  subInfo['monthID']);
                          if (val) {
                            Navigator.of(context).pop();
                            subInfo['isRequest'] = true;
                            Hive.box("payment").put("month", subInfo);
                            successMessage(context,
                                'የክፍያ ማመልከቻዎ እየታየ ነው፡፡ እባክዎትን ለ1 ስዓት ያክል በትዕግስት ይጠብቁ፡፡');
                          } else {
                            showDangerMessage(context, "እባክዎትን ድጋሜ ይሞክሩ::");
                          }
                        } else {
                          Utility.showDangerMessage(context,
                              "ይህን አገልግሎት በሚፈልጉበት ጊዜ wifi or Data ያስፈልገዉታል፡፡");
                        }
                      },
                      child: Text("ለእድሳት ይጠይቁ")),
              ElevatedButton(
                  onPressed: () async {
                    var phone = '+251986806930';
                    var url = 'tel:$phone';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      showDangerMessage(
                          context, "ይቅርታ ወደ $phone መደውል አልቻልኩም፡፡");
                    }
                  },
                  child: Text("እባክዎትን ይህን ተጭነው ይደውሉ")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("አልፈልግም")),
            ],
          );
        });
  }

  // static Future<void> setCurrentWorkingLocation() async {
  //   var position = await Locations.getCurrentLocation();
  //   var latitude = position.latitude.toString();
  //   var longtitude = position.longitude.toString();

  //   var altitude = position.altitude.toString();
  //   print("Long==$longtitude and Latitude == $latitude and Alt == $altitude");
  //   var location = Hive.box('location');
  //   Map locationMap = {
  //     "latitude": latitude,
  //     "longtitude": longtitude,
  //     "altitude": altitude,
  //     "action": "locationUpdate",
  //     "orgId": Hive.box("setting").get("orgId")
  //   };
  //   location.put("location", locationMap);
  // }

  static Future<bool> isConnection() async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    var isCon = connectivityResult != ConnectivityResult.none;
    return isCon;
  }
}
