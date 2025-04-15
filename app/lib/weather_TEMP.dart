import 'package:app/const/lin_gradient.dart';
import 'package:app/services/weather_service.dart';

import 'package:app/widgets/city_search_bar.dart';
import 'package:flutter/material.dart';

import 'package:app/widgets/hourly_forecast_item.dart';
import 'package:app/widgets/additional_info_item.dart';

import 'dart:ui';
import 'package:intl/intl.dart';

class Weather1 extends StatefulWidget {
  const Weather1({super.key});

  @override
  State<Weather1> createState() => _Weather1State();
}

class _Weather1State extends State<Weather1> {
  String cityName = 'Ghaziabad';

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
            onPressed: () => setState(() {}),
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: backgroundGradient),
        child: RefreshIndicator(
          onRefresh: () async => setState(() {}),
          child: FutureBuilder(
            future: getCurrentWeather(cityName),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    snapshot.error.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }

              final data = snapshot.data!;
              final city = data['city']['name'];
              final weather = data['list'][0];
              final tempC = (weather['main']['temp'] - 273.15).toStringAsFixed(
                1,
              );
              final sky = weather['weather'][0]['main'];

              return Padding(
                padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CitySearchBar(
                        currentCity: city,
                        onSearch: (value) {
                          setState(() {
                            cityName = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),


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

                      SizedBox(height: 30),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildCurrentWeatherCard(String tempC, String sky) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 12,
        color: Colors.white.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
              child: Column(
                children: [
                  Text(
                    '$tempC °C',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Icon(
                    sky == 'Rain' || sky == 'Clouds'
                        ? Icons.cloud
                        : Icons.wb_sunny,
                    size: 70,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    sky,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHourlyForecast(Map<String, dynamic> data) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = data['list'][index + 1];
          final tempC = (item['main']['temp'] - 273.15).toStringAsFixed(1);
          final sky = item['weather'][0]['main'];
          final time = DateFormat.Hm().format(
            DateTime.parse(item['dt_txt']).toLocal(),
          );

          return HourlyForecastItem(
            time: time,
            temperature: '$tempC °C',
            icon:
                (sky == 'Rain' || sky == 'Clouds')
                    ? Icons.cloud
                    : Icons.wb_sunny,
          );
        },
      ),
    );
  }

  Widget buildAdditionalInfo({
    required int humidity,
    required double windSpeed,
    required int pressure,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AdditionalInfoItems(
          icon: Icons.water_drop,
          label: 'Humidity',
          value: '$humidity',
        ),
        AdditionalInfoItems(
          icon: Icons.air,
          label: 'Wind Speed',
          value: windSpeed.toStringAsFixed(1),
        ),
        AdditionalInfoItems(
          icon: Icons.speed,
          label: 'Pressure',
          value: '$pressure',
        ),
      ],
    );
  }
}
