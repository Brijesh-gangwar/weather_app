import 'package:app/widgets/weather_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:app/const/lin_gradient.dart';
import 'package:app/services/weather_service.dart';
import 'package:app/widgets/city_search_bar.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String cityName = 'Ghaziabad';
  Map<String, dynamic>? weatherData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await getCurrentWeather(cityName);
      setState(() {
        weatherData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showCityNotFoundDialog();
    }
  }

  void showCityNotFoundDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color.fromARGB(255, 247, 218, 218),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              "City Not Found 😕",
              style: TextStyle(color: Colors.black),
            ),
            content: const Text(
              "We couldn't find the weather for that city. Please try again.",
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
    );
  }

  void onSearch(String value) async {
    try {
      final data = await getCurrentWeather(value);
      setState(() {
        cityName = value;
        weatherData = data;
      });
    } catch (e) {
      showCityNotFoundDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.1,
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: fetchWeather,
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: backgroundGradient),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
              child: CitySearchBar(currentCity: cityName, onSearch: onSearch),
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  isLoading
                      ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                      : weatherData == null
                      ? const Center(
                        child: Text(
                          "Something went wrong",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                      : buildWeatherContent(weatherData!),
            ),
          ],
        ),
      ),
    );
  }
}
