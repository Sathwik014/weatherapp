// 📡 API service to fetch weather data using HTTP requests
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weatherapp/weatherAppProto/widgets/Weather.dart';

class weatherApi {
  static const String _apiKey = '0f31d4d60a7eeea6b265b3d9f787e073';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  // 🌆 Fetch weather by city name
  static Future<WeatherModel?> fetchWeather(String city) async {
    try {
      final url = '$_baseUrl?q=$city&appid=$_apiKey&units=metric';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data); // Parse JSON to WeatherModel
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching weather: $e');
      return null;
    }
  }

  // 📍 Fetch weather by latitude and longitude (used for current location)
  static Future<WeatherModel?> fetchWeatherByCoords(double lat, double lon) async {
    try {
      final url = '$_baseUrl?lat=$lat&lon=$lon&appid=$_apiKey&units=metric';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching weather by coordinates: $e');
      return null;
    }
  }
}