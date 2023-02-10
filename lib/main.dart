import 'package:flutter/material.dart';
import 'package:quran/home_screen.dart';
import 'package:quran/main_screen.dart';
import 'package:quran/second_home_screen.dart';
import 'package:quran/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  void justForFun(){
    print(" Hello World");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/SecondHomeScreen",
      routes: {
        '/SplashScreen': (context) => const SplashScreen(),
        '/HomeScreen': (context) => const HomeScreen(),
        '/MainScreen': (context) => const MainScreen(),
        '/SecondHomeScreen': (context) => const SecondHomeScreen(),
      },
    );
  }
}
