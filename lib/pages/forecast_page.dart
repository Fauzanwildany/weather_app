import 'package:flutter/material.dart';
import '../services/forecast_service.dart';
import '../providers/theme_provider.dart';

class ForecastPage extends StatefulWidget {
  final String city;
  final bool isFahrenheit;

  const ForecastPage({
    super.key,
    required this.city,
    required this.isFahrenheit,
  });

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
      final data = await _forecastService.fetchForecast(widget.city);
      setState(() {
        _forecastData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  double _convertTemp(double celsius) {
    return widget.isFahrenheit ? (celsius * 9 / 5 + 32) : celsius;
  }

  String _unitSymbol() => widget.isFahrenheit ? '°F' : '°C';

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: ThemeProvider.backgroundColor,
      builder: (context, bgColor, _) {
        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            title: Text('5-Day Forecast (${widget.city})'),
            centerTitle: true,
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _forecastData.length,
                  itemBuilder: (context, index) {
                    final item = _forecastData[index];
                    final temp = _convertTemp(item['temp']);
                    return ListTile(
                      leading: Image.network(
                        'https://openweathermap.org/img/wn/${item['icon']}@2x.png',
                      ),
                      title: Text(
                        '${temp.toStringAsFixed(1)}${_unitSymbol()} - ${item['desc']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      subtitle: Text(item['date']),
                    );
                  },
                ),
        );
      },
    );
  }
}
