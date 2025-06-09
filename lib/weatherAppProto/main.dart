// 📦 Main entry point of the app
import 'package:flutter/material.dart';
import 'package:weatherapp/weatherAppProto/screens/splash.dart';

void main() {
  runApp(WeatherApp());
}

// 🌦️ Root widget of the Weather App
class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',                         // App title
      debugShowCheckedModeBanner: false,           // Removes debug banner
      theme: ThemeData.dark(),                     // Sets dark theme
      home: Splash(),                              // Sets SplashScreen as initial screen
    );
  }
}
