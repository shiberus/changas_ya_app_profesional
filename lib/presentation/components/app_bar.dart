import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget{

  CustomAppBar({super.key});

  final appBarColor = Colors.blue[400];
  final String appBarTitle = 'Changas Ya';

  @override
  Widget build(BuildContext context) {
    return AppBar(
          title: Text(appBarTitle),
          backgroundColor: appBarColor,
        );
  }
}