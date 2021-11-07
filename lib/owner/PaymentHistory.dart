import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/date.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:boticshop/https/orgprof.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

var futureProvider = FutureProvider.autoDispose<List>((ref) async {
  return OrgProfHttp().getPaymentHistory();
});

class PaymentHistory extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    var total = 0.0;
    var futureAgreement = watch(futureProvider);
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: Utility.getBoxDecoration(),
            child: Center(
              child: Text(
                'የክፍያ ታሪኳች',
                style: Style.mainStyle1,
              ),
            ),
            width: 100,
            height: 50,
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(10),
          ),
          futureAgreement.when(data: (result) {
            // if (result.length == 0) {}
            if (result.length == 0) {
              return Center(
                  child: Text(
                "ከዚህ በፊት የአገልግሎት ክፍያ አልነበረብዎትም ",
                style: Style.style1,
              ));
            }
            return ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  total = total + double.parse(result[i]['amount'].toString());

                  return Container(
                    child: Text(
                      '''
                ወር፡ ${result[i]['registerDate']} to  ${Dates.upToDate(result[i]['registerDate'])}
                የእድሳት ሁኔታ፡ ታድሶል 
                የክፍያ ሁኔታ፡ ተከፍሎል
                የክፍያ መጠን፡ ${result[i]['amount']} 
               ${result.length == i + 1 ? '   ====================================\n                    አጠቃላይ ክፍያ፡ $total ብር' : ''} 

                ''',
                      style: Style.style1,
                    ),
                  );
                },
                itemCount: result.length);
          }, loading: () {
            return Center(
              child: CircularProgressIndicator(),
            );
          }, error: (er, a) {
            // print(a);
            return Center(
              child: Container(
                width: 200,
                height: 100,
                padding: EdgeInsets.all(10),
                decoration: Utility.getBoxDecoration(),
                child: Center(
                  child: Text(
                    "ይህን አገልግሎት በሚጠቀሙበት ጊዜ wifi or Data ያስፈልገዉታል፡፡",
                    style: Style.style1,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }),
          Divider(
            color: Colors.blueAccent,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_left),
                label: Text('Back')),
          )
        ],
      ),
    );
  }
}
