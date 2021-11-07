import 'dart:math';
// import 'dart:ui';
// import 'package:boticshop/Utility/Boxes.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
class Addcategorie extends StatefulWidget {
  @override
  _AddcategorieState createState() => _AddcategorieState();
}

class _AddcategorieState extends State<Addcategorie> {
  final formKey = GlobalKey<FormState>();
  var cataController = TextEditingController();
  var cata4EditingController = TextEditingController();

  var dataRow = <DataRow>[];

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
        title: Text("Add Item Categorie"),
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
                  TextFormField(
                      controller: cataController,
                      autofocus: true,
                      enableSuggestions: true,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      autocorrect: true,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "እባክወትን የእቃውን አይነት ያስገቡ ";
                        }
                        return null;
                      },
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                          labelText: "የእቃውን አይነት",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          contentPadding: EdgeInsets.all(3),
                          errorStyle: TextStyle(color: Colors.red))),
                  OutlinedButton(
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        var random = Random();
                        var randomID = random.nextInt(1000000);
                        Map catMap = {
                          "catName": cataController.text,
                          "catID": 'I$randomID',
                          "isSync": 'false'
                          // "deleteStatus": 'no'
                        };
                        // catMap.toString();
                        catBox.put("I$randomID", catMap);
                      }
                    },
                    child: Text("Save"),
                    style: ButtonStyle(),
                  )
                ],
              )),
          Divider(
            thickness: 4,
          ),
          ValueListenableBuilder(
              valueListenable: catBox.listenable(),
              builder: (context, box, _) {
                var listOfData = box.values.toList();
                return dataTable(listOfData);
              }),
        ],
      ),
    );
  }

  Widget dataTable(listOfData) {
    dataRow.clear();
    for (var row in listOfData) {
      // if (row['deleteStatus'] != "yes") {
      dataRow.add(DataRow(cells: [
        DataCell(Text(row['catName'])),
        // DataCell(Text(row['deleteStatus'])),
        DataCell(Text(row['catID'])),
        DataCell(IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            showEditingBox(row['catName'].toString(), row['catID']);
          },
        )),
        DataCell(IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.grey[400],
                    title: Text("መደምሰስ"),
                    content: Text("${row['catName']} የሚለውን እቃ ማጥፋት ይፈልጋሉ?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            // "deleteStatus": 'no'
                            var key = row['catID'];
                            // row['deleteStatus'] = 'yes';
                            catBox.delete(key);
                            Navigator.of(context).pop();
                          },
                          child: Text('Yes')),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('No'))
                    ],
                  );
                });
          },
        )),
      ]));
      // }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
          showBottomBorder: true,
          sortAscending: true,
          sortColumnIndex: 0,
          columns: [
            DataColumn(label: Text("የእቃው አይነት")),
            // DataColumn(label: Text("Delete")),

            DataColumn(label: Text("የእቃው መታወቂያ")),
            DataColumn(label: Text("ማስተካከያ")),
            DataColumn(label: Text("መደምሰስ")),
          ],
          rows: dataRow),
    );
  }

  void showEditingBox(String row, String key) {
    showDialog(

        barrierDismissible: false,
        context: context,
        
        builder: (context) {

          return AlertDialog(
            
            title: Text("Editing $row"),
            actions: [
              TextButton(
                onPressed: () {
                  var val = cata4EditingController.text;
                  if (val.isNotEmpty) {
                    Map catMap = {
                      "catName": val,
                      "catID": key,
                      "isSync": 'false'
                    };
                    catBox.put(key, catMap);
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Save'),
                autofocus: true,
                style: TextButton.styleFrom(
                    side: BorderSide(
                  color: Colors.blueAccent,
                  width: 1,
                )),
              ),
              TextButton(
                style: TextButton.styleFrom(
                    side: BorderSide(
                  color: Colors.blueAccent,
                  width: 1,
                )),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              )
            ],
            content: Form(
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Catagorie Name',
                      border: OutlineInputBorder()),
                  controller: cata4EditingController..text = row,
                )),
          );
     
     
        });
  }
}
