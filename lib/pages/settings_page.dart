import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _useCelsius = true;

  @override
  void initState() {
    super.initState();
    _loadPreference();
  }

  void _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _useCelsius = prefs.getBool('useCelsius') ?? true;
    });
  }

  void _toggleUnit(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _useCelsius = value;
    });
    await prefs.setBool('useCelsius', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Temperature Unit',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SwitchListTile(
            title: Text(_useCelsius ? 'Celsius (°C)' : 'Fahrenheit (°F)'),
            value: _useCelsius,
            onChanged: _toggleUnit,
            secondary: const Icon(Icons.thermostat),
          ),
        ],
      ),
    );
  }
}
