import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_page.dart'; // ubah ini

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _goToMainPage();
  }

  Future<void> _goToMainPage() async {
    await Future.delayed(const Duration(seconds: 3)); // delay splash
    final prefs = await SharedPreferences.getInstance();
    final isFahrenheit = prefs.getBool('useFahrenheit') ?? false;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainPage(initialIsFahrenheit: isFahrenheit),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade700,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud, size: 100, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              'Weather App',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            CircularProgressIndicator(color: Colors.white.withOpacity(0.7)),
          ],
        ),
      ),
    );
  }
}
