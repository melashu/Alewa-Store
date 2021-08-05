import 'package:boticshop/Utility/style.dart';
import "package:flutter/material.dart";
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StoreLevel extends StatefulWidget {
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<StoreLevel> {
  var setting = Hive.box("setting");
  var storeLevel = Hive.lazyBox("totalitem");
  var dataRow = <DataRow>[];
  var filltered = [];
  @override
  Widget build(BuildContext context) {
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
                "የተሸጡ እና ያልተሸጡ እቃዏች ዝርዝር ",
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
          FutureBuilder<List<Map>>(
              future: getStoreLevel(),
              builder: (context, data) {
                if (data.hasData) {
                  // return ListView.builder(
                  //     itemCount: data.data.length,
                  //     itemBuilder: (context, index) {
                  //       var dataList = data.data;
                  //       return ListTile(
                  //         title: Text(dataList[index]['brandName']),
                  //       );
                  //     });

                  // if (data.hasData) {
                  return dataTable(data.data, context);
                } else
                  return Center(
                    child: Text('Just Wait'),
                  );
              })
        ],
      ),
    );
  }

  Widget dataTable(List data, BuildContext context) {
    // dataRow.clear();
    for (var itemMap in data) {
      dataRow.add(DataRow(cells: [
        DataCell(Text("${itemMap['catName']}")),
        DataCell(Text("${itemMap['brandName']}")),
        DataCell(Text("${itemMap['size']}")),
        DataCell(Text("${itemMap['amount']}")),
        DataCell(Text("${itemMap['amountSold']}")),
        DataCell(Text("${itemMap['buyPrices']}")),
        DataCell(Text("${itemMap['soldPrices']}")),
      ]));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        showBottomBorder: true,
        dividerThickness: 1,
        sortAscending: true,
        columns: [
          DataColumn(
              label: Text("የእቃው ምድብ ${data.length}", style: Style.style1)),
          DataColumn(label: Text("የእቃው አይነት", style: Style.style1)),
          DataColumn(label: Text("መጠን", style: Style.style1)),
          DataColumn(label: Text("ያልተሸጠ እቃ ብዛት", style: Style.style1)),
          DataColumn(label: Text("የተሸጠ እቃ ብዛት", style: Style.style1)),
          DataColumn(label: Text("የተገዛበት ዋጋ ", style: Style.style1)),
          DataColumn(label: Text("መሽጫ ዋጋ ", style: Style.style1)),
        ],
        rows: dataRow,
      ),
    );
  }

  Future<List<Map>> getStoreLevel() async {
    var store = [];
    var keys = storeLevel.keys.toList();
    for (var key in keys) {
      var item = await storeLevel.get(key);
      store.add(item);
    }
    return store;
  }
}
