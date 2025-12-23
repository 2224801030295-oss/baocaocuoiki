import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/statistics_screen.dart';
import '../screens/settings_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;

  final _pages = const [
    HomeScreen(),
    StatisticsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: "Chi tiêu"),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: "Thống kê"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Cài đặt"),
        ],
      ),
    );
  }
}
