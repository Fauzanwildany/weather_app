import 'package:flutter/material.dart';
import '../services/forecast_service.dart';

class ForecastPage extends StatefulWidget {
  const ForecastPage({super.key});

  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  final ForecastService _forecastService = ForecastService();
  List<Map<String, dynamic>> _forecastData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadForecast();
  }

  void _loadForecast() async {
    try {
      final data = await _forecastService.fetchForecast("Jakarta");
      setState(() {
        _forecastData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('5-Day Forecast'), centerTitle: true),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _forecastData.length,
                itemBuilder: (context, index) {
                  final item = _forecastData[index];
                  return ListTile(
                    leading: Image.network(
                      'https://openweathermap.org/img/wn/${item['icon']}@2x.png',
                    ),
                    title: Text(
                      '${item['temp'].toStringAsFixed(1)}°C - ${item['desc']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    subtitle: Text(item['date']),
                  );
                },
              ),
    );
  }
}
