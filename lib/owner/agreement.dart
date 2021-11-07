import 'dart:async';
import 'dart:math';

import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/date.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:boticshop/https/orgprof.dart';
import 'package:boticshop/owner/MainPage.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

var futureProvider = FutureProvider.autoDispose<Map>((ref) async {
  return OrgProfHttp().getAgreement();
});

class Agre extends ConsumerWidget {
  final bool isForInfo;
  Agre({this.isForInfo});
  @override
  Widget build(BuildContext context, watch) {
    var futureAgreement = watch(futureProvider);
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 20,
          ),
          futureAgreement.when(data: (result) {
            return ListView(shrinkWrap: true, 
            physics: ClampingScrollPhysics(),
            children: [
              Center(
                child: Text(
                  result['maintitle'] == null
                      ? "ይቅርታ ለጊዜው የስምምነት ሰነዱ አልተዘጋጀም"
                      : result['maintitle'],
                  style: Style.agree1,
                ),
              ),
              Divider(
                color: Colors.blueAccent,
                thickness: 1,
              ),
              Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.all(10),
                child: Text(
                  result['mainmessage'] == null
                      ? "ይቅርታ ለጊዜው የስምምነት ሰነዱ አልተዘጋጀም"
                      : result['mainmessage'],
                  style: Style.agree1,
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                  child: Text(
                result['paymenttitle'] == null
                    ? "ይቅርታ ለጊዜው የስምምነት ሰነዱ አልተዘጋጀም"
                    : result['paymenttitle'],
                // result['paymenttitle'],
                style: Style.agree1,
              )),
              Divider(
                color: Colors.blueAccent,
                thickness: 1,
              ),
              Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.all(10),
                child: Text(
                  result['paymentmessage'] == null
                      ? "ይቅርታ ለጊዜው የስምምነት ሰነዱ አልተዘጋጀም"
                      : result['paymentmessage'],
                  // result['paymentmessage'],
                  style: Style.agree1,
                  textAlign: TextAlign.justify,
                ),
              ),
              Divider(
                color: Colors.blueAccent,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: ElevatedButton(
                    onPressed: () async {
                      var phone = '+251986806930';
                      var url = 'tel:$phone';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        Utility.showDangerMessage(
                            context, "ይቅርታ ወደ $phone መደውል አልቻልኩም፡፡");
                      }
                    },
                    child: Text("ያልገባኝ ነገር አለ 1")),
              ),
              isForInfo
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            var amount = result['amount'];
                            var paymentBox = Hive.box('payment');
                            ConfirmAlertBox(
                                context: context,
                                title: "ማረጋገጫ",
                                infoMessage: "በቋሚነት አባል መሆን ይፈልጋሉ?",
                                onPressedYes: () async {
                                  if (await Utility.isConnection()) {
                                    var orgId =
                                        Hive.box('setting').get("orgId");
                                    var today = Dates.today;
                                    Navigator.of(context).pop();
                                    var random = Random();
                                    var monthID =
                                        random.nextInt(1000000).toString();

                                    /**
                                           * Showing progress indicator 
                                           */
                                    Utility.showProgress(context);
                                    /**
                                         * Save the payment information on 
                                         * remote database 
                                         */
                                    var result = await OrgProfHttp()
                                        .inserPaymentInfo(
                                            orgId, today, amount, monthID);
                                    if (result) {
                                      /**
                                       * Register the payment record on local 
                                       * device with paymentBox 
                                       */
                                      paymentBox.put('month', {
                                        "date": today,
                                        "isRequest": false,
                                        "paidStatus": 'no',
                                        "monthID": monthID,
                                        "renewStatus": 'no',
                                        "amount": amount
                                      });
                                      Hive.box("setting")
                                          .put("isSubscribed", true);
                                      Utility.infoMessage(context,
                                          "እናመሰናለን ከ ቀን $today ጀምሮ በቋሚነት የ Mount Technology Group አባል ሁነዎል፡፡ ");
                                      Timer(Duration(seconds: 2), () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return MainPage();
                                        }));
                                      });
                                    }
                                  } else {
                                    Utility.showDangerMessage(context,
                                        "ይህን አገልግሎት በሚፈልጉበት ጊዜ wifi or Data ያስፈልገዉታል፡፡");
                                  }
                                });
                          },
                          child: Text("አባል ለመሆን ተስማምቻለሁ")),
                    ),
            ]);
          }, loading: () {
            return Center(
              child: CircularProgressIndicator(),
            );
          }, error: (er, a) {
            return Center(
              child: Container(
                width: 200,
                height: 100,
                padding: EdgeInsets.all(10),
                decoration: Utility.getBoxDecoration(),
                child: Center(
                  child: Text(
                    "ቋሚ አባል በሚሆኑበት ጊዜ wifi or Data ያስፈልገዉታል፡፡  ",
                    style: Style.style1,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
