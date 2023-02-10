import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _image = "assets/images/quran.jpeg";

  @override
  void initState() {
    Future.delayed(
      Duration(seconds: 3),
      () => Navigator.pushReplacementNamed(context, "/HomeScreen"),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff233143),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            CircleAvatar(
              backgroundImage: AssetImage(_image),
              maxRadius: 100,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Quran",
              style: TextStyle(
                color: Color(0xff4d5d58),
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            Spacer(),
            Text(
              "By  Dev. Mo'men S. El-Abadsa",
              style: TextStyle(
                color: Color(0xffa5904d),
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
