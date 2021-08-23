import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/style.dart';
import "package:flutter/material.dart";
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final levelFutureProvider = FutureProvider<List>((ref) {
  return getStoreLevel();
});

Future<List> getStoreLevel() async {
  var store = [];
  final storeLevel = Hive.lazyBox("totalitem");

  var keys = storeLevel.keys.toList();
  for (var key in keys) {
    var item = await storeLevel.get(key);
    store.add(item);
  }
  return store;
}

class StoreLevel extends ConsumerWidget {
  final setting = Hive.box("setting");
  final dataRow = <DataRow>[];
  final filltered = [];
  @override
  Widget build(BuildContext context, watch) {
    var leverProvider = watch(levelFutureProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text(setting.get("orgName")),
        ),
        persistentFooterButtons: [
          OutlinedButton(
            child: Text("በሱቁ ውስጥ ያለው አጠቃላይ ሀብት በ ብር"),
            style: Style.outlinedButtonStyle,
            onPressed: () async {
              Utility.showTotalAssetinBirr(context);
            },
          )
        ],
        body: ListView(children: [
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
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: leverProvider.when(
                  data: (dataList) => ListView.builder(
                      shrinkWrap: true,
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        // var dataList = data.data;
                        return ExpansionTile(
                          subtitle: Text(
                            "ሱቅ ላይ ያለው የ እቃ ብዛት: ${dataList[index]['amount']}",
                          ),
                          title: Text("የእቃው ምድብ ${dataList[index]['catName']}",
                              style: Style.style1),
                          leading: Icon(Icons.arrow_right_outlined),
                          tilePadding: EdgeInsets.only(left: 20),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "መለያ ቁጥር: ${dataList[index]['itemID']} ",
                                        style: Style.style1),
                                    Text(
                                        "የእቃው አይነት: ${dataList[index]['brandName']}",
                                        style: Style.style1),
                                    Text("መጠን: ${dataList[index]['size']}",
                                        style: Style.style1),
                                    Text(
                                        "ያልተሸጠው የእቃ ብዛት: ${dataList[index]['amount']}",
                                        style: Style.style1),
                                    Text(
                                        "የተሸጠው የእቃ ብዛት: ${dataList[index]['amountSold']}",
                                        style: Style.style1),
                                    Text(
                                        "የተገዛበት ዋጋ: ${dataList[index]['buyPrices']} ",
                                        style: Style.style1),
                                    Text(
                                        "መሽጫ ዋጋ: ${dataList[index]['soldPrices']} ",
                                        style: Style.style1),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                  loading: () => Center(
                        child: CircularProgressIndicator(),
                      ),
                  error: (message, er) => Text("Error: $er"))),
        ]));
  }

  Widget dataTable(List data, BuildContext context) {
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
}
