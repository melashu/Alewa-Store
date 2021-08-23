import 'dart:math';
import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/date.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:screenshot/screenshot.dart';

class Item extends StatefulWidget {
  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  var formKey = GlobalKey<FormState>();
  var brandController = TextEditingController();
  var sizeController = TextEditingController();
  var buyPricesController = TextEditingController();
  var soldPricesController = TextEditingController();
  var amountController = TextEditingController();
  var screenshotController = ScreenshotController();
  var itemBox = Hive.box('item');
  var itemCata = Hive.box('categorie');
  var brandFocus = FocusNode();
  String initVal = 'Select';
  var qrStatus = 'On';
  bool isQR = true;
  List<DropdownMenuItem> item = [];
  var _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    getItemMenu();
  }

  var qrData = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Hive.box("setting").get("orgName"),
          style: Style.style1,
        ),
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Screenshot(
          controller: screenshotController,
          child: ListView(
            children: [
              Text(
                "አዲስ የመጣን እቃ መመዝገቢያ ፎርም ",
                style: Style.style1,
              ),
              Divider(),
              Row(
                children: [
                  Spacer(),
                  Text('Qr Mode'),
                  isQR
                      ? IconButton(
                          icon: Icon(Icons.toggle_off),
                          iconSize: 50,
                          color: Colors.red,
                          onPressed: () {
                            setState(() {
                              isQR = false;
                              qrStatus = "Off";
                            });
                          })
                      : IconButton(
                          icon: Icon(Icons.toggle_on),
                          iconSize: 50,
                          onPressed: () {
                            setState(() {
                              isQR = true;
                              qrStatus = "On";
                            });
                          }),
                  Text(qrStatus)
                ],
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          children: [
                            Text(
                              "የእቃው ምድብ",
                              style: Style.style1,
                            ),
                            Spacer(),
                            DropdownButton(
                              dropdownColor: Colors.deepPurple,
                              iconSize: 40,
                              style: Style.dropDouwnStyle,
                              items: item,
                              value: initVal,
                              onChanged: (val) {
                                setState(() {
                                  initVal = val;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: TextFormField(
                          controller: brandController,
                          focusNode: brandFocus,
                          autofocus: true,
                          onChanged: (val) {
                            if (formKey.currentState.validate()) {}
                          },
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
                          controller: sizeController,
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
                          controller: buyPricesController,
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
                          controller: soldPricesController,
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
                          focusNode: _focusNode,
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
                          controller: amountController,
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
                    ],
                  )),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState.validate()) {
                    var bPrices = int.parse(buyPricesController.text);
                    var sPrices = int.parse(soldPricesController.text);
                    if (sPrices <= bPrices) {
                      Utility.showSnakBar(
                          context,
                          "የመሽጫ ዋጋው ከተገዛበት በ ${bPrices - sPrices} ብር ያነስ ነው እባክወትን ማስተካከያ ያድርጉ",
                          Colors.red);
                      // Navigator.of(context).pop();
                      _focusNode.requestFocus();
                    } else if (initVal == "Select") {
                      Utility.showSnakBar(
                          context, "እባክውትን የእቃውን ምድብ ይምርጦ", Colors.red);
                    } else {
                      var random = Random();
                      var itemID = random.nextInt(1000000);
                      Map itemMap = {
                        'itemID': 'Item_$itemID',
                        'userName': 'meshu',
                        'brandName': brandController.text,
                        'catName': initVal,
                        'createDate': Dates.today,
                        'size': sizeController.text,
                        'buyPrices': buyPricesController.text,
                        'soldPrices': soldPricesController.text,
                        'amount': amountController.text,
                        'amountSold': "0",
                        'insertStatus': 'no',
                        'updateStatus': 'no',
                        'deleteStatus': 'no'
                      };
                      var qr = {
                        'itemID': 'Item_$itemID',
                        'brandName': brandController.text,
                        'size': sizeController.text,
                        'buyPrices': buyPricesController.text,
                        'soldPrices': soldPricesController.text,
                        'amount': '1',
                      };

                      if (isQR) {
                        var image = await screenshotController
                            .captureFromWidget(Utility.qrCodetoImage(qr));
                        await Utility.saveToGalary(
                            image, "Item_$itemID" + "_" + brandController.text);
                      }

                      itemBox.put("Item_$itemID", itemMap);
                      var isKey = itemBox.containsKey("Item_$itemID");

                      if (isKey) {
                        // print('Size=${itemBox.length}');
                        Utility.showSnakBar(
                            context, "በትክክል ተመዝግቧል!", Colors.greenAccent);
                        // brandFocus.requestFocus();
                        // brandController.text = '';
                        // amountController.text = '';
                        // buyPricesController.text = '';
                        // soldPricesController.text = '';
                        // sizeController.text = '';
                        brandFocus.requestFocus();
                      } else {
                        Utility.showSnakBar(
                            context,
                            "አልተመዘገበም እባክወትን ለእርዳታ ወደ 0980631983 ይደወሉ ",
                            Colors.redAccent);
                      }
                    }
                  }
                },
                child: Text("Save"),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(5),
                    elevation: 8,
                    textStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    primary: Colors.deepPurple,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              Divider(
                thickness: 2,
                color: Colors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }

  void getItemMenu() {
    List<DropdownMenuItem> items = [];
    var list = itemCata.values.toList();
    items.add(DropdownMenuItem(
      child: Text("Select"),
      value: 'Select',
    ));
    list.forEach((element) {
      items.add(DropdownMenuItem(
        child: Text(element['catName']),
        value: element['catName'],
      ));
    });
    setState(() {
      item = items;
    });
  }
}
