import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/date.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:boticshop/https/orgprof.dart';
import 'package:boticshop/owner/useredit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final roleStateProvider = StateProvider((ref) => "Owner");

class Useraccount extends ConsumerWidget {
  final formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNamrController = TextEditingController();
  final salaryController = TextEditingController();
  final userNameFocus = FocusNode();
  final userBox = Hive.box('useraccount');
  // BannerAd bannerAd = Ads().setAd2();
  // bool isSub = Hive.box("setting").get("isSubscribed");
  @override
  Widget build(BuildContext context, watch) {
    var initRole = watch(roleStateProvider).state;
    return Scaffold(
        appBar: AppBar(
          title: Utility.getTitle(),
        ),
        // bottomNavigationBar: bannerAd != null && !isSub
        //     ? Container(
        //         height: bannerAd.size.height.toDouble(),
        //         width: bannerAd.size.width.toDouble(),
        //         child: AdWidget(
        //           ad: bannerAd,
        //         ),
        //       )
        //     : SizedBox(),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
              key: formKey,
              child: ListView(
                children: [
       
                  Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: Colors.deepPurpleAccent)),
                      child: Text(
                        "የስራተኞች መመዝገቢያ ቅጽ",
                        style: Style.style1,
                        textAlign: TextAlign.center,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0, left: 5),
                    child: Row(
                      children: [
                        Text(
                          "የስራ ሀላፊነት",
                          style: Style.style1,
                        ),
                        Spacer(),
                        DropdownButton(
                            dropdownColor: Colors.deepPurple,
                            iconSize: 40,
                            style: Style.dropDouwnStyle,
                            items: [
                              DropdownMenuItem(
                                child: Text("Owner"),
                                value: "Owner",
                              ),
                              // DropdownMenuItem(
                              //   child: Text("Sales"),
                              //   value: "Sales",
                              // ),
                              // DropdownMenuItem(
                              //   child: Text("Encoder"),
                              //   value: "Encoder",
                              // )
                            ],
                            value: initRole,
                            onChanged: (val) {
                              watch(roleStateProvider).state = val;
                            })
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      controller: fullNamrController,
                      onChanged: (val) {
                        // if (formKey.currentState.validate()) {}
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return "እባክዎትን ስም ያስገቡ፡፡";
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      focusNode: userNameFocus,
                      autofocus: true,
                      decoration: InputDecoration(
                          labelText: "ስም ያስገቡ",
                          hintText: 'ም.ሳ Samuel Eframe',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.auto),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(bottom: 12.0),
                  //   child: TextFormField(
                  //     controller: salaryController,
                  //     onChanged: (val) {
                  //       // if (formKey.currentState.validate()) {}
                  //     },
                  //     validator: (val) {
                  //       if (val.isEmpty) {
                  //         return "Please Enter Salary";
                  //       } else if (int.tryParse(val) == null) {
                  //         return "Please Enter Number Only";
                  //       }
                  //       return null;
                  //     },
                  //     textInputAction: TextInputAction.next,
                  //     decoration: InputDecoration(
                  //         labelText: "Enter Salary",
                  //         hintText: 'Like. 2000 Birr',
                  //         border: OutlineInputBorder(),
                  //         floatingLabelBehavior: FloatingLabelBehavior.auto),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      controller: userNameController,
                      onChanged: (val) {},
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Username ያስገቡ";
                        } else if (userBox.containsKey(val)) {
                          return "Username " + val + " exist";
                        }

                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText: "Username ያስገቡ",
                          hintText: 'Like. Mom123',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.auto),
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
                          return "Password ያስገቡ";
                        }
                        return null;
                      },
                      obscureText: true,
                      obscuringCharacter: '*',
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                          labelText: "Password ያስገቡ",
                          hintText: 'Like. abc#123',
                          suffixIcon: Icon(
                            Icons.remove_red_eye,
                            color: Colors.deepPurpleAccent,
                          ),
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.auto),
                    ),
                  ),
                  Divider(
                    color: Colors.deepPurpleAccent,
                    thickness: 1,
                  ),
                  ElevatedButton(
                      child: Text("Create User Account"),
                      onPressed: () async {
                        if (await Utility.isConnection()) {
                          if (formKey.currentState.validate()) {
                            var role = initRole;
                            var fullName = fullNamrController.text;
                            var userName = userNameController.text;
                            var password = passwordController.text;
                            var userList = {
                              'orgId': Hive.box("setting").get("orgId"),
                              "role": role,
                              "fullName": fullName,
                              "usreName": userName,
                              "password": password,
                              "loginStatus": '1',
                              "isActive": '1',
                              "lastLogin": Dates.today,
                              "orgName": Hive.box('setting').get("orgName"),
                              "action": 'userReg'
                            };
                            var result =
                                await OrgProfHttp().insertUserAccount(userList);
                            if (result == 'ok') {
                              userBox.put(userName, userList);
                              if (userBox.containsKey(userName)) {
                                   Hive.box("setting").put("deviceUser", userName);
                                Utility.successMessage(
                                    context, "በትክክል ተመዝግቦል፡፡");
                                // Utility.showSnakBar(context,
                                //     "Successfuly Registred!", Colors.greenAccent);
                              }
                            } else if (result == "error") {
                              Utility.showDangerMessage(context,
                                  "እባክዎትን Username እና Password ይቀይሩ");
                            } else {
                              Utility.showDangerMessage(
                                  context, "ድጋሚ ያስገቡ");
                            }
                          }
                        } else {
                          Utility.showDangerMessage(context,
                              "User Account በሚፈጥሩበት ጊዜ wifi or Data ያስፈልገዉታል፡፡");
                        }
                      },
                      style: Style.elevatedButtonStyle),
                  Divider(
                    color: Colors.deepPurpleAccent,
                    thickness: 1,
                  ),
                  Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: Colors.deepPurpleAccent)),
                      child: Text(
                        "የተመዘገቡ ሰራተኞች ዝርዝር",
                        style: Style.style1,
                        textAlign: TextAlign.center,
                      )),
                  Divider(
                    color: Colors.deepPurpleAccent,
                    thickness: 1,
                  ),
                  ValueListenableBuilder(
                      valueListenable: userBox.listenable(),
                      builder: (context, box, _) {
                        var userList = box.values.toList();
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: userList.length,
                            itemBuilder: (context, index) {
                              return ExpansionTile(
                                title: Text(
                                    "Name: ${userList[index]['fullName']}",
                                    style: Style.style1),
                                // subtitle: Text("የእቃው አይነት ${snapshot.data[index]['brandName']}"),
                                leading: PopupMenuButton(
                                    color: Colors.deepPurple,
                                    initialValue: 0,
                                    onSelected: (i) {
                                      if (i == 0) {
                                        // Utility.editItem(itemMap, context);
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return UserEdit(userList[index]);
                                        }));
                                      } else if (i == 1) {
                                        // _EditItemState().editItem( itemMap,context);
                                        // Utility.showConfirmDialog(
                                        //     context: context,
                                        // itemMap: data[index]);
                                      }
                                    },
                                    itemBuilder: (context) {
                                      return [
                                        PopupMenuItem(
                                            value: 0,
                                            child: Text("Edit",
                                                style: TextStyle(
                                                    color: Colors.white))),
                                        PopupMenuItem(
                                            value: 1,
                                            child: Text("Delete",
                                                style: TextStyle(
                                                    color: Colors.white))),
                                      ];
                                    }),
                                tilePadding: EdgeInsets.only(left: 20),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Full Name: ${userList[index]['fullName']}",
                                            style: Style.style1,
                                          ),
                                          Text(
                                            "Role: ${userList[index]['role']}",
                                            style: Style.style1,
                                          ),
                                          Text(
                                            "Password ${userList[index]['password']}",
                                            style: Style.style1,
                                          ),
                                          Text(
                                            "Username: ${userList[index]['usreName']}",
                                            style: Style.style1,
                                          ),
                                           Text(
                                            "Comapny ID ${userList[index]['orgId']}",
                                            style: Style.style1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            });
                      })
                ],
              )),
        ));
  }
}
