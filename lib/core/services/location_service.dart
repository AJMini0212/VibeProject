import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();

  Future<LatLng?> getCurrentLocation() async {
    try {
      final serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        final requestServiceResult = await _location.requestService();
        if (!requestServiceResult) {
          return null;
        }
      }

      final permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        final permissionResult = await _location.requestPermission();
        if (permissionResult != PermissionStatus.granted) {
          return null;
        }
      }

      final locationData = await _location.getLocation();
      if (locationData.latitude != null && locationData.longitude != null) {
        return LatLng(locationData.latitude!, locationData.longitude!);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
