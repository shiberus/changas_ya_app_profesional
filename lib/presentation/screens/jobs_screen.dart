import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class JobsScreen extends StatelessWidget {
  static const String name = 'jobs';
  const JobsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Changas Ya')
      ),
      body: Center(
        child: Text("Trabajos Actuales"),
      )
    );
  }
}