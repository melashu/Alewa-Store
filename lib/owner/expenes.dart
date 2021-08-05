import 'dart:math';
import 'package:boticshop/Utility/date.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Expeness extends StatefulWidget {
  @override
  _AddcategorieState createState() => _AddcategorieState();
}

class _AddcategorieState extends State<Expeness> {
  final formKey = GlobalKey<FormState>();
  var payementController = TextEditingController();
  var dayliPayementController = TextEditingController();
  var cata4EditingController = TextEditingController();
  var dateController = TextEditingController();
  var otherController = TextEditingController();
  var isVisible = false;
  var isDaily = false;
  var dataRow = <DataRow>[];
  var initEmpID = "ለሥራተኛ";
  var dailyCase = "ለሥራተኛ";
  var otherID;
  var payementDate = 'ቀን';
  var payementMonth = 'ወር';
  var payementYear = 'ዓ.ም';
  var _monthFocus = FocusNode();
  var _dayliFocus = FocusNode();
  var dailyController = TextEditingController();
  Box catBox = Hive.box("categorie");
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                              // focusColor: Colors.deepPurple,
                              autofocus: true,
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
                              value: dailyCase,
                              onChanged: (String value) {
                                setState(() {
                                  if (value == 'other') {
                                    dailyCase = value;
                                    isDaily = true;
                                    _dayliFocus.requestFocus();
                                  } else {
                                    isDaily = false;
                                    dailyCase = value;
                                  }
                                });
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
                                setState(() {
                                  otherID = val;
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    // borderRadius: BorderRadius.circular(0.5)
                                    ),
                                labelText: "የወጭ አይነት",
                                hintText: 'ለሥራተኛ',
                                // helperText: 'Paid Salary ',
                                // prefixIcon: Icon(Icons.people)
                              ),
                            ),
                          ),
                          // )
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

                //here
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
                          setState(() {
                            if (value == 'other') {
                              initEmpID = value;
                              isVisible = true;
                              _monthFocus.requestFocus();
                            } else {
                              isVisible = false;
                              initEmpID = value;
                            }
                          });
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
                          setState(() {
                            otherID = val;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(0.5)
                              ),
                          labelText: "የወጭ አይነት",
                          hintText: 'ለሥራተኛ',
                          // helperText: 'Paid Salary ',
                          // prefixIcon: Icon(Icons.people)
                        ),
                      ),
                    ),
                    // )
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
                          setState(() {
                            payementDate = val;
                          });
                        },
                      ),
                      DropdownButton(
                        items: Dates.getMonth(),
                        style: Style.dropDouwnStyle,
                        value: payementMonth,
                        dropdownColor: Colors.deepPurple,
                        onChanged: (val) {
                          setState(() {
                            payementMonth = val;
                          });
                        },
                      ),
                      DropdownButton(
                        items: Dates.getYear(),
                        style: Style.dropDouwnStyle,
                        value: payementYear,
                        dropdownColor: Colors.deepPurple,
                        onChanged: (val) {
                          setState(() {
                            payementYear = val;
                          });
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
                          // "deleteStatus": 'no'
                        };
                        // catMap.toString();
                        catBox.put("I$randomID", catMap);
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
