import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../models/weather_model.dart';
import '../providers/theme_provider.dart';

class HomePage extends StatefulWidget {
  final Function(String) onCityChanged;
  final bool isFahrenheit;

  const HomePage({
    super.key,
    required this.onCityChanged,
    required this.isFahrenheit,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherService _weatherService = WeatherService();
  Weather? _weather;
  bool _isLoading = false;
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchWeather("Pamekasan");
  }

  Future<void> _fetchWeather(String city) async {
    setState(() {
      _isLoading = true;
    });

    try {
      Weather? data = await _weatherService.fetchWeather(city);
      setState(() {
        _weather = data;
      });
      widget.onCityChanged(city);
    } catch (e) {
      setState(() {
        _weather = null;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  double _convertTemp(double celsius) {
    return widget.isFahrenheit ? (celsius * 9 / 5 + 32) : celsius;
  }

  String _unitSymbol() => widget.isFahrenheit ? '°F' : '°C';

  LinearGradient _getWeatherGradient(String description) {
    description = description.toLowerCase();
    if (description.contains('rain')) {
      return const LinearGradient(
        colors: [Colors.grey, Colors.blueGrey],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (description.contains('cloud')) {
      return const LinearGradient(
        colors: [Colors.blueGrey, Colors.white],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (description.contains('clear') || description.contains('sun')) {
      return const LinearGradient(
        colors: [Colors.orangeAccent, Colors.yellowAccent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      return const LinearGradient(
        colors: [Colors.lightBlueAccent, Colors.white],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: ThemeProvider.backgroundColor,
      builder: (context, bgColor, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('WeatherNow'),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.blue.shade400,
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient:
                  _weather != null
                      ? _getWeatherGradient(_weather!.description)
                      : null,
              color: _weather == null ? bgColor : null,
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan nama kota',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          final city = _cityController.text.trim();
                          if (city.isNotEmpty) {
                            _fetchWeather(city);
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_weather != null)
                  Expanded(
                    child: Center(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 6,
                        color: Colors.white.withAlpha(242),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _weather!.cityName,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Image.network(
                                'https://openweathermap.org/img/wn/${_weather!.icon}@4x.png',
                                width: 100,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '${_convertTemp(_weather!.temperature).toStringAsFixed(1)}${_unitSymbol()}',
                                style: const TextStyle(
                                  fontSize: 52,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _weather!.description,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text(
                      'Masukkan nama kota untuk melihat cuaca.',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
