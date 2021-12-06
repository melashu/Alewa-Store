import 'package:boticshop/Utility/style.dart';
import 'package:boticshop/ads/ads.dart';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

final itemListStateProvider = StateProvider.autoDispose<List>((ref) {
  var item = Hive.box("item").values.toList();
  return item;
});

final selectedItemStateProvider = StateProvider.autoDispose<List>((ref) {
  var selected = ref.watch(itemListStateProvider).state;
  return selected;
});

class Lower extends ConsumerWidget {
  final setting = Hive.box("setting");
  final itemBox = Hive.box('item');
  final orderController = TextEditingController();
  final pricesController = TextEditingController();
  final transactionBox = Hive.lazyBox("transaction");
  // BannerAd bannerAd = Ads().setAd3();
  // bool isSub = Hive.box("setting").get("isSubscribed");
  @override
  Widget build(BuildContext context, watch) {
    return Scaffold(
      appBar: AppBar(
        title: Text('በማለቅ ላይ ያሉ እቃዎች ዝርዝር'),
      ),
      // bottomNavigationBar: bannerAd != null && !isSub
      //       ? Container(
      //           height: bannerAd.size.height.toDouble(),
      //           width: bannerAd.size.width.toDouble(),
      //           child: AdWidget(
      //             ad: bannerAd,
      //           ),
      //         )
      //       : SizedBox(),
      body: Container(
        child: ListView(
          children: [
            //  !isSub
            //     ? Center(
            //         child: Padding(
            //           padding: const EdgeInsets.all(15.0),
            //           child: Text(
            //           "በቆሚነት አባል ከሆኑ በሆላ ሁሉም ማስታውቂያዎች ከሲስተሙ ይጠፋሉ፡፡",
            //           style: TextStyle(fontSize: 10, color: Colors.redAccent),
            //       ),
            //         ))
            //     : SizedBox(),
                Divider(
                  thickness: 1,
                  color: Colors.lightBlueAccent,
                ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Text(
                  "እነዚህን እቃዎች አስቀድመው ወደ ሱቀዎት ቢያስገቡ የተሻለ ነው፡፡ ",
                  style: Style.style1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.blue,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextFormField(
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
                  labelText: "Search product here ",
                  labelStyle: Style.style1,
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
            dataTable(watch(selectedItemStateProvider).state)
            // ValueListenableBuilder(
            //     valueListenable: itemBox.listenable(),
            //     builder: (context, box, _) {
            //       List data = box.values.toList();
            //       return dataTable(context, data);
            //     }),
          ],
        ),
      ),
    );
  }

  Widget dataTable(selectedItem) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListView.builder(
          itemCount: selectedItem.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            if (selectedItem[index]['deleteStatus'] == 'no' &&
                int.parse(selectedItem[index]['amount'].toString()) > 0 &&
                int.parse(selectedItem[index]['amount'].toString()) <
                    int.parse(selectedItem[index]['level'].toString())) {
              return ExpansionTile(
                collapsedTextColor: Colors.white,
                collapsedBackgroundColor: Colors.redAccent,
                collapsedIconColor: Colors.white,
                subtitle: Text(
                  "እቃ ብዛት: ${selectedItem[index]['amount']}",
                ),
                title: Text(
                    "የእቃው አይነት  ${selectedItem[index]['brandName']}, ${selectedItem[index]['catName']}",
                    style: Style.style1),
                // tilePadding: EdgeInsets.only(left: 20),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "የእቃው አይነት ፡ ${selectedItem[index]['brandName']} ቁጥር ${selectedItem[index]['size']}",
                            style: Style.style1,
                          ),
                          Text(
                            "የተገዛበት ዋጋ ፡ ${selectedItem[index]['buyPrices']} ብር",
                            style: Style.style1,
                          ),
                          Text(
                              "መሽጫ ዋጋ ፡ ${selectedItem[index]['soldPrices']} ብር",
                              style: Style.style1),
                          // Text("የተሸጠው እቃ ብዛት ፡ ${selectedItem[index]['amount']}",
                          //     style: Style.style1),
                          // Text(
                          //     "የሽያጭ ባለሙያው ስም ፡ ${selectedItem[index]['salesPerson']}",
                          //     style: Style.style1),
                          // Text(
                          //     "ልዮነት ፡ ${int.parse(selectedItem[index]['soldPrices']) - int.parse(selectedItem[index]['buyPrices'])} ብር",
                          //     style: Style.style1),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return SizedBox();
          }),
    );
  }
}
