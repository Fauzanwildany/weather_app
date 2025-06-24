import 'dart:convert';
import 'package:http/http.dart' as http;

class ForecastService {
  final String apiKey = '729db33119e179c070e8decdd79e756c'; // Ganti dengan API key kamu

  Future<List<Map<String, dynamic>>> fetchForecast(String city) async {
    final url =
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Ambil data tiap 8 jam sekali (sekitar 5 hari)
      List<Map<String, dynamic>> forecastList = [];
      for (int i = 0; i < data['list'].length; i += 8) {
        final item = data['list'][i];
        forecastList.add({
          'date': item['dt_txt'],
          'temp': (item['main']['temp'] as num).toDouble(), // ✅ fix
          'desc': item['weather'][0]['description'],
          'icon': item['weather'][0]['icon'],
        });
      }

      return forecastList;
    } else {
      throw Exception('Failed to fetch forecast data');
    }
  }
}
