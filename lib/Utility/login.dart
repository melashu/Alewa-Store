import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:boticshop/owner/Home.dart' as owner;
import 'package:boticshop/owner/useraccont.dart';
import 'package:boticshop/sales/Home.dart' as sales;
import 'package:steppers/steppers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class Login extends ConsumerWidget {
  // const RequiredItem({ Key key }) : super(key: key);
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final companyIDController = TextEditingController();
  final userBox = Hive.box('useraccount');

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, watch) {
    var loginStatus = Hive.box("setting").get("isLogBefore") == null;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     Hive.box("setting").get("orgName"),
      //     style: Style.style1,
      //   ),
      // ),
      body: Container(
        color: Colors.amberAccent,
        child: ListView(
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
                  child: Text("Nini Kids Fashion Center",
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontFamily: '',
                          fontSize: 20,
                          fontWeight: FontWeight.bold))),
            ),
            Container(
              width: double.infinity,
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
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2)),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            if (loginStatus) {
                              if (formKey.currentState.validate()) {
                                var userName = userNameController.text;
                                var password = passwordController.text;
                                if (userBox.containsKey(userName)) {
                                  var selectedUser = userBox.get(userName);
                                  if (password == selectedUser['password']) {
                                    var role = selectedUser['role'];
                                    if (role.toString().toLowerCase() ==
                                        'owner') {
                                      Hive.box("setting")
                                          .put("deviceUser", userName);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return owner.Home();
                                      }));
                                    } else if (role.toString().toLowerCase() ==
                                        'sales') {
                                      Hive.box("setting")
                                          .put("deviceUser", userName);
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
                            } else {
                              var password = passwordController.text;
                              var userName =
                                  Hive.box("setting").get('deviceUser');
                              var selectedUser = userBox.get(userName);
                              if (password == selectedUser['password']) {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return owner.Home();
                                }));
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
                          child: OutlinedButton(
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
                        )
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
          ],
        ),
      ),
    );
  }
}
