import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ignore: top_level_function_literal_block
final expenessFutureProvider = FutureProvider<List>((ref) {
  return getListOfExpeness();
});

Future<List> getListOfExpeness() async {
  var expenessBox = Hive.box("expenes");
  var keyList = expenessBox.keys.toList();
  var itemLists = [];
  for (var key in keyList) {
    var items = await expenessBox.get(key);
    // items['eID'] = key;
    // if (Dates.today == items['salesDate']) {
    itemLists.add(items);
    // }
  }
  return itemLists;
}

class ExpenessList extends ConsumerWidget {
  final formKey = GlobalKey<FormState>();
  final expenessBox = Hive.box("expenes");

  @override
  Widget build(BuildContext context, watch) {
    // var futureExpenessList = watch(expenessFutureProvider);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'የወጭ ዝርዝሮች',
            style: Style.style1,
          ),
        ),
        body: Container(
            padding: EdgeInsets.all(15),
            child: ListView(
              
              children: [
                  Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Text(
                      "የወጭ ዝርዝሮች ",
                      style: Style.style1,
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Colors.lightBlue,
                ),
              
                ValueListenableBuilder(
                    valueListenable: expenessBox.listenable(),
                    builder: (context, box, _) {
                      List data = box.values.toList();
                      return dataTable(data, context);
                    }),
              ],
            )

            //  futureExpenessList.when(
            //   data: (data) {
            //     return ListView.builder(
            //         shrinkWrap: true,
            //         itemCount: data.length,
            //         itemBuilder: (context, index) {
            //           return ExpansionTile(
            //             title: Text(
            //                 "የተከፈለበት ምክንያት : ${data[index]['dailyCase']}",
            //                 style: Style.style1),
            //             subtitle: Text(
            //               "የወጭ አይነት: ${data[index]['payementType']}",
            //             ),
            //             // subtitle: Text("የእቃው አይነት ${snapshot.data[index]['brandName']}"),
            //             leading: PopupMenuButton(
            //                 color: Colors.deepPurple,
            //                 initialValue: 0,
            //                 onSelected: (i) {
            //                   if (i == 0) {
            //                     // Utility.editItem(itemMap, context);
            //                     // Navigator.push(context,
            //                     //     MaterialPageRoute(builder: (context) {
            //                     //   // return EditItem(data[index]);
            //                     // }));
            //                   } else if (i == 1) {
            //                     // _EditItemState().editItem( itemMap,context);
            //                     // Utility.showConfirmDialog(
            //                     //     context: context, itemMap: data[index]);
            //                   }
            //                 },
            //                 itemBuilder: (context) {
            //                   return [
            //                     PopupMenuItem(
            //                         value: 0,
            //                         child: Text("Edit",
            //                             style: TextStyle(color: Colors.white))),
            //                     PopupMenuItem(
            //                         value: 1,
            //                         child: Text("Delete",
            //                             style: TextStyle(color: Colors.white))),
            //                   ];
            //                 }),
            //             tilePadding: EdgeInsets.only(left: 20),
            //             children: [
            //               Padding(
            //                 padding: const EdgeInsets.all(10.0),
            //                 child: Container(
            //                   child: Column(
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                       Text(
            //                           "የብር መጠን፡ ${data[index]['paidAmount']} ብር ",
            //                           style: Style.style1),
            //                       Text("የክፍያ ቀን: ${data[index]['date']} ",
            //                           style: Style.style1),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           );
            //         });
            //   },
            //   loading: () => CircularProgressIndicator(),
            //   error: (Object error, StackTrace stackTrace) => Center(
            //       child: Container(
            //           padding: EdgeInsets.all(10),
            //           color: Colors.redAccent,
            //           child: Text("Error in $error"))),
            //   //  error: (,ba)=>Center()
            // )

            // return ListView.builder(
            //     shrinkWrap: true,
            //     itemCount: snapshot.data.length,
            //     itemBuilder: (context, index) {
            //       return ExpansionTile(
            //         title: Text(
            //             "የእቃው አይነት ${snapshot.data[index]['brandName']}",
            //             style: Style.style1),
            //         // subtitle: Text("የእቃው አይነት ${snapshot.data[index]['brandName']}"),
            //         leading: Icon(
            //           Icons.album_rounded,
            //           color: Colors.deepPurpleAccent,
            //         ),
            //         tilePadding: EdgeInsets.only(left: 20),
            //         children: [
            //           Padding(
            //             padding: const EdgeInsets.all(10.0),
            //             child: Container(
            //               child: Column(
            //                 crossAxisAlignment:
            //                     CrossAxisAlignment.start,
            //                 children: [],
            //               ),
            //             ),
            //           ),
            //         ],
            //       );
            //     });

            ));
  }

  Widget dataTable(List data, BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          if (data[index]['deleteStatus'] == 'no') {
            return ExpansionTile(
              title: Text("የተከፈለበት ምክንያት : ${data[index]['dailyCase']}",
                  style: Style.style1),
              subtitle: Text(
                "የወጭ አይነት: ${data[index]['payementType']}",
              ),
              leading: PopupMenuButton(
                  color: Colors.deepPurple,
                  initialValue: 0,
                  onSelected: (i) {
                    if (i == 0) {
                      deleteExpenes(context: context, itemMap: data[index]);
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                          value: 0,
                          child: Text("Delete",
                              style: TextStyle(color: Colors.white))),
                    ];
                  }),
              tilePadding: EdgeInsets.only(left: 20),
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("የብር መጠን፡ ${data[index]['paidAmount']} ብር ",
                            style: Style.style1),
                        Text("የክፍያ ቀን: ${data[index]['date']} ",
                            style: Style.style1),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return SizedBox();
        });
  }

  void deleteExpenes({BuildContext context, itemMap}) {
    var _focusNode = FocusNode();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Delete"),
            content: Text(" ማጥፋት ይፈልጋሉ?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("No"),
                focusNode: _focusNode,
                style: TextButton.styleFrom(
                    side: BorderSide(width: 1, color: Colors.lightBlueAccent)),
              ),
              TextButton(
                onPressed: () async {
                  var id = itemMap['eID'];
                  itemMap['deleteStatus'] = 'yes';
                  expenessBox.put(id, itemMap);
                  if (expenessBox.containsKey(id)) {
                    Navigator.of(context).pop();
                    Utility.showSnakBar(
                        context, "በትክክል ተስርዞል", Colors.greenAccent);
                  } else {
                    Utility.showSnakBar(
                        context,
                        "አልተሰረዘም እባክወትን ለእርዳታ ወደ 0980631983 ይደወሉ ",
                        Colors.redAccent);
                  }
                },
                child: Text("Yes"),
                style: TextButton.styleFrom(
                    side: BorderSide(width: 1, color: Colors.lightBlueAccent)),
              )
            ],
          );
        });
  }
}
