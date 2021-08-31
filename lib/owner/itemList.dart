import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:boticshop/owner/Home.dart';
import 'package:boticshop/owner/Transaction.dart';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'editItem.dart';

final itemListStateProvider = StateProvider<List>((ref) {
  return Hive.box("item").values.toList();
});

final selectedItemStateProvider = StateProvider<List>((ref) {
  var selected = ref.watch(itemListStateProvider).state;
  return selected;
});

class ItemList extends ConsumerWidget {
  final setting = Hive.box("setting");
  final itemBox = Hive.box('item');

  @override
  Widget build(BuildContext context, watch) {
    return Scaffold(
      appBar: AppBar(
        title: Text(setting.get("orgName")),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded),
            onPressed: () {},
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepPurple,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        selectedLabelStyle: TextStyle(
            color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(
            color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
        iconSize: 40,
        elevation: 10,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'ዋና',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: 'የእቃዎች ዝርዝር',
            // title:
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.deepPurpleAccent,
            icon: Icon(Icons.report),
            label: 'ዕለታዊ የሽያጭ ሪፖርት',
            // title:
          ),
        ],
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Home();
            }));
          } else if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ItemList();
            }));
          } else if (index == 2) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Transaction();
            }));
          }
        },
      ),
      body: Container(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Text(
                  "እቃዎች ዝርዝር ",
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
                onChanged: (val) {
                  List filtered = [];
                  if (val.isEmpty) {
                    filtered = watch(itemListStateProvider).state;
                  } else {
                    var itemes = watch(itemListStateProvider).state;
                    filtered = itemes
                        .where((row) =>
                            (row['brandName']
                                .toString()
                                .toLowerCase()
                                .contains(val.toLowerCase())) ||
                            (row['catName']
                                .toString()
                                .toLowerCase()
                                .contains(val.toLowerCase())))
                        .toList();
                  }
                  watch(selectedItemStateProvider).state = filtered;
                },
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
                  // List data = box.values.toList();
                  // watch(itemListStateProvider).state.add(data);
                  return dataTable(context);
                }),
          ],
        ),
      ),
    );
  }

  Widget dataTable(BuildContext context) {
    var selectedItem = context.read(selectedItemStateProvider).state;
    return ListView.builder(
        itemCount: selectedItem.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          if (selectedItem[index]['deleteStatus'] == 'no' &&
              int.parse(selectedItem[index]['amount'].toString()) > 0) {
            return ExpansionTile(
              subtitle: Text(
                "ሱቅ ላይ ያለው የ እቃ ብዛት: ${selectedItem[index]['amount']}",
              ),
              title: Text("የእቃው አይነት ${selectedItem[index]['brandName']}",
                  style: Style.style1),
              leading: PopupMenuButton(
                  color: Colors.deepPurple,
                  initialValue: 0,
                  onSelected: (i) {
                    if (i == 0) {
                      // Utility.editItem(itemMap, context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return EditItem(selectedItem[index]);
                      }));
                    } else if (i == 1) {
                      // _EditItemState().editItem( itemMap,context);
                      Utility.showConfirmDialog(
                          context: context, itemMap: selectedItem[index]);
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
                  }),
              tilePadding: EdgeInsets.only(left: 20),
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("መለያ ቁጥር: ${selectedItem[index]['itemID']} ",
                            style: Style.style1),
                        Text("የእቃው ምድብ: ${selectedItem[index]['catName']}",
                            style: Style.style1),
                        Text("የእቃው አይነት: ${selectedItem[index]['brandName']}",
                            style: Style.style1),
                        Text("መጠን: ${selectedItem[index]['size']}",
                            style: Style.style1),
                        Text("ብዛት: ${selectedItem[index]['amount']}",
                            style: Style.style1),
                        Text("የተገዛበት ዋጋ: ${selectedItem[index]['buyPrices']} ",
                            style: Style.style1),
                        Text("መሽጫ ዋጋ: ${selectedItem[index]['soldPrices']} ",
                            style: Style.style1),
                        Text(
                            "የተመዘገበብት ቀን: ${selectedItem[index]['createDate']} ",
                            style: Style.style1),
                        OutlinedButton(
                          onPressed: () async {
                            showDialog(context: context, builder: (context) {});
                          },
                          child: Text(
                            "Order",
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
            );
          }
          return SizedBox();
        });
  }
}
