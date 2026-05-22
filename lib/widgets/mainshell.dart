import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/portfolio/portfolio.dart';
import '../screens/home_screen.dart';
import '../screens/stock_detail_screen.dart';

class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // Map index to route path:
  static const tabRoutes = [
    '/dashboard',
    '/portfolio',
    '/settings',
    '/search',
  ];

  void _onTap(int index) {
    if (index == _currentIndex) return;
    _currentIndex = index;
    // Use GoRouter to navigate to the selected tab
    GoRouter.of(context).go(tabRoutes[index]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final location = GoRouter.of(context).location;
    final index = tabRoutes.indexWhere((path) => location.startsWith(path));
    if (index != -1 && index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child, // nested route child (DashboardScreen etc.)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Portfolio'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        ],
      ),
    );
  }
}

extension on GoRouter {
   get location => null;
}
