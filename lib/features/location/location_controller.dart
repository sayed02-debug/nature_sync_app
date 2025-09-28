import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationController with ChangeNotifier {
  String _location = 'Not fetched yet';
  bool _isLoading = false;
  String _error = '';

  String get location => _location;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchLocation() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // Check if location services are enabled
      final isEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isEnabled) {
        _error = 'Location services are disabled. Please enable location services.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Check and request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        _error = 'Location permission permanently denied. Please enable it in app settings.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      if (permission == LocationPermission.denied) {
        _error = 'Location permission denied. Please grant location access.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      // Simulate address (in real app, use geocoding)
      _location = "Lat: ${position.latitude.toStringAsFixed(4)}, Lon: ${position.longitude.toStringAsFixed(4)}";
      _error = '';

    } catch (e) {
      _error = 'Failed to get location: $e';
      _location = 'Error fetching location';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _location = 'Not fetched yet';
    _isLoading = false;
    _error = '';
    notifyListeners();
  }
}