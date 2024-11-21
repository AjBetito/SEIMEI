import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appTitle = 'Drawer Demo';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // Drawer items with corresponding icons
  final List<Map<String, dynamic>> menuItems = [
    {"title": "HOME", "icon": Icons.home},
    {"title": "STATISTICS", "icon": Icons.bar_chart},
    {"title": "GENERAL", "icon": Icons.settings},
    {"title": "SETTINGS", "icon": Icons.tune},
    {"title": "ABOUT US", "icon": Icons.info},
    {"title": "LOGOUT", "icon": Icons.logout},
  ];

  // Body widgets corresponding to each drawer item
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: HOME',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
    Text(
      'Index 1: STATISTICS',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
    Text(
      'Index 2: GENERAL',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
    Text(
      'Index 3: SETTINGS',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
    Text(
      'Index 4: ABOUT US',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
    Text(
      'Index 5: LOGOUT',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close the drawer after selecting an item
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF343A40), // Drawer background color
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Profile Section (Centered)
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "JUAN DE LA CRUZ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white70), // Divider after profile
              // Menu Header
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "MENU",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Menu Items with Icons
              ...menuItems.asMap().entries.map((entry) {
                int index = entry.key;
                String title = entry.value["title"];
                IconData icon = entry.value["icon"];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (index == 2) ...[
                      const SizedBox(height: 10), // Add gap before GENERAL
                      const Divider(color: Colors.white70), // Divider
                    ],
                    ListTile(
                      selected: _selectedIndex == index,
                      selectedTileColor: const Color(0xFF495057), // Highlight color
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      leading: Icon(icon, color: Colors.white),
                      title: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () => _onItemTapped(index),
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
