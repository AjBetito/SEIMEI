import 'package:flutter/material.dart';
import 'package:app_usage/app_usage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Usage Stats'),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        backgroundColor: Color(0xFF343A40), 
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF343A40), 
              ),
              child: Text(
                'Slide bar',
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.white), 
              title: Text(
                'HOME',
                style: TextStyle(color: Colors.white), 
              ),
              onTap: () {
                Navigator.pop(context); 
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart, color: Colors.white), 
              title: Text(
                'STATISTICS',
                style: TextStyle(color: Colors.white), 
              ),
              onTap: () {
                Navigator.pop(context); 
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StatisticsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.white), 
              title: Text(
                'SETTINGS',
                style: TextStyle(color: Colors.white), 
              ),
              onTap: () {
                Navigator.pop(context); 
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: Colors.white), 
              title: Text(
                'ABOUT US',
                style: TextStyle(color: Colors.white), 
              ),
              onTap: () {
                Navigator.pop(context); 
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.white), 
              title: Text(
                'LOGOUT',
                style: TextStyle(color: Colors.white), 
              ),
              onTap: () {
                Navigator.pop(context); 
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: FutureBuilder<List<AppUsageInfo>>(
          future: AppUsage().getAppUsage(
            DateTime.now().subtract(Duration(days: 1)), // cant go more than 1 day
            DateTime.now(),
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No usage data available.');
            } else {
              // Calculate total usage time for the last 24 hours
              int totalSeconds = snapshot.data!
                  .fold(0, (sum, info) => sum + info.usage.inSeconds);
              Duration totalUsage = Duration(seconds: totalSeconds);

              // Format total usage into HH:MM:SS
              String formattedTotalUsage = formatDuration(totalUsage);

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total App Usage Time in the Last 24 Hours:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    formattedTotalUsage,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Update the app usage data 
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    child: Text('Update'),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }
}

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  List<AppUsageInfo> _infos = [];
  bool _showAll = false;

  @override
  void initState() {
    super.initState();
    getUsageStats();
  }

  void getUsageStats() async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(Duration(days: 1)); // Last 24 hours
      List<AppUsageInfo> infoList =
      await AppUsage().getAppUsage(startDate, endDate);

      // Sort apps by usage in descending order
      infoList.sort((a, b) => b.usage.inSeconds.compareTo(a.usage.inSeconds));

      setState(() => _infos = infoList);

      for (var info in infoList) {
        print(info.toString());
      }
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  /// Helper method to format Duration into HH:MM:SS
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    // Determine which apps to display based on _showAll
    List<AppUsageInfo> appsToShow = _showAll ? _infos : _infos.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('App Usage Statistics'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: appsToShow.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(appsToShow[index].appName),
                  trailing: Text(formatDuration(appsToShow[index].usage)),
                );
              },
            ),
          ),
          if (_infos.length > 3) 
            TextButton(
              onPressed: () {
                setState(() {
                  _showAll = !_showAll;
                });
              },
              child: Text(
                _showAll ? 'Collapse' : 'Show All',
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
            ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<AppUsageInfo> _allApps = [];
  List<AppUsageInfo> _removedApps = [];

  @override
  void initState() {
    super.initState();
    getAllAppStats();
  }

  void getAllAppStats() async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(Duration(days: 1)); // Last 24 hours
      List<AppUsageInfo> appStats =
      await AppUsage().getAppUsage(startDate, endDate);

      setState(() {
        _allApps = appStats;
      });
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  void removeApp(AppUsageInfo app) {
    setState(() {
      _allApps.remove(app);
      _removedApps.add(app);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: _allApps.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_allApps[index].appName),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                removeApp(_allApps[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
