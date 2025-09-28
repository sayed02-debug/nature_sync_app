import 'package:flutter/material.dart';
import 'alarm_model.dart';
import 'alarm_service.dart';
import 'alarm_list_item.dart';

class AlarmScreen extends StatefulWidget {
  final String userLocation;

  const AlarmScreen({super.key, required this.userLocation});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final List<Alarm> _alarms = [];

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    await AlarmService.initializeNotifications();
  }

  Future<void> _addAlarm() async {
    // First pick a date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate == null) return;

    // Then pick a time
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final alarmDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      if (alarmDateTime.isBefore(DateTime.now())) {
        _showPastTimeError();
        return;
      }

      final newAlarm = Alarm(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        time: alarmDateTime,
        label: 'Nature Alarm',
      );

      setState(() {
        _alarms.add(newAlarm);
      });

      await AlarmService.scheduleAlarmNotification(newAlarm);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Alarm set for ${newAlarm.formattedTime} on ${newAlarm.formattedDate}'),
          backgroundColor: Colors.teal,
        ),
      );
    }
  }

  void _showPastTimeError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select a future time for the alarm'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _toggleAlarm(int index) {
    setState(() {
      _alarms[index] = _alarms[index].copyWith(
        isEnabled: !_alarms[index].isEnabled,
      );
    });

    final alarm = _alarms[index];
    if (alarm.isEnabled) {
      AlarmService.scheduleAlarmNotification(alarm);
    } else {
      AlarmService.cancelAlarmNotification(alarm);
    }
  }

  Future<void> _deleteAlarm(int index) async {
    final alarm = _alarms[index];

    await AlarmService.cancelAlarmNotification(alarm);

    setState(() {
      _alarms.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alarm deleted'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarms'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [

          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.teal.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selected Location',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.userLocation,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // Alarms List Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Alarms',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                // + Button for adding new alarm
                IconButton(
                  onPressed: _addAlarm,
                  icon: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Alarms List
          Expanded(
            child: _alarms.isEmpty
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.alarm, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No alarms set yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap the + button to set your first alarm',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: _alarms.length,
              itemBuilder: (context, index) {
                return AlarmListItem(
                  alarm: _alarms[index],
                  onToggle: () => _toggleAlarm(index),
                  onDelete: () => _deleteAlarm(index),
                );
              },
            ),
          ),
        ],
      ),


      // ),
    );
  }
}