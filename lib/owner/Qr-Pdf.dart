import 'package:boticshop/Utility/Utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QrPdf extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    return Scaffold(
        appBar: AppBar(
          title: Utility.getTitle(),
        ),
        body: Container());
  }
}
