import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/auth/login.dart';
import '../screens/auth/register.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/home_screen.dart';
import '../screens/stock/stock_search.dart';
import '../screens/stock_detail_screen.dart';  // <-- import stock detail screen
import '../screens/portfolio/portfolio.dart';
import '../screens/news/news_feed_screen.dart';

class AuthNotifier extends ChangeNotifier {
  bool _loggedIn = false;
  bool get isLoggedIn => _loggedIn;

  void login() {
    _loggedIn = true;
    notifyListeners();
  }

  void logout() {
    _loggedIn = false;
    notifyListeners();
  }
}

final authNotifier = AuthNotifier();

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  refreshListenable: authNotifier,
  redirect: (context, state) {
    final loggedIn = authNotifier.isLoggedIn;
    final loggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';

    if (!loggedIn && !loggingIn) {
      return '/login';
    }
    if (loggedIn && loggingIn) {
      return '/';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => LoginScreen(
        onLogin: (email, password) {
          if (email.isNotEmpty && password.isNotEmpty) {
            authNotifier.login();
            appRouter.go('/');
          }
        },
      ),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => RegisterScreen(),
    ),
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => DashboardScreen(),
    ),
    GoRoute(
      path: '/search',
      name: 'stock-search',
      builder: (context, state) => const StockSearchScreen(),
    ),
    GoRoute(
      path: '/stock/:symbol',
      name: 'stock-detail',
      builder: (context, state) {
        final symbol = state.pathParameters['symbol']!;
        return StockDetailScreen(symbol: symbol);
      },
    ),

    GoRoute(
      path: '/portfolio',
      name: 'portfolio',
      builder: (context, state) => PortfolioScreen(),
    ),
    GoRoute(
      path: '/news',
      name: 'news',
      builder: (context, state) => NewsFeedScreen(),
    ),
  ],
);

