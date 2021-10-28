import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/date.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// final roleStateProvider = StateProvider((ref) => "Owner");
class UserEdit extends StatefulWidget {
  final Map user;
  UserEdit(this.user);
  @override
  _UserEditState createState() => _UserEditState(this.user);
}

class _UserEditState extends State<UserEdit> {
  Map user;
  _UserEditState(this.user);
  final formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNamrController = TextEditingController();
  final salaryController = TextEditingController();
  final userNameFocus = FocusNode();
  final userBox = Hive.box('useraccount');
  var initRole;
  @override
  void initState() {
    super.initState();
    initRole = user['role'];
    fullNamrController.text = user['fullName'];
    userNameController.text = user['userName'];
    passwordController.text = user['password'];
  }

  @override
  Widget build(BuildContext context) {
    // var initRole = watch(roleStateProvider).state;
    return Scaffold(
        appBar: AppBar(
          title: Utility.getTitle(),
        ),
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
                        "Employee Registeration Form",
                        style: Style.style1,
                        textAlign: TextAlign.center,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0, left: 5),
                    child: Row(
                      children: [
                        Text(
                          "User Account Role",
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
                              DropdownMenuItem(
                                child: Text("Sales"),
                                value: "Sales",
                              ),
                              DropdownMenuItem(
                                child: Text("Encoder"),
                                value: "Encoder",
                              )
                            ],
                            value: initRole,
                            onChanged: (val) {
                              // watch(roleStateProvider).state = val;
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
                          return "Please Enter Full Name";
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      focusNode: userNameFocus,
                      autofocus: true,
                      decoration: InputDecoration(
                          labelText: "Enter Full Name",
                          hintText: 'Like. Samuel Eframe',
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
                          return "Please Enter Username";
                        } else if (userBox.containsKey(val)) {
                          return "Username " + val + " exist";
                        }

                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText: "Enter Username",
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
                          return "Please Enter Password";
                        }
                        return null;
                      },
                      obscureText: true,
                      obscuringCharacter: '*',
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                          labelText: "Enter Password",
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
                      child: Text("Update Account"),
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
                              "action": 'userUpdate'
                            };

                            // if (result == 'ok') {
                            userBox.put(userName, userList);
                            if (userBox.containsKey(userName)) {
                              Utility.successMessage(
                                  context, "Successfuly Updated");
                              // Utility.showSnakBar(context,
                              //     "Successfuly Registred!", Colors.greenAccent);
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
                ],
              )),
        ));
  }
}
