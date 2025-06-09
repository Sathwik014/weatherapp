import 'package:flutter/material.dart';
import 'package:weatherapp/weatherAppProto/screens/weatherPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controller for the text input field
  final TextEditingController _controller = TextEditingController();

  // List of predefined cities with their display names and images
  final List<Map<String, String>> cities = [
    {'name': 'Delhi', 'image': 'assets/images/delhi.jpg'},
    {'name': 'Mumbai', 'image': 'assets/images/mumbai.jpg'},
    {'name': 'Hyderabad', 'image': 'assets/images/hyderabad.jpg'},
    {'name': 'Bengaluru', 'image': 'assets/images/bangalore.jpg'},
  ];

  // Navigates to the weather screen for the given city
  void _navigateToWeather(String city) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WeatherPage(city: city),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with menu icon, title, and weather icon
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {}, // Placeholder for future drawer or menu
        ),
        title: const Text(
          'Weather App',
          style: TextStyle(letterSpacing: 1.5),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(Icons.thunderstorm_outlined),
          ),
        ],
      ),

      // Main body with padding
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Text field to search for a city manually
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Enter your city',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      final value = _controller.text.trim();
                      if (value.isNotEmpty) {
                        _navigateToWeather(value); // Navigate on icon press
                      }
                    },
                  ),
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    _navigateToWeather(value.trim()); // Navigate on enter key
                  }
                },
              ),
            ),

            // Grid view of clickable city cards
            Expanded(
              child: GridView.builder(
                itemCount: cities.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two cards per row
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 3 / 4,
                ),
                itemBuilder: (context, index) {
                  final city = cities[index];

                  return GestureDetector(
                    onTap: () => _navigateToWeather(city['name']!),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          // City image
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child: Image.asset(
                                city['image']!,
                                width: double.infinity,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),

                          // City name text
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              city['name']!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Floating button to fetch weather using user's current location
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.my_location),
        label: const Text("Current Location"),
        onPressed: () => _navigateToWeather("current"),
      ),
    );
  }
}
