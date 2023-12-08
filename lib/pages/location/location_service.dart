import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  Location location = Location();

  Future<bool> checkLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      return true;
    } else {
      var result = await Permission.location.request();
      return result.isGranted;
    }
  }

  Future<Map<String, double>> getLocation() async {
    if (await checkLocationPermission()) {
      try {
        var currentLocation = await location.getLocation();
        return {
          'latitude': currentLocation.latitude ?? 0.0,
          'longitude': currentLocation.longitude ?? 0.0,
        };
      } catch (e) {
        print('Error getting location: $e');
      }
    }
    return {'latitude': 0.0, 'longitude': 0.0};
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      // Permission already granted, proceed with location-related tasks
      print('Location permission already granted');
    } else {
      var result = await Permission.location.request();
      if (result.isGranted) {
        // Permission granted, proceed with location-related tasks
        print('Location permission granted');
      } else {
        // Handle permission denial
        print('Location permission denied');
      }
    }
  }
}
