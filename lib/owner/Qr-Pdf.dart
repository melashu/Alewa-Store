import 'package:boticshop/Utility/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class QrPdf extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
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
