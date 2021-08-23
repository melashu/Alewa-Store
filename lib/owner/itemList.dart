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
  return [];
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
        child: ValueListenableBuilder(
            valueListenable: itemBox.listenable(),
            builder: (context, box, _) {
              List data = box.values.toList();
              watch(itemListStateProvider).state.add(data);
              return dataTable(context);
            }),
      ),
    );
  }

  Widget dataTable(BuildContext context) {
    var data = context.read(itemListStateProvider).state[0];
    return ListView.builder(
        itemCount: data.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (data[index]['deleteStatus'] == 'no') {
            return ExpansionTile(
              subtitle: Text(
                "ሱቅ ላይ ያለው የ እቃ ብዛት: ${data[index]['amount']}",
              ),
              title: Text("የእቃው አይነት ${data[index]['brandName']}",
                  style: Style.style1),
              leading: PopupMenuButton(
                  color: Colors.deepPurple,
                  initialValue: 0,
                  onSelected: (i) {
                    if (i == 0) {
                      // Utility.editItem(itemMap, context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return EditItem(data[index]);
                      }));
                    } else if (i == 1) {
                      // _EditItemState().editItem( itemMap,context);
                      Utility.showConfirmDialog(
                          context: context, itemMap: data[index]);
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
                        Text("መለያ ቁጥር: ${data[index]['itemID']} ",
                            style: Style.style1),
                        Text("የእቃው ምድብ: ${data[index]['catName']}",
                            style: Style.style1),
                        Text("የእቃው አይነት: ${data[index]['brandName']}",
                            style: Style.style1),
                        Text("መጠን: ${data[index]['size']}",
                            style: Style.style1),
                        Text("ብዛት: ${data[index]['amount'].runtimeType}",
                            style: Style.style1),
                        Text(
                            "የተገዛበት ዋጋ: ${data[index]['buyPrices'].runtimeType} ",
                            style: Style.style1),
                        Text("መሽጫ ዋጋ: ${data[index]['soldPrices']} ",
                            style: Style.style1),
                        Text("የተመዘገበብት ቀን: ${data[index]['createDate']} ",
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
}
