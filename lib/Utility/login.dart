import 'dart:convert';

import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/https/login.dart';
import 'package:boticshop/https/orgprof.dart';
import 'package:boticshop/owner/MainPage.dart';
import 'package:boticshop/owner/OrgProf.dart';
import 'package:boticshop/sales/Home.dart' as sales;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:hive/hive.dart';

class Login extends StatefulWidget {
  // const MainLogin({ Key? key }) : super(key: key);

  @override
  _MainLoginState createState() => _MainLoginState();
}

class _MainLoginState extends State<Login> {
  // const RequiredItem({ Key key }) : super(key: key);
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final companyIDController = TextEditingController();
  final userBox = Hive.box('useraccount');

  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((event) async {
      if (event == ConnectivityResult.mobile ||
          event == ConnectivityResult.wifi) {
        var orgId = Hive.box("setting").get("orgId");
        // print(orgId);
        if (orgId != null) {
      
          OrgProfHttp().getSubStatus(orgId);
          if (!Hive.box('setting').get("isWorkingLoc")) {
            OrgProfHttp().updateLocation(orgId);
            Hive.box('setting').put("isWorkingLoc", true);
          }

          // print("Updated");
        }
        print("Now you are connected with network");
        // SyncItem().syncInsertItemList(context);
        // SyncItem().syncUpdateItem(context);
        // SyncItem().syncDeleteItem(context);
        // SyncItem.getTotalItem();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // watch.call();
    var loginStatus = Hive.box("setting").get("isLocal") == null;
    return Scaffold(
      body: Container(
        color: Colors.amberAccent,
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                // color: Colors.deepPurpleAccent,
                // image: DecorationImage(image: AssetImage("images/login.jpg")),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(150),
                ),
              ),
              child: Center(
                  child: Text("Welcome to ${Hive.box('setting').get('orgName')}",
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontFamily: '',
                          fontSize: 20,
                          fontWeight: FontWeight.bold))),
            ),
            Container(
              width: double.infinity,
              // color: Colors.blueAccent

              height: MediaQuery.of(context).size.height * 0.8,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 40,
                  right: 10,
                  top: 110,
                ),
                child: Form(
                    key: formKey,
                    child: ListView(
                      children: [
                        Visibility(
                          visible: loginStatus,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: TextFormField(
                              controller: companyIDController,
                              onChanged: (val) {},
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "Please Enter Your Company ID";
                                }

                                return null;
                              },
                              textInputAction: TextInputAction.next,
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                  // fillColor: Colors.white,
                                  labelText: "Company ID",
                                  labelStyle: TextStyle(color: Colors.white),
                                  hintText: 'mds-4556',
                                  fillColor: Colors.red,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 2)),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: loginStatus,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: TextFormField(
                              controller: userNameController,
                              onChanged: (val) {},
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "Please Enter Username";
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                  // fillColor: Colors.white,
                                  labelText: "Enter Username",
                                  labelStyle: TextStyle(color: Colors.white),
                                  hintText: 'Like. Mom123',
                                  fillColor: Colors.red,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 2)),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: TextFormField(
                            controller: passwordController,
                            textInputAction: TextInputAction.next,
                            onChanged: (val) {
                              // if (formKey.currentState.validate()) {}
                            },
                            validator: (val) {
                              if (val.isEmpty) {
                                return "Please Enter Password";
                              }
                              return null;
                            },
                            obscureText: true,
                            obscuringCharacter: '*',
                            decoration: InputDecoration(
                                labelText: "Enter Password",
                                hintText: 'Like. abc#123',
                                labelStyle: TextStyle(color: Colors.white),
                                suffixIcon: Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.white,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2)),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () async {
                            if (loginStatus) {
                              if (formKey.currentState.validate()) {
                                var userName = userNameController.text;
                                var password = passwordController.text;
                                var orgId = companyIDController.text;

                                ConnectivityResult connectivityResult =
                                    await Connectivity().checkConnectivity();
                                if (connectivityResult !=
                                    ConnectivityResult.none) {
                                  var userMap = {
                                    'userName': userName,
                                    'orgId': orgId.toUpperCase(),
                                    'action': 'login'
                                  };
                                  Utility.showProgress(context);
                                  var result =
                                      await Logins().userLogin(userMap);

                                  var dataList = result == 'notOk'
                                      ? null
                                      : jsonDecode(result) as List;
                                  if (dataList != null) {
                                    var data = dataList[0];
                                    var dbpassword = data['password'];
                                    var role = data['role'];
                                    var isActive = data['isActive'];
                                    var orgName = data['orgName'];
                                    if (password == dbpassword) {
                                      if (isActive != 1) {
                                        if (role.toString().toLowerCase() ==
                                            'owner') {
                                          Hive.box("setting")
                                              .put("deviceUser", userName);
                                          Hive.box("setting")
                                              .put("isLocal", true);
                                          Hive.box("setting")
                                              .put("orgName", orgName);
                                          Hive.box("setting")
                                              .put("orgId", orgId);
                                          userBox.put(userName, data);
                                          OrgProfHttp().getSubStatus(orgId);

                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return MainPage();
                                          }));
                                        } else if (role
                                                .toString()
                                                .toLowerCase() ==
                                            'sales') {
                                          Hive.box("setting")
                                              .put("deviceUser", userName);
                                          Hive.box("setting")
                                              .put("isLocal", true);
                                          Hive.box("setting")
                                              .put("orgName", orgName);
                                          Hive.box("setting")
                                              .put("orgId", orgId);
                                          userBox.put(userName, data);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return sales.Home();
                                          }));
                                        }
                                      } else {
                                        Utility.showSnakBar(
                                            context,
                                            "ለጊዜዎ መጠቀም አይችሉም፡፡ እባክዎትን ወደ 0980631983 ይደውሉ",
                                            Colors.redAccent);
                                      }
                                    } else {
                                      Utility.showSnakBar(
                                          context,
                                          "Password ተሳስተዎል፡፡",
                                          Colors.redAccent);
                                    }
                                  } else {
                                    Utility.showSnakBar(
                                        context,
                                        "Username ወይም Company ID ተሳስተዋል፡፡",
                                        Colors.redAccent);
                                  }
                                } else {
                                  InfoAlertBoxCenter(
                                    context: context,
                                    title: "Wifi / Mobile Data",
                                    infoMessage:
                                        "ለመጀመሪያ ጊዜ እየገቡ ሰለሆነ Wifi / Mobile data ያስፈልገዎታል፡፡   ",
                                    buttonText: 'Ok',
                                    buttonColor: Colors.deepPurpleAccent,
                                    titleTextColor: Colors.deepPurple,
                                  );
                                }

                                // if (userBox.containsKey(userName)) {
                                //   var selectedUser = userBox.get(userName);
                                //   if (password == selectedUser['password']) {
                                //     var role = selectedUser['role'];
                                //     if (role.toString().toLowerCase() ==
                                //         'owner') {
                                //       Hive.box("setting")
                                //           .put("deviceUser", userName);
                                //       Navigator.of(context).push(
                                //           MaterialPageRoute(builder: (context) {
                                //         return owner.Home();
                                //       }));
                                //     } else if (role.toString().toLowerCase() ==
                                //         'sales') {
                                //       Hive.box("setting")
                                //           .put("deviceUser", userName);
                                //       Navigator.of(context).push(
                                //           MaterialPageRoute(builder: (context) {
                                //         return sales.Home();
                                //       }));
                                //     }
                                //   } else {
                                //     Utility.showSnakBar(context,
                                //         "Wrong Password", Colors.redAccent);
                                //   }
                                // } else {
                                //   Utility.showSnakBar(context, "Wrong Username",
                                //       Colors.redAccent);
                                // }
                              }
                            } else {
                              var password = passwordController.text;
                              var userName =
                                  Hive.box("setting").get('deviceUser');
                              var selectedUser = userBox.get(userName);
                              if (password == selectedUser['password']) {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return MainPage();
                                }));
                              } else {
                                Utility.showSnakBar(context,
                                    "Password ተሳስተዎል፡፡", Colors.redAccent);
                              }
                            }
                          },
                          child: Text("Login"),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                        Visibility(
                          visible: loginStatus,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return OrgProf();
                              }));
                            },
                            // child: Text("Register Your Business",
                            child: Text("አዲስ ነዎት? እባክዎትን ንግድዎትን ይመዝግቡ !",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    decorationStyle: TextDecorationStyle.solid,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.yellow)),
                            style: TextButton.styleFrom(
                                // backgroundColor: Colors.white,
                                // padding: EdgeInsets.all(10),
                                // shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(20))
                                ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigator.of(context)
                            //     .push(MaterialPageRoute(builder: (context) {
                            //   return OrgProf();
                            // }));
                          },
                          // child: Text("Register Your Business",
                          child: Text(" Alewa ለእኔ ሥራ ምን ይጠቅመኛል?",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  decorationStyle: TextDecorationStyle.solid,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.yellow)),
                          style: TextButton.styleFrom(
                              // backgroundColor: Colors.white,
                              // padding: EdgeInsets.all(10),
                              // shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(20))
                              ),
                        ),
                        Divider(
                          color: Colors.white,
                          thickness: 1,
                        ),
                        Text(" Copywrite @ Mount Technology 2021 ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontStyle: FontStyle.italic))
                      ],
                    )),
              ),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(150),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
