import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  final bool isFahrenheit;
  final Function(bool) onUnitChanged;

  const SettingsPage({
    super.key,
    required this.isFahrenheit,
    required this.onUnitChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _useFahrenheit;

  @override
  void initState() {
    super.initState();
    _useFahrenheit = widget.isFahrenheit;
  }

  void _toggleUnit(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _useFahrenheit = value;
    });
    await prefs.setBool('useFahrenheit', value);
    widget.onUnitChanged(value);
  }

  void _changeColor(Color color) async {
    await ThemeProvider.updateColor(color);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: ThemeProvider.backgroundColor,
      builder: (context, bgColor, _) {
        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            title: const Text('Settings'),
            centerTitle: true,
            backgroundColor: Colors.blue.shade400,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Temperature Unit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SwitchListTile(
                title:
                    Text(_useFahrenheit ? 'Fahrenheit (°F)' : 'Celsius (°C)'),
                value: _useFahrenheit,
                onChanged: _toggleUnit,
                secondary: const Icon(Icons.thermostat),
              ),
              const SizedBox(height: 24),
              const Text(
                'Background Color',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 10,
                children: [
                  ElevatedButton(
                    onPressed: () => _changeColor(Colors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Putih'),
                  ),
                  ElevatedButton(
                    onPressed: () => _changeColor(Colors.blue.shade100),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade100,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Biru'),
                  ),
                  ElevatedButton(
                    onPressed: () => _changeColor(Colors.green.shade100),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade100,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Hijau'),
                  ),
                  ElevatedButton(
                    onPressed: () => _changeColor(Colors.purple.shade100),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade100,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Ungu'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
