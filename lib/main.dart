import 'package:flutter/material.dart';
import 'screens/home_screen.dart';  // Your bottom nav shell
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/auth/login.dart'; // Make sure you import your LoginScreen
import 'theme/theme.dart';         // Custom theme file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;

  void _handleLogin(String email, String password) {
    // TODO: Add real validation/authentication here
    if (email.isNotEmpty && password.isNotEmpty) {
      setState(() {
        isLoggedIn = true;
      });
    } else {
      // Optionally show error
      debugPrint('Email or password cannot be empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Market App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: isLoggedIn
          ? HomeScreen()
          : LoginScreen(
        onLogin: _handleLogin,
      ),
    );
  }
}

