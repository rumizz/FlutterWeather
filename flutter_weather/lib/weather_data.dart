import 'locations.dart';

class WeatherData {
  Location location;
  num temperature;
  DateTime time;
  int weatherCode;

  WeatherData(this.location, this.temperature, this.time, this.weatherCode);
}
