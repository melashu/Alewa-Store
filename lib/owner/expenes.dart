import 'dart:math';
import 'package:abushakir/abushakir.dart';
import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/date.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:boticshop/ads/ads.dart';
import 'package:boticshop/owner/expenesslist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

final isDailyProvider = StateProvider<bool>((ref) => false);
final dailyCaseProvider = StateProvider<String>((ref) => "Employee");
final isVisibleProvider = StateProvider<bool>((ref) => false);
final itemIDProvider = StateProvider<String>((ref) => "Employee");
final payementDateProvider = StateProvider<String>((ref) => "ቀን");
final payementMonthProvider = StateProvider<String>((ref) => "ወር");
final payementYearProvider = StateProvider<String>((ref) => "ዓ.ም");
final otherIDProvider = StateProvider<String>((ref) => "");
final isDailyVisileProvider = StateProvider<bool>((ref) {
  return false;
});
final isMontlyVisileProvider = StateProvider<bool>((ref) {
  return true;
});
final initMonthlyStateProvider = StateProvider<String>((ref) {
  return 'ወርሃዊ';
});

var isVisible = false;

class Expeness extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final formKey = GlobalKey<FormState>();
    var dayliPayementController = TextEditingController();
    var monthlyPayementController = TextEditingController();

    var dailyController = TextEditingController();

    var initMonth = watch(initMonthlyStateProvider).state;
    var expenessBox = Hive.box("expenes");

    var otherController = TextEditingController();
    var isVisible = watch(isVisibleProvider).state;
    var showDaily = watch(isDailyVisileProvider).state;
    var showMonthly = watch(isMontlyVisileProvider).state;

    var isDaily = watch(isDailyProvider).state;
    // var dataRow = <DataRow>[];
    var initEmpID = watch(itemIDProvider).state;
    var dailyCase = watch(dailyCaseProvider).state;
    var payementDate = watch(payementDateProvider).state;
    var payementMonth = watch(payementMonthProvider).state;
    var payementYear = watch(payementYearProvider).state;
    var _monthFocus = FocusNode();
    var _dayliFocus = FocusNode();
    BannerAd bannerAd = Ads().setAd4();
    bool isSub = Hive.box("setting").get("isSubscribed");
    return Scaffold(
      appBar: AppBar(
        title: Utility.getTitle(),
      ),
      persistentFooterButtons: [
        OutlinedButton(
            style: Style.outlinedButtonStyle,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ExpenessList();
              }));
            },
            child: Text('List of Registered Expeness'))
      ],

      bottomNavigationBar: bannerAd != null && !isSub
                ? Container(
                    height: bannerAd.size.height.toDouble(),
                    width: bannerAd.size.width.toDouble(),
                    child: AdWidget(
                      ad: bannerAd,
                    ),
                  )
                : SizedBox(),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
           !isSub
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom:15.0),
                    child: Text(
                    "በቆሚነት አባል ከሆኑ በሆላ ሁሉም ማስታውቂያዎች ከሲስተሙ ይጠፋሉ፡፡",
                    style: TextStyle(fontSize: 10, color: Colors.redAccent),
                ),
                  ))
              : SizedBox(),
          Container(
            child: Center(
                child: Text(
              'የእለታዊ እና ወርሃዊ ወጭ መመዝገቢያ ቅጽ',
              style: Style.mainStyle1,
            )),
          ),
          Divider(
            color: Colors.lightBlueAccent,
            thickness: 1,
          ),
          Row(
            children: [
              Text(
                'የወጭ አይነት ይምረጡ',
                style: Style.mainStyle2,
              ),
              SizedBox(
                width: 30,
              ),
              DropdownButton<String>(
                  dropdownColor: Colors.lightBlueAccent,
                  elevation: 10,
                  iconEnabledColor: Colors.blueAccent,
                  items: [
                    DropdownMenuItem<String>(
                      child: Text("ወርሃዊ"),
                      value: 'ወርሃዊ',
                    ),
                    DropdownMenuItem<String>(
                      child: Text("እለታዊ"),
                      value: 'እለታዊ',
                    ),
                  ],
                  value: initMonth,
                  onChanged: (val) {
                    watch(initMonthlyStateProvider).state = val;
                    if (val == 'ወርሃዊ') {
                      watch(isMontlyVisileProvider).state = true;
                      watch(isDailyVisileProvider).state = false;
                    } else {
                      watch(isMontlyVisileProvider).state = false;
                      watch(isDailyVisileProvider).state = true;
                    }
                  })
            ],
          ),
          Visibility(
            visible: showDaily,
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          border: Border.all(
                        width: 1,
                        color: Colors.deepPurpleAccent,
                      )),
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              "የእለታዊ ወጭዎች መመዝገቢያ",
                              style: Style.style1,
                            ),
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.deepPurpleAccent,
                          ),
                          Row(
                            children: [
                              Text(
                                "የወጭ ምክንያት",
                                style: Style.style1,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              DropdownButton<String>(
                                focusColor: Colors.deepPurple,
                                autofocus: true,
                                dropdownColor: Colors.deepPurple,
                                style: Style.dropDouwnStyle,
                                items: [
                                  DropdownMenuItem(
                                    child: Text('Employee'),
                                    value: 'Employee',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('House Rent'),
                                    value: 'House Rent',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('Transport'),
                                    value: 'Transport',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('other'),
                                    value: 'other',
                                  )
                                ],
                                value: dailyCase,
                                onChanged: (String value) {
                                  if (value == 'other') {
                                    watch(dailyCaseProvider).state = value;
                                    watch(isDailyProvider).state = true;
                                    _dayliFocus.requestFocus();
                                  } else {
                                    watch(isDailyProvider).state = false;
                                    watch(dailyCaseProvider).state = value;
                                  }
                                },
                              ),
                              Divider(),
                            ],
                          ),
                          Visibility(
                            visible: isDaily,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                focusNode: _dayliFocus,
                                controller: dailyController,
                                autofocus: true,
                                validator: (value) {
                                  if (value.isEmpty)
                                    return 'Please Enter Expeness Type';
                                  else if (double.tryParse(value) != null) {
                                    return 'Please Enter Expeness Type';
                                  }
                                  return null;
                                },
                                onChanged: (val) {
                                  // watch(otherIDProvider).state = val;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Expeness Type",
                                  hintText: 'Employee',
                                ),
                              ),
                            ),
                          ),
                          TextFormField(
                              controller: dayliPayementController,
                              enableSuggestions: true,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              autocorrect: true,
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "Enter in Birr";
                                } else if (int.tryParse(val) == null) {
                                  return "Enter in Birr ";
                                }
                                return null;
                              },
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15),
                              decoration: InputDecoration(
                                  labelText: " Payement in Birr",
                                  hintText: ' Payement in Birr',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  contentPadding: EdgeInsets.all(3),
                                  errorStyle: TextStyle(color: Colors.red))),
                          Divider(),
                          OutlinedButton(
                            onPressed: () async {
                              if (formKey.currentState.validate()) {
                                var random = Random();
                                var eID = random.nextInt(1000000);
                                String other = dailyController.text;
                                var expenessMap = {
                                  'eID': 'e-$eID',
                                  'dailyCase': isDaily ? other : dailyCase,
                                  'paidAmount': dayliPayementController.text,
                                  'date': Dates.today,
                                  'payementType': 'ዕለታዊ',
                                  'insertStatus': 'no',
                                  'updateStatus': 'no',
                                  'deleteStatus': 'no'
                                };
                                await expenessBox.put('e-$eID', expenessMap);
                                if (expenessBox.containsKey('e-$eID')) {
                                  Utility.showSnakBar(context,
                                      "Done Succssfuly!", Colors.greenAccent);
                                } else {
                                  Utility.showSnakBar(
                                      context,
                                      "Something went wrong please call to 0980631983  ",
                                      Colors.redAccent);
                                }
                              }
                            },
                            child: Text(
                              "Save",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: OutlinedButton.styleFrom(
                                minimumSize: Size(100, 30),
                                backgroundColor: Colors.deepPurple,
                                padding: EdgeInsets.all(3),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          //break
          Visibility(
            visible: showMonthly,
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 1,
                  color: Colors.deepPurpleAccent,
                )),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "የወርሃዊ ወጭዎች መመዝገቢያ",
                        style: Style.style1,
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.deepPurpleAccent,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Text("የክፍያ ቀን"),
                        ),
                        DropdownButton(
                          items: Dates.getDay(),
                          style: Style.dropDouwnStyle,
                          value: payementDate,
                          dropdownColor: Colors.deepPurple,
                          onChanged: (val) {
                            watch(payementDateProvider).state = val;
                          },
                        ),
                        DropdownButton(
                          items: Dates.getMonth(),
                          style: Style.dropDouwnStyle,
                          value: payementMonth,
                          dropdownColor: Colors.deepPurple,
                          onChanged: (val) {
                            watch(payementMonthProvider).state = val;
                          }, //nat-145509
                        ),
                        DropdownButton(
                          items: Dates.getYear(),
                          style: Style.dropDouwnStyle,
                          value: payementYear,
                          dropdownColor: Colors.deepPurple,
                          onChanged: (val) {
                            watch(payementYearProvider).state = val;
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "የወጭ ምክንያት",
                          style: Style.style1,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        DropdownButton<String>(
                          dropdownColor: Colors.deepPurple,
                          style: Style.dropDouwnStyle,
                          items: [
                            DropdownMenuItem(
                              child: Text('Employee'),
                              value: 'Employee',
                            ),
                            DropdownMenuItem(
                              child: Text('House Rent'),
                              value: 'House Rent',
                            ),
                            DropdownMenuItem(
                              child: Text('Transport'),
                              value: 'Transport',
                            ),
                            DropdownMenuItem(
                              child: Text('other'),
                              value: 'other',
                            )
                          ],
                          value: initEmpID,
                          onChanged: (String value) {
                            if (value == 'other') {
                              watch(itemIDProvider).state = value;
                              watch(isVisibleProvider).state = true;
                              _monthFocus.requestFocus();
                            } else {
                              watch(isVisibleProvider).state = false;
                              watch(itemIDProvider).state = value;
                            }
                          },
                        ),
                        Divider(),
                      ],
                    ),
                    Visibility(
                      visible: isVisible,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: otherController,
                          autofocus: true,
                          focusNode: _monthFocus,
                          validator: (value) {
                            if (value.isEmpty)
                              return 'የወጭ አይነት ያስገቡ';
                            else if (double.tryParse(value) != null) {
                              return 'የወጭ አይነት ያስገቡ';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            // watch(otherIDProvider).state = val;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Expenes Type",
                            hintText: 'Employee',
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                        controller: monthlyPayementController,
                        enableSuggestions: true,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        autocorrect: true,
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Please Enter Amount You Pay ";
                          } else if (int.tryParse(val) == null) {
                            return "Please Enter Amount You Pay ";
                          }
                          return null;
                        },
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                            labelText: "Expenes amount",
                            hintText: 'Expenes amount',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            contentPadding: EdgeInsets.all(3),
                            errorStyle: TextStyle(color: Colors.red))),
                    OutlinedButton(
                      onPressed: () async {
                        if (payementDate != 'ቀን' &&
                            payementMonth != 'ወር' &&
                            payementYear != 'ዓ.ም') {
                          var random = Random();
                          var eID = random.nextInt(1000000);
                          String other = otherController.text;
                          var expenessMap = {
                            'eID': 'e-$eID',
                            'dailyCase': isDaily ? other : dailyCase,
                            'paidAmount': monthlyPayementController.text,
                            'date': EtDatetime(
                                    year: int.parse(payementYear),
                                    month: int.parse(payementMonth),
                                    day: int.parse(payementDate))
                                .toString(),
                            'payementType': 'ወርሃዊ',
                            'insertStatus': 'no',
                            'updateStatus': 'no',
                            'deleteStatus': 'no'
                          };
                          // print(dayliPayementController.text + '$other');

                          await expenessBox.put('e-$eID', expenessMap);
                          if (expenessBox.containsKey('e-$eID')) {
                            Utility.showSnakBar(context, "በትክክል ተመዝግቦል!",
                                Colors.greenAccent);
                          } else {
                            Utility.showSnakBar(
                                context,
                                "Something Went Wrong Please call to 0980631983! ",
                                Colors.redAccent);
                          }
                        } else {
                          Utility.showSnakBar(
                              context,
                              "Please Enter Valid Amount in Birr",
                              Colors.redAccent);
                        }
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: OutlinedButton.styleFrom(
                          minimumSize: Size(100, 30),
                          backgroundColor: Colors.deepPurple,
                          padding: EdgeInsets.all(3),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
