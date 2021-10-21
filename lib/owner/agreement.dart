import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/date.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:boticshop/https/orgprof.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

var futureProvider = FutureProvider<Map>((ref) async {
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
            return ListView(shrinkWrap: true, children: [
              Center(
                child: Text(
                  result['maintitle'],
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
                  result['mainmessage'],
                  style: Style.agree1,
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                  child: Text(
                result['paymenttitle'],
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
                  result['paymentmessage'],
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
                    child: Text("ያልገባኝ ነገር አለ")),
              ),
              isForInfo
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18),
                      child: ElevatedButton(
                          onPressed: () async {
                            ConfirmAlertBox(
                                context: context,
                                title: "ማረጋገጫ",
                                infoMessage: "በቋሚነት አባል መሆን ይፈልጋሉ?",
                                onPressedYes: () async {
                                  var orgId = Hive.box('setting').get("orgId");
                                  var today = Dates.today;
                                  Navigator.of(context).pop();
                                  var result = await OrgProfHttp()
                                      .inserPaymentInfo(orgId, today);
                                  if (result) {
                                    Hive.box("setting")
                                        .put("isSubscribed", true);
                                    Utility.infoMessage(context,
                                        "እናመሰናለን ከ ቀን $today ጀምሮ በቋሚነት የ Mount Technology አባል ሁነዎል፡፡ ");
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
