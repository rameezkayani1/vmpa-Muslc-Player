import 'dart:async';
import 'package:flutter/material.dart';

import 'introscreen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // ignore: unnecessary_new
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => IntroScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF1D1B29), Color(0xFF4527A0)])
        ),
      
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/logo.png"),
            const Text(
                    "VMPA",
                    style: TextStyle(fontSize: 32.0,  fontWeight:FontWeight.bold,  color: Color((0xFFFFFFFF), ),
                  ),
        )],
        ),
      ),
    );
  }
}
