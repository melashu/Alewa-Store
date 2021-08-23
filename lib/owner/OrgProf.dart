import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class OrgProf extends ConsumerWidget {
  final setting = Hive.box("setting");

  @override
  Widget build(BuildContext context, watch) {
    return Scaffold(
      appBar: AppBar(
        title: Text(setting.get("orgName")),
      ),
    );
  }
}
