import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:boticshop/Utility/Boxes.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Utility {
  var itemBox = Hive.box("item");

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
              data: qr.toString(),
              padding: EdgeInsets.all(25),
              size: 250,
              version: 5,
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

  static void editItem(Map data, BuildContext context) {
    var catBox = Hive.box("categorie");
    var initValue = data['catName'];
    var formKey = GlobalKey<FormState>();
    var brandController = TextEditingController();
    var sizeController = TextEditingController();
    var buyPricesController = TextEditingController();
    var soldPricesController = TextEditingController();
    var amountController = TextEditingController();

    List<DropdownMenuItem> items = [];
    var list = catBox.values.toList();
    items.add(DropdownMenuItem(
      child: Text(initValue),
      value: initValue,
    ));
    list.forEach((element) {
      if (initValue != element['catName']) {
        items.add(DropdownMenuItem(
          child: Text(element['catName']),
          value: element['catName'],
        ));
      }
    });

    showModalBottomSheet(
        enableDrag: false,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.8,

            // maxChildSize: 0.9,
            // minChildSize: 0.8,
            builder: (BuildContext context, ScrollController scrollController) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                    key: formKey,
                    child: ListView(
                      children: [
                        Row(
                          children: [
                            Text(
                              "የእቃው ምድብ",
                              style: Style.style1,
                            ),
                            Spacer(),
                            DropdownButton(
                              dropdownColor: Colors.deepPurple,
                              iconSize: 40,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                              items: items,
                              value: initValue,
                              onChanged: (val) {
                                // setState(() {
                                //   initVal = val;
                                // });
                              },
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: TextFormField(
                            controller: brandController
                              ..text = data['brandName'],
                            autofocus: true,
                            onChanged: (val) {
                              if (formKey.currentState.validate()) {}
                            },
                            // initialValue: data['brandName'],
                            validator: (val) {
                              if (val.isEmpty) {
                                return "እባክወትን ባዶ ቦታው ይሙሉ";
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                labelText: "የእቃው አይነት",
                                hintText: 'Like. Nike and addidass',
                                border: OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: TextFormField(
                            controller: sizeController..text = data['size'],
                            textInputAction: TextInputAction.next,
                            onChanged: (val) {
                              if (formKey.currentState.validate()) {}
                            },
                            validator: (val) {
                              if (val.isEmpty) {
                                return "እባክወትን ባዶ ቦታው ይሙሉ";
                              }
                              return null;
                            },
                            textCapitalization: TextCapitalization.characters,
                            decoration: InputDecoration(
                                labelText: "የእቃው ቁጥር",
                                hintText: 'Like. XL, XXL or 42 ,41',
                                border: OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: TextFormField(
                            controller: buyPricesController
                              ..text = data['buyPrices'],
                            textInputAction: TextInputAction.next,
                            onChanged: (val) {
                              if (formKey.currentState.validate()) {}
                            },
                            validator: (val) {
                              if (val.isEmpty) {
                                return "እባክወትን ባዶ ቦታው ይሙሉ";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: "የተገዛበት ዋጋ",
                                hintText: 'Like. 2000',
                                border: OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: TextFormField(
                            controller: soldPricesController
                              ..text = data['soldPrices'],
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              if (formKey.currentState.validate()) {}
                            },
                            validator: (val) {
                              if (val.isEmpty) {
                                return "እባክወትን ባዶ ቦታው ይሙሉ";
                              } else if (double.tryParse(val) == null) {
                                return 'እባክወትን ቁጥር ብቻ ያስገቡ';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: "መሽጫ ዋጋ",
                                hintText: 'Like. 2000',
                                border: OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: TextFormField(
                            controller: amountController..text = data['amount'],
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              if (formKey.currentState.validate()) {}
                            },
                            validator: (val) {
                              if (val.isEmpty) {
                                return "እባክወትን ባዶ ቦታው ይሙሉ";
                              } else if (int.tryParse(val) == null)
                                return 'እባክወትን ቁጥር ብቻ ያስገቡ';

                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: "የእቃው ብዛት ",
                                hintText: 'Like. 20',
                                border: OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState.validate()) {
                              var bPrices = int.parse(buyPricesController.text);
                              var sPrices =
                                  int.parse(soldPricesController.text);
                              if (sPrices <= bPrices) {
                                Utility.showSnakBar(
                                    context,
                                    "የመሽጫ ዋጋው ከተገዛበት በ ${bPrices - sPrices} ብር ያነስ ነው እባክወትን ማስተካከያ ያድርጉ",
                                    Colors.red);
                                // Navigator.of(context).pop();
                                // _focusNode.requestFocus();
                              }

                              // else if (initVal == "Select") {
                              //   Utility.showSnakBar(
                              //       context, "እባክውትን የእቃውን ምድብ ይምርጦ", Colors.red);
                              // }

                              else {
                                var random = Random();
                                var itemID = random.nextInt(1000000);
                                Map itemMap = {
                                  'itemID': '$itemID',
                                  'brandName': brandController.text,
                                  // 'catName': initVal,
                                  'size': sizeController.text,
                                  'buyPrices': buyPricesController.text,
                                  'soldPrices': soldPricesController.text,
                                  'amount': amountController.text,
                                  'insertStatus': 'no',
                                  'updateStatus': 'no',
                                  'deleteStatus': 'no'
                                };
                                var qr = {
                                  'itemID': '$itemID',
                                  'brandName': brandController.text,
                                  'size': sizeController.text,
                                  'buyPrices': buyPricesController.text,
                                  'soldPrices': soldPricesController.text,
                                  'amount': '1',
                                };

                                // itemBox.put(itemID, itemMap);
                                // var isKey = itemBox.containsKey(itemID);

                                // if (isKey) {
                                //   // print('Size=${itemBox.length}');
                                //   Utility.showSnakBar(context, "በትክክል ተመዝግቦል1!!",
                                //       Colors.greenAccent);
                                // } else {
                                //   Utility.showSnakBar(
                                //       context,
                                //       "አልተመዘገበም እባክወትን ለእርዳታ ወደ 0980631983 ይደወሉ ",
                                //       Colors.redAccent);
                                // }
                                // if (isQR) {
                                //   var image = await screenshotController
                                //       .captureFromWidget(
                                //           Utility.qrCodetoImage(qr));
                                //   await saveToGalary(image, itemID);
                                //   // print('your paths=$path');
                                // }
                              }
                            }
                          },
                          child: Text("Update"),
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(5),
                              elevation: 8,
                              textStyle: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              primary: Colors.deepPurple,
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                      ],
                    )),
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
}
