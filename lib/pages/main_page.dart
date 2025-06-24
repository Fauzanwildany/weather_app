import 'package:flutter/material.dart';
import 'home_page.dart';
import 'forecast_page.dart';
import 'settings_page.dart';
import '../providers/theme_provider.dart';

class MainPage extends StatefulWidget {
  final bool initialIsFahrenheit;
  const MainPage({super.key, required this.initialIsFahrenheit});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  String _currentCity = "Pamekasan";
  late bool _isFahrenheit;

  @override
  void initState() {
    super.initState();
    _isFahrenheit = widget.initialIsFahrenheit;
  }

  void _onCityChanged(String city) {
    setState(() {
      _currentCity = city;
    });
  }

  void _onUnitChanged(bool value) {
    setState(() {
      _isFahrenheit = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onCityChanged: _onCityChanged, isFahrenheit: _isFahrenheit),
      ForecastPage(city: _currentCity, isFahrenheit: _isFahrenheit),
      SettingsPage(isFahrenheit: _isFahrenheit, onUnitChanged: _onUnitChanged),
    ];

    return ValueListenableBuilder<Color>(
      valueListenable: ThemeProvider.backgroundColor,
      builder: (context, bgColor, _) {
        return Scaffold(
          body: pages[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            backgroundColor: bgColor,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black54,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.cloud),
                label: 'Forecast',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
