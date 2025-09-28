import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'location_controller.dart';
import '../../common_widgets/custom_button.dart';
import '../alarm/alarm_screen.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocationController(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Location Access'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        body: const _LocationScreenBody(),
      ),
    );
  }
}

class _LocationScreenBody extends StatelessWidget {
  const _LocationScreenBody();

  @override
  Widget build(BuildContext context) {
    final locationController = Provider.of<LocationController>(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Location Icon
          Icon(
            Icons.location_on,
            size: 80,
            color: Colors.teal.withOpacity(0.7),
          ),
          const SizedBox(height: 20),

          // Title
          const Text(
            'Enable Location Access',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 10),

          // Description
          const Text(
            'We need your location to sync with nature\'s rhythm in your area',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 40),

          // Location Status
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Current Location:',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    locationController.location,
                    style: TextStyle(
                      fontSize: 14,
                      color: locationController.error.isNotEmpty
                          ? Colors.red
                          : Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Error Message
          if (locationController.error.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(
                locationController.error,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),

          const SizedBox(height: 30),

          // Get Location Button
          if (locationController.isLoading)
            const Column(
              children: [
                CircularProgressIndicator(color: Colors.teal),
                SizedBox(height: 10),
                Text('Fetching location...', style: TextStyle(color: Colors.teal)),
              ],
            )
          else
            CustomButton(
              text: 'Get My Location',
              onPressed: locationController.fetchLocation,
            ),

          const SizedBox(height: 20),

          // Continue Button - Updated to pass location data
          CustomButton(
            text: 'Continue to Alarms',
            onPressed: locationController.location != 'Not fetched yet' &&
                locationController.error.isEmpty
                ? () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AlarmScreen(
                    userLocation: locationController.location,
                  ),
                ),
              );
            }
                : null,
          ),
        ],
      ),
    );
  }
}