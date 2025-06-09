// 🌤️ Data model for weather information
class WeatherModel {
  final double temperature;     // Temperature in Celsius
  final String description;     // Weather condition description
  final int humidity;           // Humidity percentage
  final double windSpeed;       // Wind speed in m/s

  WeatherModel({
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
  });

  // 🔄 Create model instance from JSON map
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
    );
  }
}
