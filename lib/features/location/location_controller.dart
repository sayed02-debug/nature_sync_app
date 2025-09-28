import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'location_service.dart';

class LocationController with ChangeNotifier {
  String _location = 'Location not fetched yet';
  bool _isLoading = false;
  String _error = '';

  String get location => _location;
  bool get isLoading => _isLoading;
  bool get hasLocation => _location != 'Location not fetched yet' && _error.isEmpty;

  Future<void> fetchLocation() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _error = 'Location services are disabled. Please enable location services.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _error = 'Location permissions are denied';
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _error = 'Location permissions are permanently denied, we cannot request permissions.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      _location = 'Lat: ${position.latitude.toStringAsFixed(4)}, Lon: ${position.longitude.toStringAsFixed(4)}';
      _error = '';

    } catch (e) {
      _error = 'Failed to get location: ${e.toString()}';
      _location = 'Error fetching location';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}