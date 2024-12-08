import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';

void main() {
  runApp(AppUsageTracker());
}

class AppUsageTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UsageStatsPage(),
    );
  }
}

class UsageStatsPage extends StatefulWidget {
  @override
  _UsageStatsPageState createState() => _UsageStatsPageState();
}

class _UsageStatsPageState extends State<UsageStatsPage> {
  Map<String, int> appUsage = {};
  final List<String> targetApps = [
    "com.example.app_b", // Replace with App package name this is just test - naj
    "com.example.app_c",
    "com.example.app_d"
  ];

  @override
  void initState() {
    super.initState();
    _fetchUsageStats();
  }

  Future<void> _fetchUsageStats() async {
    // Check if permission is granted
    bool permissionGranted = await UsageStats.checkUsagePermission();
    if (!permissionGranted) {
      UsageStats.grantUsagePermission();
    }

    // Fetch usage stats
    List<UsageInfo> usage = await UsageStats.queryUsageStats(
      DateTime.now().subtract(Duration(hours: 1)).millisecondsSinceEpoch,
      DateTime.now().millisecondsSinceEpoch,
    );

    setState(() {
      appUsage = {
        for (var info in usage)
          if (targetApps.contains(info.packageName)) info.packageName: info.totalTimeInForeground
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Usage Tracker"),
      ),
      body: appUsage.isEmpty
          ? Center(
        child: Text(
          "No data available or permission not granted.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView(
        children: appUsage.entries.map((entry) {
          String appName = entry.key;
          int usageTime = entry.value ~/ 1000; // Convert ms to seconds
          return ListTile(
            title: Text(appName),
            subtitle: Text("Usage: $usageTime seconds"),
          );
        }).toList(),
      ),
    );
  }
}