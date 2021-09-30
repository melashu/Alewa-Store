import 'package:flutter/material.dart';

class Index extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
    slivers: [
      SliverAppBar(
        actions: [
          Switch(value: true, onChanged: (val){

          })
        ],
        // title: ,
      )
    ],
    );
  }
}
