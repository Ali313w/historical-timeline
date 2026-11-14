import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'providers/event_provider.dart';
import 'theme/app_theme.dart';
import 'screens/timeline_screen.dart';
import 'screens/map_screen.dart';
import 'screens/search_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventProvider()),
      ],
      child: const HistoricalEventsApp(),
    ),
  );
}

class HistoricalEventsApp extends StatelessWidget {
  const HistoricalEventsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'الخط الزمني',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.modernDarkTheme,
      home: const MainScaffold(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const TimelineScreen(),
    const MapScreen(),
    const SearchScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // لضمان ظهور تأثير الشفافية تحت البار
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              backgroundColor: Colors.white.withOpacity(0.05),
              selectedItemColor: AppTheme.accentGold,
              unselectedItemColor: Colors.white30,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              showUnselectedLabels: false,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.auto_stories), label: 'الخط الزمني'),
                BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'الخريطة'),
                BottomNavigationBarItem(icon: Icon(Icons.search_sharp), label: 'البحث'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
