import 'package:flutter/material.dart';
import 'package:weather_sample_app/services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  bool isLoading = true;
  Map<String, dynamic> weatherInfo = {};

  getCurrentWeather({required double lat, required double lng}) async {
    weatherInfo = await WeatherService().getCurrentWeather(lat: lat, lng: lng);
    return weatherInfo;
  }
}
