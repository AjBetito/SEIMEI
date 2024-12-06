import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  int _foregroundTime = 0;
  DateTime? _startTime;
  DateTime? _endTime;
  bool _isAppInForeground = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App A is in the foreground, start the timer
      setState(() {
        _isAppInForeground = true;
        _startTime = DateTime.now();
      });
    } else if (state == AppLifecycleState.paused) {
      // App A is in the background, stop the timer
      if (_startTime != null) {
        _endTime = DateTime.now();
        setState(() {
          _foregroundTime += _endTime!.difference(_startTime!).inSeconds;
        });
      }
      setState(() {
        _isAppInForeground = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('App A - Tracker')),
        body: Center(
          child: Text(
            _isAppInForeground
                ? 'App A is in the foreground.\nTime: $_foregroundTime seconds'
                : 'App A is in the background.\nTime: $_foregroundTime seconds',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
