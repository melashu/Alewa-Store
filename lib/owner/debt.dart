import 'dart:math';

import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/date.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:boticshop/owner/debtedit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Debt extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DebtState();
  }
}

class DebtState extends State<Debt> {
  var _forKey = GlobalKey<FormState>();
  // var _forKey1 = GlobalKey<FormState>();
  String cat = 'ተበዳሪ';
  var amountController = TextEditingController();
  var otherController = TextEditingController();
  var descController = TextEditingController();
  var fullNameController = TextEditingController();
  var debtController = TextEditingController();
  var isVisible = false;
  var otherID;
  var debtBox = Hive.box("debt");

  List<DataRow> listRow = [];
  var salaryController = TextEditingController();
  // var workDateController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Utility.getTitle()),
      body: ListView(padding: const EdgeInsets.all(10.0), children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
              key: _forKey,
              child: Column(
                children: [
                  Text("የብድር እና ዱቤ ዝርዝሮች", style: Style.mainStyle1),
                  Divider(thickness: 1, color: Colors.blueAccent),
                  Row(
                    children: [
                      Text("መደብ", style: Style.style1),
                      SizedBox(
                        width: 10,
                      ),
                      DropdownButton<String>(
                        style: Style.dropDouwnStyle,
                        items: [
                          DropdownMenuItem(
                            child: Text('ተበዳሪ'),
                            value: 'ተበዳሪ',
                          ),
                          DropdownMenuItem(
                            child: Text('አበዳሪ'),
                            value: 'አበዳሪ',
                          ),
                          DropdownMenuItem(
                            child: Text('በዱቤ የተገዛ'),
                            value: 'በዱቤ የተገዛ',
                          ),
                          DropdownMenuItem(
                            child: Text('በዱቤ የተሸጠ'),
                            value: 'በዱቤ የተሸጠ',
                          ),
                        ],
                        value: cat,
                        onChanged: (String value) {
                          setState(() {
                            cat = value;
                          });
                        },
                      ),
                      Spacer(),
                      ElevatedButton(
                          onPressed: () {
                            debtReport('show');
                          },
                          child: Text('የብድር ሪፖርቶች'))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      controller: fullNameController,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) return 'እባክዎትን ስም ያስገቡ';
                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0.5)),
                          labelText: "ሙሉ ስም",
                          hintText: 'ምሳ. ነጻነት ሞላ',
                          prefixIcon: Icon(Icons.people)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      controller: amountController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty)
                          return 'የብሩን መጠን ያስገቡ';
                        else if (double.tryParse(value) == null) {
                          return 'ትክክለኛ ቁጥር ያስገቡ';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0.5)),
                          labelText: "የብሩ መጠን",
                          hintText: 'ምሳ. 200 ብር',
                          prefixIcon: Icon(Icons.work_outline)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      controller: descController,
                      textInputAction: TextInputAction.next,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0.5)),
                        labelText: "ምክንያት (ከሌለ ማለፍ ይቻላል)",
                        hintText: 'ምሳ. ነጻነት ሞላ',
                        prefixIcon: Icon(Icons.description_outlined),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        // print("Category=$cat");
                        if (_forKey.currentState.validate()) {
                          var random = Random();
                          var deptID = random.nextInt(1000000).toString();
                          var debt = {
                            'birr': amountController.text,
                            'fullName': fullNameController.text,
                            'reason': descController.text,
                            'cat': cat,
                            'debtID': deptID,
                            'orgId': Hive.box("setting").get("orgId"),
                            'date': Dates.today,
                            'totalreturn': 0,
                            'action': 'ADD_DEBT',
                            'insertStatus': 'no',
                            'updateStatus': 'no',
                            'deleteStatus': 'no'
                          };
                          debtBox.put(deptID, debt);
                          Utility.successMessage(context, 'በትክክል ተመዝግቧል');
                        }
                      },
                      child: Text('Save')),
                  Divider(
                    thickness: 1,
                    color: Colors.blueAccent,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            '''የእዳ ዝርዝሮች''',
                            style: Style.style1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.blueAccent,
                  ),
                  ValueListenableBuilder(
                      valueListenable: debtBox.listenable(),
                      builder: (context, box, _) {
                        List data = box.values.toList();

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.all(10),
                          child: DataTable(
                            showCheckboxColumn: true,
                            sortColumnIndex: 0,
                            showBottomBorder: true,
                            headingRowColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (var states) {
                              return Colors.lightBlue;
                            }),
                            columnSpacing: 40,
                            dividerThickness: 1,

                            headingTextStyle:
                                TextStyle(fontSize: 16, color: Colors.white),
                            columns: [
                              DataColumn(label: Icon(Icons.edit)),
                              DataColumn(label: Text('ስም')),
                              DataColumn(label: Text('አጠቃላይ ብድር')),
                              DataColumn(label: Text('የተመለሰ')),
                              DataColumn(label: Text('ቀሪ')),
                              DataColumn(label: Text('ክፍያ')),
                              DataColumn(label: Text('ቀን')),
                            ],
                            rows: dataTable(data),
                            // rows: getListOfCell()
                          ),
                        );
                      }),

                  // listRow.length == 0 ? LinearProgressIndicator() : Divider()
                ],
              )),
        )
      ]),
    );
  }

  List<DataRow> dataTable(List data) {
    List<DataRow> _listRow = [];
    int i = 0;
    for (var row in data) {
      /****
     *   'birr': amountController.text,
                            'fullName': fullNameController.text,
                            'reason': descController.text,
                            'cat': cat,
                            'debtID': deptID,
                            'orgId': Hive.box("setting").get("orgId"),
                            'date': Dates.today,
     */

      i = i + 1;
      _listRow.add(DataRow(
          // selected: true,
          cells: [
            DataCell(PopupMenuButton(
                color: Colors.deepPurple,
                initialValue: 0,
                onSelected: (i) {
                  if (i == 0) {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return DebtEdit(row);
                    }));
                  } else if (i == 1) {
                    ConfirmAlertBox(
                        context: context,
                        title: 'Delete',
                        infoMessage: 'ይህን ማጥፋት ይፈልጋሉ?',
                        onPressedYes: () {
                          var debtID = row['debtID'];
                          debtBox.delete(debtID);
                          Navigator.of(context).pop();
                        });
                  }
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                        value: 0,
                        child: Text("Edit",
                            style: TextStyle(color: Colors.white))),
                    PopupMenuItem(
                        value: 1,
                        child: Text("Delete",
                            style: TextStyle(color: Colors.white))),
                  ];
                })),
            DataCell(Text(row['fullName'])),
            DataCell(Text(row['birr'])),
            DataCell(Text('${double.parse(row['totalreturn'].toString())}')),
            DataCell(Text(
                '${double.parse(row['birr']) - double.parse(row['totalreturn'].toString())}')),
            DataCell(TextButton(
              onPressed: () {
                double totalDebt = double.parse(row['birr']);
                double totalReturn =
                    double.parse(row['totalreturn'].toString());
                double reminder = totalDebt - totalReturn;
                if ('$reminder' == '0.0') {
                  Utility.successMessage(context, 'ይቅርታ ከዚህ በፊት ከፍያው ተጠናቆል!"');
                } else {
                  payDebt(row['debtID'], '$reminder');
                  debtController.text = '$reminder';
                }
              },
              child: Text('pay'),
            )),
            DataCell(Text(row['date'])),
          ]));
    }
    listRow = _listRow;
    return _listRow;
  }

  void payDebt(String id, String left) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        elevation: 10,
        builder: (context) {
          return DraggableScrollableSheet(
              minChildSize: 0.5,
              initialChildSize: 0.9,
              maxChildSize: 0.9,
              builder: (_, controller) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: debtController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0.5)),
                            labelText: "የክፍያ መጠን",
                            prefixIcon: Icon(Icons.money)),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (debtController.text.isEmpty) {
                              Utility.showDangerMessage(
                                  context, 'Please Enter the amount');
                            } else if (double.tryParse(debtController.text) ==
                                null) {
                              Utility.showDangerMessage(
                                  context, 'Please Enter number only');
                            } else {
                              var debtList = debtBox.get(id);
                              var debtInput = double.parse(debtController.text);
                              var totalreturn = double.parse(
                                  debtList["totalreturn"].toString());
                              var totalDebt =
                                  double.parse(debtList["birr"].toString());
                              var totalLeft = totalDebt - totalreturn;
                              var total = debtInput + totalreturn;
                              if (totalLeft <
                                  double.parse(debtController.text)) {
                                // Navigator.of(context).pop();
                                Utility.showDangerMessage(context,
                                    "Your debt $totalLeft less than your input ${debtController.text}");
                              } else {
                                //to set total debt
                                debtList["totalreturn"] = total;
                                debtBox.put(id, debtList);
                                Utility.successMessage(context, 'በትክክል ተመዝግቧል');
                              }
                            }
                          },
                          child: Text('Pay')
                          // style: ButtonS,
                          )
                    ],
                  ),
                  // ),
                );
              });
        });
  }

  void debtReport(String key) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        elevation: 10,
        builder: (context) {
          return DraggableScrollableSheet(
              minChildSize: 0.5,
              initialChildSize: 0.9,
              maxChildSize: 0.9,
              builder: (_, controller) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: ListView(
                    children: [
                      Center(
                        child: Text(
                          'የብድር ሪፖርቶች',
                          style: Style.mainStyle1,
                        ),
                      ),
                      Divider(
                        color: Colors.blueAccent,
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Text(
                            'ያልተመለሰ በዱቤ የተሸጠ እቃ ድምር፡ ',
                            style: Style.style1,
                          ),
                          Text(
                            ' ${getTotalReport("በዱቤ የተሸጠ")} ብር',
                            style: Style.mainStyle2,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Text(
                            'ያልተመለሰ በዱቤ የተገዛ እቃ ድምር፡',
                            style: Style.style1,
                          ),
                          Text(
                            ' ${getTotalReport("በዱቤ የተገዛ")} ብር',
                            style: Style.mainStyle2,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Text(
                            'ያልተመለሰ ከሌላ ሰው ላይ ያለዎት ብር:',
                            style: Style.style1,
                          ),
                          Text(
                            ' ${getTotalReport("አበዳሪ")} ብር',
                            style: Style.mainStyle2,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Text(
                            'ያልተመለሰ ከሌላ ሰው ላይ ያለብዎት ብር: ',
                            style: Style.style1,
                          ),
                          Text(
                            '${getTotalReport("ተበዳሪ")} ብር',
                            style: Style.mainStyle2,
                          )
                        ],
                      ),
                    ],
                  ),
                  // ),
                );
              });
        });
  }

  double getTotalReport(String key) {
    var result = debtBox.values.toList();
    var total = 0.0;
    for (var row in result) {
      if (row['cat'] == key) {
        total = total + (double.parse(row['birr']) - row['totalreturn']);
      }
    }
    return total;
  }
}
