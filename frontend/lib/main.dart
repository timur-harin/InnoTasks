import 'package:flutter/material.dart';
import 'package:frontend/pages/login.dart';
import 'package:frontend/pages/register.dart';
import 'package:frontend/pages/tasks.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool loggedIn;

  @override
  void initState() {
    super.initState();
    loggedIn = false;
    SharedPreferences.getInstance().then((prefs) {
      String? token = prefs.getString('token');
      if (token != null) {
        loggedIn = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task App',
      initialRoute: loggedIn ? '/tasks' : '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/tasks': (context) => const TasksPage(),
      },
    );
  }
}
