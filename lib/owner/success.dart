import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/login.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:boticshop/owner/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:screenshot/screenshot.dart';

class Success extends ConsumerWidget {
  final Map orgMap;
  final screenshotController = ScreenshotController();

  Success(this.orgMap);
  @override
  Widget build(BuildContext context, watch) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            Hive.box("setting").get("orgName"),
            style: Style.style1,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
              child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "የድርጅትዎ ምዝገባ በትክክል ተካሄዶል፡፡",
                      style: Style.style1,
                    ),
                    Spacer(),
                    CircleAvatar(
                      backgroundColor: Colors.greenAccent,
                      child: Icon(
                        Icons.done_all_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(2),
                child: Column(
                  children: [
                    Text("ይህ መረጃ ለሌላ ጊዜ ስለሚስፈልገዎ፡፡\n Gallary ላይ save ያድርጉ",
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold)),
                    Divider(
                      color: Colors.deepPurpleAccent,
                      thickness: 1,
                    ),
                    Text(" የድርጅትዎ ስም፡ ${orgMap['orgName']}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Divider(
                      color: Colors.deepPurpleAccent,
                      thickness: 1,
                    ),
                    Text(
                      '''    
መታወቂያ (Company ID)፡ ${orgMap['orgId']}  

E-mail: ${orgMap['email']}

Phone 1: +251${orgMap['phone1']}

Phone 2: +251${orgMap['phone2']}

Username: ${orgMap['userName']}

Password: ${orgMap['password']}
                    ''',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    Divider(
                      color: Colors.deepPurpleAccent,
                      thickness: 1,
                    ),
                    Row(
                      children: [
                        Text(
                          "Generated By: Mount Technology Group",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w200),
                        ),
                        // Icon(Icons.co)
                      ],
                    )
                  ],
                ),
                decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.deepPurpleAccent, width: 1)),
              ),
              ElevatedButton(
                  onPressed: () async {
                    var image = await screenshotController.captureFromWidget(
                        Utility.saveOrgProfile(orgMap, context));
                    var result =
                        await Utility.saveToGalary(image, "${orgMap['orgId']}");
                    if (result) {
                      Utility.showSnakBar(
                          context, "Saved in Gallary ", Colors.greenAccent);
                    } else {
                      Utility.showSnakBar(
                          context, "Not saved!", Colors.redAccent);
                    }
                  },
                  child: Text("Save to Gallary")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return Login();
                    }));
                  },
                  child: Text("Back to Login Page")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return MainPage();
                    }));
                  },
                  child: Text("Login now")),
            ],
          )),
        ));
  }
}
