
import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/date.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DebtEdit extends StatefulWidget {
  Map data;
  DebtEdit(this.data);
  @override
  _DebtEditState createState() => _DebtEditState(this.data);
}

class _DebtEditState extends State<DebtEdit> {
  Map data;
  _DebtEditState(this.data);
  var _forKey = GlobalKey<FormState>();
  // var _forKey1 = GlobalKey<FormState>();
  String cat;
  var amountController = TextEditingController();
  var returnController = TextEditingController();
  var descController = TextEditingController();
  var fullNameController = TextEditingController();
  var debtController = TextEditingController();
  // var isVisible = false;
  // var otherID;
  var debtBox = Hive.box("debt");
  @override
  void initState() {
    super.initState();
    cat = data['cat'];
    fullNameController.text = data['fullName'];
    amountController.text = data['birr'];
    descController.text = data['reason'];
    returnController.text = data['totalreturn'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Utility.getTitle()),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Form(
                key: _forKey,
                child: Column(
                  children: [
                    Text("የብድር እና ዱቤ ማስተካከያዎች", style: Style.mainStyle1),
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
                        )
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
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 8),
                    //   child: TextFormField(
                    //     controller: fullNameController,
                    //     textInputAction: TextInputAction.next,
                    //     validator: (value) {
                    //       if (value.isEmpty) return 'እባክዎትን ስም ያስገቡ';
                    //       return null;
                    //     },
                    //     decoration: InputDecoration(
                    //         border: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(0.5)),
                    //         labelText: "ሙሉ ስም",
                    //         hintText: 'ምሳ. ነጻነት ሞላ',
                    //         prefixIcon: Icon(Icons.people)),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextFormField(
                        controller: returnController,
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
                            labelText: "የተመለሰ ብር",
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
                          // debtBox.clear();
                          if (_forKey.currentState.validate()) {
                            var deptID = data['debtID'];
                            var debt = {
                              'birr': amountController.text,
                              'fullName': fullNameController.text,
                              'reason': descController.text,
                              'cat': cat,
                              'debtID': deptID,
                              'orgId': Hive.box("setting").get("orgId"),
                              'date': Dates.today,
                              'totalreturn': returnController.text,
                              // 'totalreminder': 0,
                              'action': 'EDIT_DEBT',
                              'insertStatus': 'no',
                              'updateStatus': 'yes',
                              'deleteStatus': 'no'
                            };
                            debtBox.put(deptID, debt);
                            Utility.successMessage(context, 'በትክክል ተመዝግቧል');
                          }
                        },
                        child: Text('Update')),
                    Divider(
                      thickness: 1,
                      color: Colors.blueAccent,
                    ),

                    // listRow.length == 0 ? LinearProgressIndicator() : Divider()
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
