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
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white), // White text
        ),
        backgroundColor: Color(0xFF343A40), // AppBar background
      ),
      drawer: Drawer(
        backgroundColor: Color(0xFF343A40), // Drawer background
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF343A40), // Drawer header background
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
              title: Text('HOME', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart, color: Colors.white),
              title: Text('STATISTICS', style: TextStyle(color: Colors.white)),
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
              title: Text('SETTINGS', style: TextStyle(color: Colors.white)),
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
              title: Text('ABOUT US', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.white),
              title: Text('LOGOUT', style: TextStyle(color: Colors.white)),
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
            DateTime.now().subtract(Duration(days: 1)), // Last 24 hours
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
              // Calculate total usage time
              int totalSeconds = snapshot.data!
                  .fold(0, (sum, info) => sum + info.usage.inSeconds);
              Duration totalUsage = Duration(seconds: totalSeconds);
              String formattedTotalUsage = formatDuration(totalUsage);

              // Display motivational message
              String motivationalText = '';
              if (totalUsage.inHours >= 10) {
                motivationalText =
                'You could have read a 500-paged book with that time!';
              } else if (totalUsage.inHours >= 5) {
                motivationalText =
                'You could have learned how to solve a Rubik\'s Cube with that time!';
              }

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
                  if (motivationalText.isNotEmpty)
                    Text(
                      motivationalText,
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.redAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
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
      DateTime startDate = endDate.subtract(Duration(days: 1));
      List<AppUsageInfo> infoList =
      await AppUsage().getAppUsage(startDate, endDate);
      infoList.sort((a, b) => b.usage.inSeconds.compareTo(a.usage.inSeconds));
      setState(() => _infos = infoList);
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    return "$hours:$minutes";
  }

  @override
  Widget build(BuildContext context) {
    List<AppUsageInfo> appsToShow = _showAll ? _infos : _infos.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('App Usage Statistics', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF343A40),
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
                setState(() => _showAll = !_showAll);
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

  @override
  void initState() {
    super.initState();
    getAllAppStats();
  }

  void getAllAppStats() async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(Duration(days: 1));
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF343A40),
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
