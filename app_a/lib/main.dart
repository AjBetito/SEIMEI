import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:seimei/sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SignInScreen(),
    );
  }
}

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to UsageStatsPage on button press
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UsageStatsPage()),
            );
          },
          child: const Text("Go to Usage Stats"),
        ),
      ),
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
    "com.example.app_b", // Replace with App package name
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
        title: const Text("App Usage Tracker"),
      ),
      body: appUsage.isEmpty
          ? const Center(
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
