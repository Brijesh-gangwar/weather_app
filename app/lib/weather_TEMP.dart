
import 'package:app/widgets/weather_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:app/const/lin_gradient.dart';
import 'package:app/services/weather_service.dart';
import 'package:app/widgets/city_search_bar.dart';

class Weather1 extends StatefulWidget {
  const Weather1({super.key});

  @override
  State<Weather1> createState() => _Weather1State();
}

class _Weather1State extends State<Weather1> {
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
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text("City Not Found 😕"),
            content: const Text(
              "We couldn't find the weather for that city. Please try again.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
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

  Widget buildWeatherContent(Map<String, dynamic> data) {
    final weather = data['list'][0];
    final tempC = (weather['main']['temp'] - 273.15).toStringAsFixed(1);
    final sky = weather['weather'][0]['main'];

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildCurrentWeatherCard(tempC, sky),
          const SizedBox(height: 20),
          const Text(
            'Hourly Forecast',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          buildHourlyForecast(data),
          const SizedBox(height: 30),
          const Text(
            'Additional Info',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          buildAdditionalInfo(
            humidity: weather['main']['humidity'],
            windSpeed: weather['wind']['speed'],
            pressure: weather['main']['pressure'],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
