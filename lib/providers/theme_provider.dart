import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider {
  static final ValueNotifier<Color> backgroundColor = ValueNotifier<Color>(
    Colors.white,
  );

  static Future<void> loadSavedColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt('bgColor') ?? Colors.white.value;
    backgroundColor.value = Color(colorValue);
  }

  static Future<void> updateColor(Color newColor) async {
    backgroundColor.value = newColor;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('bgColor', newColor.value);
  }
}
