import 'package:flutter/material.dart';

class Bannerwidget extends StatelessWidget {
  
  final String imageAsset;
  final TextStyle titleStyle;
  final String titleToShow;
  
  const Bannerwidget({
    super.key,
    required this.imageAsset,
    required this.titleStyle,
    required this.titleToShow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.all(10.0),
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        color: Colors.blue[400],
        borderRadius: BorderRadius.all(Radius.circular(15.0))
      ),
      child: Column(
        children: [
          Column(
            children: [
            Image.asset(imageAsset,fit: BoxFit.contain, scale: 5.0,),
            SizedBox(height: 5.0,),
            Center(child: Text(titleToShow, style: titleStyle)),
          ]),
        ],
      ),
    );
  }
}