import 'package:flutter/material.dart';
import 'package:weatherapp/weatherAppProto/services/weatherApi.dart';
import 'package:weatherapp/weatherAppProto/widgets/Weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  final String city;

  const WeatherPage({required this.city, Key? key}) : super(key: key);

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  WeatherModel? weatherData; // Holds the fetched weather information
  bool isLoading = true;     // Controls loading state
  String? currentCity;       // Stores resolved city name (for current location)

  @override
  void initState() {
    super.initState();

    // If "current" is passed, fetch by geolocation, otherwise by city name
    if (widget.city.toLowerCase() == "current") {
      getCurrentLocationWeather();
    } else {
      fetchWeatherByCity(widget.city);
    }
  }

  /// Fetches weather by city name
  Future<void> fetchWeatherByCity(String city) async {
    final data = await weatherApi.fetchWeather(city);
    setState(() {
      weatherData = data;
      isLoading = false;
      currentCity = city;
    });
  }

  /// Gets current geolocation and then fetches weather based on coordinates
  Future<void> getCurrentLocationWeather() async {
    LocationPermission permission = await Geolocator.requestPermission();

    // If permission is denied, display appropriate message
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        isLoading = false;
        currentCity = "Permission Denied";
      });
      return;
    }

    // Get current position using GPS
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Get city name from coordinates using reverse geocoding
    final placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude);

    final cityName = placemarks.isNotEmpty
        ? placemarks[0].locality ?? "Your Area"
        : "Your Area";

    // Fetch weather for coordinates
    final data = await weatherApi.fetchWeatherByCoords(
        position.latitude, position.longitude);

    setState(() {
      weatherData = data;
      isLoading = false;
      currentCity = cityName;
    });
  }

  /// Chooses a weather animation based on the description
  String getAnimationForWeather(String description) {
    description = description.toLowerCase();
    if (description.contains('cloud') ||
        description.contains('haze') ||
        description.contains('mist')) return 'assets/animations/cloudy.json';
    if (description.contains('rain')) return 'assets/animations/rain.json';
    if (description.contains('sun') ||
        description.contains('clear')) return 'assets/animations/sunny.json';
    if (description.contains('storm') ||
        description.contains('thunder')) return 'assets/animations/storm.json';
    return 'assets/animations/windy.json';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      // App bar shows the resolved city name
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        centerTitle: true,
        title: Text(currentCity ?? widget.city),
      ),

      // Main body content
      body: isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Custom loading animation while fetching weather
            SizedBox(
              width: 180,
              height: 180,
              child: Lottie.asset(
                'assets/animations/loading.json',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Ruko Zara Sabar Karo',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      )

      // If weather data couldn't be loaded
          : weatherData == null
          ? const Center(
        child: Text(
          '❌ Failed to load weather.',
          style: TextStyle(color: Colors.white),
        ),
      )

      // Display weather content
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Weather animation based on description
            SizedBox(
              height: 200,
              child: Lottie.asset(
                getAnimationForWeather(weatherData!.description),
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),

            // Temperature text
            Text(
              '${weatherData!.temperature}°C',
              style: const TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            // Description text (e.g. "clear sky")
            Text(
              weatherData!.description,
              style: const TextStyle(
                fontSize: 26,
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 20),

            // Display humidity and wind side by side
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Humidity
                Column(
                  children: [
                    const Icon(Icons.water_drop, color: Colors.white),
                    const SizedBox(height: 4),
                    Text(
                      '${weatherData!.humidity}%',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Text(
                      'Humidity',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                // Wind Speed
                Column(
                  children: [
                    const Icon(Icons.air, color: Colors.white),
                    const SizedBox(height: 4),
                    Text(
                      '${weatherData!.windSpeed} m/s',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Text(
                      'Wind',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
