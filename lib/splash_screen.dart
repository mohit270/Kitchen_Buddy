import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kitchen_buddy/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => (const Home()),
          ));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xff213A50), Color(0xff071938)]),
          image: DecorationImage(
              isAntiAlias: true,
              fit: BoxFit.fitWidth,
              image: AssetImage("assets/splash.png"))),
      // child: Image.asset("assets/logo/giphy.gif",)
    );
  }
}
