// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:app/const/secreats.dart';

// Future<Map<String, dynamic>> getCurrentWeather(String cityName) async {
//   try {
//     final res = await http.get(
//       Uri.parse('http://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey'),
//     );
//     final data = jsonDecode(res.body);
//     if (data['cod'] != "200") throw 'City not found';
//     return data;
//   } catch (e) {
//     throw e.toString();
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/const/secreats.dart';

Future<Map<String, dynamic>> getCurrentWeather(String cityName) async {
  final url = Uri.parse(
    'http://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$openWeatherAPIKey',
  );
  final res = await http.get(url);
  final data = jsonDecode(res.body);
  if (data['cod'] != "200") throw 'City not found';
  return data;
}

Future<Map<String, dynamic>> getWeatherByLocation(
  double lat,
  double lon,
) async {
  final url = Uri.parse(
    'http://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$openWeatherAPIKey',
  );
  final res = await http.get(url);
  final data = jsonDecode(res.body);
  if (data['cod'] != "200") throw 'Location weather fetch failed';
  return data;
}
