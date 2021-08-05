import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/style.dart';
import "package:flutter/material.dart";
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'editItem.dart';

class ItemList extends StatefulWidget {
  //  const ItemList({ Key? key }) : super(key: key);
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  var setting = Hive.box("setting");

  var itemBox = Hive.box('item');

  var dataRow = <DataRow>[];
  var filltered = [];
  @override
  Widget build(BuildContext context) {
    // setting.put("orgName", "Meshu Inc");
    return Scaffold(
      appBar: AppBar(
        title: Text(setting.get("orgName")),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Text(
                "የተመዘገቡ እቃዎች ዝርዝር ",
                style: Style.style1,
              ),
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.lightBlue,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: TextField(
              onChanged: (val) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search_outlined),
                  onPressed: () {},
                ),
                labelText: "የእቃውን አይነት ያስገቡ",
                labelStyle: Style.style1,
                contentPadding: EdgeInsets.all(10),
              ),
            ),
          ),
          ValueListenableBuilder(
              valueListenable: itemBox.listenable(),
              builder: (context, box, _) {
                List data = box.values.toList();
                // setState(() {
                //   filltered = data;
                // });
                return dataTable(data, context);
              }),
          // showSearch(context: context, delegate: delegate)
        ],
      ),
    );
  }

  Widget dataTable(List data, BuildContext context) {
    dataRow.clear();
    for (var itemMap in data) {
      if (itemMap['deleteStatus'] == 'no') {
        dataRow.add(DataRow(cells: [
          DataCell(PopupMenuButton(
              color: Colors.deepPurple,
              initialValue: 0,
              onSelected: (index) {
                if (index == 0) {
                  // Utility.editItem(itemMap, context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return EditItem(itemMap);
                  }));
                } else if (index == 1) {
                  // _EditItemState().editItem( itemMap,context);
                  Utility.showConfirmDialog(context: context, itemMap: itemMap);



                  
                }
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                      value: 0,
                      child:
                          Text("Edit", style: TextStyle(color: Colors.white))),
                  PopupMenuItem(
                      value: 1,
                      child: Text("Delete",
                          style: TextStyle(color: Colors.white))),
                ];
              })),
          DataCell(Text("${itemMap['catName']}")),
          DataCell(Text("${itemMap['brandName']}")),
          DataCell(Text("${itemMap['size']}")),
          DataCell(Text("${itemMap['itemID']}")),
          DataCell(Text("${itemMap['amount']}")),
          DataCell(Text("${itemMap['buyPrices']}")),
          DataCell(Text("${itemMap['soldPrices']}")),
        ]));
      }
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        showBottomBorder: true,
        dividerThickness: 1,
        // dataTextStyle: TextStyle(fontSize: 10),
        columns: [
          DataColumn(
              label: Text(
            "ማስተካከያ",
            style: Style.style1,
          )),
          DataColumn(label: Text("የእቃው ምድብ", style: Style.style1)),
          DataColumn(label: Text("የእቃው አይነት", style: Style.style1)),
          DataColumn(label: Text("መጠን", style: Style.style1)),
          DataColumn(label: Text("መለያ ቁጥር ", style: Style.style1)),
          DataColumn(label: Text("ብዛት", style: Style.style1)),
          DataColumn(label: Text("የተገዛበት ዋጋ ", style: Style.style1)),
          DataColumn(label: Text("መሽጫ ዋጋ ", style: Style.style1)),
        ],
        rows: dataRow,
      ),
    );
  }
}
