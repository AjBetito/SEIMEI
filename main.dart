import 'package:flutter/material.dart';

void main() => runApp(AppB());

class AppB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('App B')),
        body: Center(
          child: Text(
            'App B is running...',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
