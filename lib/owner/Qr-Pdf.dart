import 'dart:math';
import 'package:abushakir/abushakir.dart';
import 'package:boticshop/Utility/Utility.dart';
import 'package:boticshop/Utility/date.dart';
import 'package:boticshop/Utility/style.dart';
import 'package:boticshop/owner/expenesslist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';





class QrPdf extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
 


    // var otherID = watch(otherIDProvider);


    // Box catBox = Hive.box("categorie");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Hive.box("setting").get("orgName"),
          style: Style.style1,
        ),
      ),
    
      body: Container()
     
   
    );
  }
}
