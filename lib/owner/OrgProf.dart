import 'dart:async';
import 'dart:math';

import 'package:boticshop/Utility/Boxes.dart';
import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/date.dart';
import 'package:boticshop/Utility/location.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:boticshop/https/orgprof.dart';
import 'package:boticshop/owner/success.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
// import 'package:sn_progress_dialog/sn_progress_dialog.dart';
// import 'package:geocoding/geocoding.dart';

class OrgProf extends ConsumerWidget {
  final setting = Hive.box("setting");
  final orgNameController = TextEditingController();
  final ownerController = TextEditingController();
  final phone1Controller = TextEditingController();
  final phone2Controller = TextEditingController();
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final userBox = Hive.box('useraccount');
  final FocusNode phone2Focus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, watch) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          flexibleSpace: FlexibleSpaceBar(
            title: Text('እንኳን ደህና መጡ\nስናገለግለዎ ኩራት ይሰማናል::',
                style: TextStyle(), textAlign: TextAlign.center),
          ),
          stretch: true,
          expandedHeight: 200,
          backgroundColor: Colors.deepPurple,
          primary: true,
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.deepPurpleAccent,
                        width: 1,
                      )),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "እባክዎትን ድርጅትዎን ይመዝግቡ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.deepPurpleAccent,
                    thickness: 1,
                  ),
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextFormField(
                            autocorrect: true,
                            autofocus: true,
                            style: Style.style1,
                            controller: orgNameController,
                            enableSuggestions: true,
                            textInputAction: TextInputAction.next,
                            validator: (val) {
                              if (val.isEmpty)
                                return "እባክዎትን የድርጅትዎ ስም ያስገቡ";
                              else if (val.length < 5) {
                                return "የድርጅዎት ስም 5 ፊደል በላይ መሆን አለበት፡፡ ";
                              } else
                                return null;
                            },
                            decoration: InputDecoration(
                                labelText: 'የድርጅትዎ ስም',
                                hintText: 'የድርጅትዎ ስም',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                labelStyle: Style.style1,
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(5)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            autocorrect: true,
                            style: Style.style1,
                            controller: ownerController,
                            enableSuggestions: true,
                            validator: (val) {
                              if (val.isEmpty)
                                return "Enter owner name ";
                              else
                                return null;
                            },
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                labelText: 'የድርጅቱ ባለቤት ስም',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                hintText: 'የድርጅቱ ባለቤት ስም',
                                // hintStyle: Style.style1,
                                labelStyle: Style.style1,
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(5)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            autocorrect: true,
                            style: Style.style1,
                            keyboardType: TextInputType.phone,
                            controller: phone1Controller,
                            enableSuggestions: true,
                            validator: (val) {
                              if (val.isEmpty)
                                return "Please enter phone number  ";
                              else if (!val.startsWith("9"))
                                return "Number must start with 9";
                              else if (val.length < 9)
                                return '${9 - val.length} digit left';
                              else if (val.length > 9)
                                return "Wrong Digit";
                              else if (val.length == 9)
                                phone2Focus.requestFocus();
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            onChanged: (val) {
                              formKey.currentState.validate();
                            },
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                prefixText: '+251',
                                prefixStyle: Style.style1,
                                labelText: 'ስልክ  ቁጥር 1',
                                hintText: 'የድርጅቱን ባለቤት ስልክ ቁጥር ያስገቡ',
                                // hintStyle: Style.style1,
                                labelStyle: Style.style1,
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(5)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            style: Style.style1,
                            focusNode: phone2Focus,
                            autocorrect: true,
                            keyboardType: TextInputType.phone,
                            controller: phone2Controller,
                            enableSuggestions: true,
                            validator: (val) {
                              if (val.isEmpty)
                                return null;
                              else if (!val.startsWith("9"))
                                return "Number must start with 9";
                              else if (val.length < 9)
                                return '${9 - val.length} digit ይቀራል';
                              else if (val.length > 9)
                                return "Wrong Digit";
                              else if (val.length == 9)
                                emailFocus.requestFocus();
                              return null;
                            },
                            onChanged: (val) {
                              formKey.currentState.validate();
                            },
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                prefixText: '+251',
                                prefixStyle: Style.style1,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                labelText: 'ስልክ  ቁጥር 2',
                                hintText: 'ቀያሪ ስልክ ቁጥር ያስገቡ',
                                // hintStyle: Style.style1,
                                labelStyle: Style.style1,
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(5)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            style: Style.style1,
                            focusNode: emailFocus,
                            autocorrect: true,
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            enableSuggestions: true,
                            validator: (val) {
                              if (!val.contains('@'))
                                return '$val is not valid e-mail address';
                              else if (val.endsWith('@'))
                                return '$val is not valid e-mail address';
                              else if (!val.endsWith('.com'))
                                return '$val is not valid e-mail address';
                              else
                                return null;
                            },
                            onChanged: (val) {
                              formKey.currentState.validate();
                            },
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                labelText: 'ኢሜል ',
                                hintText: 'ኢሜል ያስገቡ',
                                // hintStyle: Style.style1,
                                labelStyle: Style.style1,
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(5)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            autocorrect: true,
                            style: Style.style1,
                            controller: userNameController,
                            enableSuggestions: true,
                            validator: (val) {
                              if (val.isEmpty)
                                return "Enter user name ";
                              else if (userBox.containsKey(val)) {
                                return "Username " + val + " exist";
                              } else
                                return null;
                            },
                            textInputAction: TextInputAction.next,
                            //  onChanged: (val) {
                            //   formKey.currentState.validate();
                            // },
                            decoration: InputDecoration(
                                labelText: 'Username',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                hintText: 'Like Meshu',
                                // hintStyle: Style.style1,
                                labelStyle: Style.style1,
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(5)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            autocorrect: true,
                            style: Style.style1,
                            controller: passwordController,
                            enableSuggestions: true,
                            obscureText: true,
                            validator: (val) {
                              if (val.isEmpty)
                                return "Enter password ";
                              else
                                return null;
                            },
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                // suffixIcon: ,
                                labelText: 'Password',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                hintText: 'Like abc#123',
                                // hintStyle: Style.style1,
                                labelStyle: Style.style1,
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(5)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.deepPurpleAccent,
                    thickness: 1,
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () async {
                ConnectivityResult connectivityResult =
                    await Connectivity().checkConnectivity();
                if (formKey.currentState.validate()) {
                  if (connectivityResult != ConnectivityResult.none) {
                    var orgBox = await Boxes.getOrgProfileBox();
                    var orgName = orgNameController.text;
                    var ownerName = ownerController.text;
                    var phone1 = phone1Controller.text;
                    var phone2 = phone2Controller.text;
                    var email = emailController.text;
                    var userName = userNameController.text;
                    var password = passwordController.text;
                    var random = Random();
                    var prefix = orgName.substring(0, 3).toUpperCase();
                    var orgId = prefix + "-${random.nextInt(1000000)}";
                    var registrationDate = Dates.today;
                    var id = random.nextInt(1000).toString();
                    /**
                   * business type=== 001 
                   * means Botic Fashion Center 
                   */
                    var businessType = "001";
                    try {
                      var position = await Locations.getCurrentLocation();
                      var latitude = position.latitude;
                      var longtitude = position.longitude;
                      var altitude = position.altitude;
                      var orgMap = {
                        'orgName': orgName,
                        'ownerName': ownerName,
                        'phone1': phone1,
                        'phone2': phone2,
                        'email': email,
                        'userName': userName,
                        'password': password,
                        'orgId': orgId,
                        'registrationDate': registrationDate,
                        'latitude': latitude.toString(),
                        'longtitude': longtitude.toString(),
                        'altitude': altitude.toString(),
                        'businessType': businessType,
                        "role": "Owner",
                        "fullName": ownerName,
                        "usreName": userName,
                        "loginStatus": '1',
                        'productVersion': '0.0.1',
                        'lastLogin': Dates.today,
                        'isActive': '1'
                      };
                      ProgressDialog pd = ProgressDialog(context: context);
                      pd.show(
                          max: 100,
                          msg: "Wait...",
                          backgroundColor: Colors.deepPurpleAccent,
                          barrierDismissible: true,
                          borderRadius: 20,
                          msgColor: Colors.white,
                          msgFontSize: 14,
                          progressBgColor: Colors.white,
                          valuePosition: ValuePosition.center,
                          progressType: ProgressType.valuable);
                      var result = await OrgProfHttp().insertOrgProf(orgMap);
                      if (result == "ok") {
                        var message =
                            connectivityResult == ConnectivityResult.mobile
                                ? " የሞባይል ዳታዎን ማጥፋት ይችላሉ፡፡"
                                : '';
                        SuccessAlertBoxCenter(
                            context: context,
                            messageText: 'ድርጅትዎ በትክክል ተመዝግቦል፡፡ \n' + message,
                            buttonColor: Colors.deepPurpleAccent,
                            buttonText: 'Ok',
                            titleTextColor: Colors.deepPurple);

                        var userList = {
                          'orgId': orgId,
                          "role": "Owner",
                          "fullName": ownerName,
                          "usreName": userName,
                          "password": password,
                          "loginStatus": '1'
                        };
                        orgBox.put(id, orgMap);
                        if (orgBox.containsKey(id)) {
                          Hive.box("setting").put("isLocal", true);
                          Hive.box("setting").put("orgName", orgName);
                          Hive.box("setting").put("orgId", orgId);
                          Hive.box("setting").put('deviceUser', userName);
                          userBox.put(userName, userList);
                          Timer(Duration(seconds: 3), () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return Success(orgMap);
                            }));
                          });
                        }
                      } else {
                        DangerAlertBoxCenter(
                            context: context,
                            messageText: result +
                                " እባክወትን ለእርዳታ ወድ +251980631983 ይደውሉ ");
                      }
                    } catch (e) {
                      // print(e);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.redAccent,
                        duration: Duration(minutes: 1),
                        content: Text("$e Please turn on your location"),
                        action: SnackBarAction(
                          label: 'Turn on ',
                          onPressed: () async {
                            await Geolocator.openLocationSettings();
                          },
                          textColor: Colors.white,
                        ),
                      ));
                    }
                  } else {
                    Utility.infoMessage(context,
                        "ድርጅትዎን በሚመዘግቦበት ጊዜ wifi or Data ያስፈልገዉታል፡፡   ");
                  }
                }
              },
              child: Text("Save"),
              style: Style.elevatedButtonStyle,
            ),
          )
        ])),
      ],
    ));
  }
}
