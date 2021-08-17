import 'dart:math';
import 'package:boticshop/Utility/Boxes.dart';
import 'package:boticshop/Utility/date.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

final isDailyProvider = StateProvider<bool>((ref) => false);
final dailyCaseProvider = StateProvider<String>((ref) => "ለሰራተኛ");
final isVisibleProvider = StateProvider<bool>((ref) => false);
final itemIDProvider = StateProvider<String>((ref) => "ለሰራተኛ");
final payementDateProvider = StateProvider<String>((ref) => "ቀን");
final payementMonthProvider = StateProvider<String>((ref) => "ወር");
final payementYearProvider = StateProvider<String>((ref) => "ዓ.ም");
final otherIDProvider = StateProvider<String>((ref) => "");

var isVisible = false;

class Expeness extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final formKey = GlobalKey<FormState>();
    var payementController = TextEditingController();
    var dayliPayementController = TextEditingController();
    var dailyController = TextEditingController();

    // var cata4EditingController = TextEditingController();
    var expenessBox = Hive.lazyBox("expeness");

    var otherController = TextEditingController();
    var isVisible = watch(isVisibleProvider).state;
    var isDaily = watch(isDailyProvider).state;
    // var dataRow = <DataRow>[];
    var initEmpID = watch(itemIDProvider).state;
    var dailyCase = watch(dailyCaseProvider).state;
    var payementDate = watch(payementDateProvider).state;
    var payementMonth = watch(payementMonthProvider).state;
    var payementYear = watch(payementYearProvider).state;
    // var otherID = watch(otherIDProvider);

    var _monthFocus = FocusNode();
    var _dayliFocus = FocusNode();
    // Box catBox = Hive.box("categorie");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Hive.box("setting").get("orgName"),
          style: Style.style1,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          SizedBox(
            height: 30,
          ),
          Form(
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
                            "የእለታዊ ወጭዎች መመዝገቢያ ገጽ",
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
                              "የወጭ አይነት",
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
                                  child: Text('ለራተኛ'),
                                  value: 'ለሥራተኛ',
                                ),
                                DropdownMenuItem(
                                  child: Text('ለቤት ኪራይ'),
                                  value: 'ለቤት ኪራይ',
                                ),
                                DropdownMenuItem(
                                  child: Text('ለትራንስፖርት'),
                                  value: 'ለትራንስፖርት',
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
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'የወጭ አይነት ያስገቡ';
                                else if (double.tryParse(value) != null) {
                                  return 'የወጭ አይነት ያስገቡ';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                watch(otherIDProvider).state = val;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "የወጭ አይነት",
                                hintText: 'ለሥራተኛ',
                              ),
                            ),
                          ),
                        ),
                        TextFormField(
                            controller: dayliPayementController,
                            autofocus: true,
                            enableSuggestions: true,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            autocorrect: true,
                            validator: (val) {
                              if (val.isEmpty) {
                                return "እባክወትን የክፍያ መጠኑን ያስገቡ";
                              } else if (int.tryParse(val) == null) {
                                return "እባክወትን የክፍያ መጠኑን በብር ያስገቡ ";
                              }
                              return null;
                            },
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                                labelText: " የክፍያ መጠን በብር",
                                hintText: ' የክፍያ መጠን በብር',
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
                              var randomID = random.nextInt(1000000);
                              var expenessMap = {
                              
                              };

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
          Padding(
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
                      "የወርሃዊ ወጭዎች መመዝገቢያ ገጽ",
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
                        "የወጭ አይነት",
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
                            child: Text('ለሥራተኛ'),
                            value: 'ለሥራተኛ',
                          ),
                          DropdownMenuItem(
                            child: Text('ለቤት ኪራይ'),
                            value: 'ለቤት ኪራይ',
                          ),
                          DropdownMenuItem(
                            child: Text('ለትራንስፖርት'),
                            value: 'ለትራንስፖርት',
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
                          watch(otherIDProvider).state = val;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "የወጭ አይነት",
                          hintText: 'ለሥራተኛ',
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                      controller: payementController,
                      autofocus: true,
                      enableSuggestions: true,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      autocorrect: true,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "እባክወትን የክፍያ መጠኑን ያስገቡ";
                        } else if (int.tryParse(val) == null) {
                          return "እባክወትን የክፍያ መጠኑን በብር ያስገቡ ";
                        }
                        return null;
                      },
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                          labelText: " የክፍያ መጠን በብር",
                          hintText: ' የክፍያ መጠን በብር',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          contentPadding: EdgeInsets.all(3),
                          errorStyle: TextStyle(color: Colors.red))),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Text("ክፍያ የሚፈጽምበ"),
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
                        },
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
                  OutlinedButton(
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        var random = Random();
                        var randomID = random.nextInt(1000000);
                        Map catMap = {
                          "catName": payementController.text,
                          "catID": 'I$randomID',
                          "isSync": 'false'
                        };
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
          )
        ],
      ),
    );
  }
}
