import 'package:geolocator/geolocator.dart';

class Locations {
  static Future<Position> getCurrentLocation() async {
    // Position currentPosition;
    if (!await Geolocator.isLocationServiceEnabled()) {
      await Geolocator.requestPermission();
      // await Geolocator.openLocationSettings();

    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.openLocationSettings();
    }

    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }
}
