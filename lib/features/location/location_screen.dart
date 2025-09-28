import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'location_controller.dart';
import '../alarm/alarm_screen.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocationController(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Location Access'),
          backgroundColor: Color(0xFF1a237e),
          foregroundColor: Colors.white,
        ),
        body: const _LocationBody(),
      ),
    );
  }
}

class _LocationBody extends StatelessWidget {
  const _LocationBody();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<LocationController>(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_on, size: 80, color: Color(0xFF1a237e)),
          const SizedBox(height: 20),

          const Text(
            'Enable Location Access',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          const Text(
            'We need your location to sync with nature\'s rhythm in your area',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 40),

          // Location Status Card
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Current Location:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.location,
                    style: TextStyle(
                      color: controller.location != 'Location not fetched yet' ? Color(0xFF1a237e) : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Get Location Button
          if (controller.isLoading)
            const Column(
              children: [
                CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Color(0xFF1a237e))),
                SizedBox(height: 10),
                Text('Fetching your location...'),
              ],
            )
          else
            ElevatedButton(
              onPressed: controller.fetchLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1a237e),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text('Get My Location'),
            ),

          const SizedBox(height: 20),

          // Continue Button
          ElevatedButton(
            onPressed: controller.location != 'Location not fetched yet'
                ? () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => AlarmScreen(location: controller.location),
                ),
              );
            }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.location != 'Location not fetched yet' ? Color(0xFF1a237e) : Colors.grey,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Continue to Alarms'),
          ),
        ],
      ),
    );
  }
}