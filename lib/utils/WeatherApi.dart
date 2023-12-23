import 'dart:convert';

import 'package:elderly_people/utils/EmergencyContact.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

/// weather API network helper
/// pass the weatherAPI url
///  to this class to get geographical coordinates
const apiKey = "d3352477c7e8ad7745225a141cc3cc25";

class NetworkData {
  NetworkData(this.url);
  final String url;

  /// get geographical coordinates from open weather API call
  Future getData() async {
    http.Response response = await http.get(Uri.parse(url));//Send  an HTTP GEt request to retrieve content in URL

    if (response.statusCode == 200) {//Success
      String data = response.body;
      return jsonDecode(data);//returns the data in terms of Json Object
    } else {
      print(response.statusCode);//return response code 400(Error) etc...
    }
  }
}

const weatherApiUrl = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {
  static Future<dynamic> getLocationWeather() async {
    /// await for methods that return future
    Position? currentPosition = await EmergencyContact.getCurrentLocation();// getting current location via Geolocator

    /// Get location data
    ///&units=metric change the temperature metric
    NetworkData networkHelper = NetworkData(
        '$weatherApiUrl?lat=${currentPosition?.latitude}&lon=${currentPosition?.longitude}&appid=$apiKey&units=metric');
        //initialise the NetworkHelper with the URL(https://api.openweathermap.org/data/2.5/weather)
        // and as parameter:
        //latitude ,longitude and the API key
    var weatherData = await networkHelper.getData();
    return weatherData;
  }
}
