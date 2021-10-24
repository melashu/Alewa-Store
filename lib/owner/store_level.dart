import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:boticshop/https/Item.dart';
import 'package:boticshop/owner/MainPage.dart';
import "package:flutter/material.dart";
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pdf/widgets.dart';

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

// final selectedLevelFutureProvider = FutureProvider<List>((ref) {
//   var se = [];
//   ref.watch(levelFutureProvider).whenData((value) {
//     se = value;
//   });
//   // return se;
// });

class StoreLevel extends ConsumerWidget {
  final setting = Hive.box("setting");
  final dataRow = <DataRow>[];
  final filltered = [];
  @override
  Widget build(BuildContext context, watch) {
    var leverProvider = watch(levelFutureProvider);
    return Scaffold(
        appBar: AppBar(
          title: Utility.getTitle(),
        ),
        // persistentFooterButtons: [
        //   OutlinedButton(
        //     child: Text("በሱቁ ውስጥ ያለው አጠቃላይ ሀብት በ ብር"),
        //     style: Style.outlinedButtonStyle,
        //     onPressed: () async {
        //       Utility.showTotalAssetinBirr(context);
        //     },
        //   )
        // ],
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Text(
                " በቀለም ፤ በመጠን ፤ በዋጋ ተመሳሳይ የሆኑ እቃዎች ብዛት ",
                style: Style.style1,
                textAlign: TextAlign.center,
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
                  data: (dataList) {
                    if (dataList.length == 0) {
                      return ElevatedButton(
                          onPressed: () async {
                            if (await Utility.isConnection()) {
                              SyncItem.getTotalItem().then((value) =>
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return MainPage();
                                  })));
                            } else {
                              Utility.showDangerMessage(context,
                                  "ይህን አገልግሎት በሚፈልጉበት ጊዜ wifi or Data ያስፈልገዉታል፡፡");
                            }
                          },
                          child: Text('እባክዎትን ይህን ይጫኑ'),
                          style: Style.elevatedButtonStyle);
                    } else
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: dataList.length,
                          itemBuilder: (context, index) {
                            return ExpansionTile(
                              subtitle: Text(
                                "ሱቅ ላይ ያለው የ እቃ ብዛት: ${dataList[index]['amount']}",
                              ),
                              title: Text(
                                  "የእቃው ምድብ ${dataList[index]['catName']}",
                                  style: Style.style1),
                              leading: Icon(Icons.arrow_right_outlined,
                                  color: Colors.deepPurpleAccent),
                              tilePadding: EdgeInsets.only(left: 20),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                          });
                  },
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
