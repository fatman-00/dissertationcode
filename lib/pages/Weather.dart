

import 'package:flutter/material.dart';

import '../utils/WeatherApi.dart';

class Weather extends StatefulWidget {
  const Weather({super.key});
  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  
  late int temperature;
  late String condition;
  late int humidity;
  late String country;
  late String city;
  WeatherModel weatherModel = WeatherModel();
  
  void initState() {
    super.initState();
    getLocationData();
  }
  /// variable weatherData contain response from the API
  /// to fetch data check the response to get the way the data structured
  getLocationData() async {
    var weatherData = await WeatherModel.getLocationWeather();
    setState(() {
      condition = weatherData['weather'][0]['main'];
      humidity = weatherData['main']['humidity'];
      country = weatherData['sys']['country'];
      city = weatherData['name'];
      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Temperature: $temperature°  ',
              style: const TextStyle(
                fontFamily: 'Spartan MB',
                fontSize: 40.0,
              ),
            ),
            Text(
              'condition: $condition  ',
              style: const TextStyle(
                fontFamily: 'Spartan MB',
                fontSize: 40.0,
              ),
            ),
            Text(
              'humidity: $humidity  ',
              style: const TextStyle(
                fontFamily: 'Spartan MB',
                fontSize: 40.0,
              ),
            ),
            Text(
              'Country: $country  ',
              style: const TextStyle(
                fontFamily: 'Spartan MB',
                fontSize: 40.0,
              ),
            ),
            Text(
              'City: $city  ',
              style: const TextStyle(
                fontFamily: 'Spartan MB',
                fontSize: 40.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}