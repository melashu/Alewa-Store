import 'package:abushakir/abushakir.dart';
import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:boticshop/owner/itemList.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:screenshot/screenshot.dart';

class EditItem extends StatefulWidget {
 final Map itemList;
  EditItem(this.itemList);
  @override
  _EditItemState createState() => _EditItemState(itemList);
}

class _EditItemState extends State<EditItem> {
  Map data;
  _EditItemState(this.data);

  var catBox = Hive.box("categorie");
  var initValue;
  var formKey = GlobalKey<FormState>();
  var brandController = TextEditingController();
  var sizeController = TextEditingController();
  var buyPricesController = TextEditingController();
  var soldPricesController = TextEditingController();
  var amountController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  var itemBox = Hive.box("item");
  var screenshotController = ScreenshotController();
  List<DropdownMenuItem> items = [];
  bool isQR = true;
  var qrStatus = "On";
  @override
  void initState() {
    super.initState();
    initValue = data['catName'];
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Hive.box("setting").get("orgName")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
            key: formKey,
            child: ListView(
              children: [
                Center(
                    child: Text(
                  "ማስተካከያ ገጽ",
                  style: Style.style1,
                )),
                Divider(
                  color: Colors.lightBlueAccent,
                ),
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
                Divider(
                  color: Colors.lightBlueAccent,
                ),
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
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                      items: items,
                      value: initValue,
                      onChanged: (val) {
                        setState(() {
                          initValue = val;
                        });
                      },
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TextFormField(
                    controller: brandController..text = data['brandName'],
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
                        floatingLabelBehavior: FloatingLabelBehavior.auto),
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
                        floatingLabelBehavior: FloatingLabelBehavior.auto),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TextFormField(
                    controller: buyPricesController..text = data['buyPrices'],
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
                        floatingLabelBehavior: FloatingLabelBehavior.auto),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TextFormField(
                    controller: soldPricesController..text = data['soldPrices'],
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
                        floatingLabelBehavior: FloatingLabelBehavior.auto),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TextFormField(
                    controller: amountController..text = data['amount'].toString(),
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
                        floatingLabelBehavior: FloatingLabelBehavior.auto),
                  ),
                ),
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
                      } else {
                        // var random = Random();
                        var itemID = data['itemID'];
                        var date = EtDatetime.now().toString();

                        Map itemMap = {
                          'itemID': itemID.toString(),
                          'brandName': brandController.text,
                          'catName': initValue,
                          'size': sizeController.text,
                          'userName': 'meshu',
                          'amountSold': "0",
                          'createDate': date,
                          'buyPrices': buyPricesController.text,
                          'soldPrices': soldPricesController.text,
                          'amount': amountController.text,
                          'insertStatus': data['insertStatus'],
                          'updateStatus': 'yes',
                          'deleteStatus': data['deleteStatus'],
                        };
                        var qr = {
                          'itemID': itemID.toString(),
                          'brandName': brandController.text,
                          'size': sizeController.text,
                          'buyPrices': buyPricesController.text,
                          'soldPrices': soldPricesController.text,
                          'amount': '1',
                        };

                        itemBox.put(itemID, itemMap);
                        var isKey = itemBox.containsKey(itemID);
                        if (isKey) {
                          Utility.showSnakBar(
                              context, "በትክክል ተመዝግቦል", Colors.greenAccent);
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return ItemList();
                          }));
                        } else {
                          Utility.showSnakBar(
                              context,
                              "አልተመዘገበም እባክወትን ለእርዳታ ወደ 0980631983 ይደወሉ ",
                              Colors.redAccent);
                        }
                        if (isQR) {
                          var image = await screenshotController
                              .captureFromWidget(Utility.qrCodetoImage(qr));
                          await Utility.saveToGalary(
                              image,
                              sizeController.text + "_" + brandController.text,
                              "edited");
                          // print('your paths=$path');
                        }
                      }
                    }
                  },
                  child: Text("Update"),
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
              ],
            )),
      ),
    );
  }
}
