import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  final String apiKey =
      '729db33119e179c070e8decdd79e756c'; // Ganti dengan API key kamu
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather?> fetchWeather(String city) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Weather.fromJson(data);
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
