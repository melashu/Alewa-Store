import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:boticshop/owner/Home.dart' as owner;
import 'package:boticshop/owner/useraccont.dart';
import 'package:boticshop/sales/Home.dart' as sales;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class Login extends ConsumerWidget {
  // const RequiredItem({ Key key }) : super(key: key);
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final userBox = Hive.box('useraccount');

  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, watch) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     Hive.box("setting").get("orgName"),
      //     style: Style.style1,
      //   ),
      // ),
      body: Container(
        color: Colors.amberAccent,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                // color: Colors.deepPurpleAccent,
                // image: DecorationImage(image: AssetImage("images/login.jpg")),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(150),
                ),
              ),
              child: Center(
                  child: Text("Mount Fashion Center",
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontFamily: '',
                          fontSize: 20,
                          fontWeight: FontWeight.bold))),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 40,
                    right: 10,
                    top: 100,
                  ),
                  child: Form(
                      key: formKey,
                      child: ListView(
                        children: [
                          Padding(
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
                                      borderRadius: BorderRadius.circular(30),
                                      gapPadding: 5,
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 2)),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto),
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
                                  labelStyle: TextStyle(color: Colors.white),
                                  suffixIcon: Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.white,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      gapPadding: 5,
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 2)),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto),
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              if (formKey.currentState.validate()) {
                                var userName = userNameController.text;
                                var password = passwordController.text;
                                if (userBox.containsKey(userName)) {
                                  var selectedUser = userBox.get(userName);
                                  if (password == selectedUser['password']) {
                                    var role = selectedUser['role'];
                                    if (role.toString().toLowerCase() ==
                                        'owner') {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return owner.Home();
                                      }));
                                    } else if (role.toString().toLowerCase() ==
                                        'sales') {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return sales.Home();
                                      }));
                                    }
                                  } else {
                                    Utility.showSnakBar(context,
                                        "Wrong Password", Colors.redAccent);
                                  }
                                } else {
                                  Utility.showSnakBar(context, "Wrong Username",
                                      Colors.redAccent);
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
                          OutlinedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return Useraccount();
                              }));
                            },
                            child: Text("Create Account"),
                            style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                          ),
                        ],
                      )),
                ),
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(150),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
