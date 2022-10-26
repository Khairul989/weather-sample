import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  Future<Map<String, dynamic>> getCurrentWeather(
      {required double lat, required double lng}) async {
    String apiKey = dotenv.env['WEATHER_KEY']!;
    final response = await Dio().get(
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lng&appid=$apiKey");
    final data = {
      "weather": response.data["weather"][0]["main"],
      "weather_description": response.data["weather"][0]["description"],
      "state": response.data["name"],
    };
    return data;
  }
}
