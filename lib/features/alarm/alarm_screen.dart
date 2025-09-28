import 'package:flutter/material.dart';
import 'alarm_model.dart';
import 'alarm_service.dart';
import 'alarm_list_item.dart';

class AlarmScreen extends StatefulWidget {
  final String location;
  const AlarmScreen({super.key, required this.location});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  List<Alarm> alarms = [];

  @override
  void initState() {
    super.initState();
    AlarmService.init();
  }

  Future<void> addAlarm() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      final alarmTime = DateTime(
        date.year, date.month, date.day, time.hour, time.minute,
      );

      if (alarmTime.isBefore(DateTime.now())) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select future time')),
        );
        return;
      }

      final alarm = Alarm(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        time: alarmTime,
      );

      setState(() => alarms.add(alarm));
      await AlarmService.scheduleNotification(alarm);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Alarm set for ${alarm.formattedTime}')),
      );
    }
  }

  void toggleAlarm(int index) {
    setState(() {
      alarms[index] = alarms[index].copyWith(
        isEnabled: !alarms[index].isEnabled,
      );
    });
  }

  void deleteAlarm(int index) {
    AlarmService.cancelNotification(alarms[index]);
    setState(() => alarms.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarms'),
        backgroundColor: Color(0xFF1a237e),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: AlarmService.testNotification,
          ),
        ],
      ),
      body: Column(
        children: [
          // Location Box
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1a237e).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Color(0xFF1a237e)),
                const SizedBox(width: 10),
                Expanded(child: Text(widget.location)),
              ],
            ),
          ),

          // Add Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: addAlarm,
              icon: const Icon(Icons.add),
              label: const Text('Add Alarm'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1a237e),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Alarms', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),

          // Alarms List
          Expanded(
            child: alarms.isEmpty
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.alarm, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No alarms set yet'),
                ],
              ),
            )
                : ListView.builder(
              itemCount: alarms.length,
              itemBuilder: (context, index) => AlarmListItem(
                alarm: alarms[index],
                onToggle: () => toggleAlarm(index),
                onDelete: () => deleteAlarm(index),
              ),
            ),
          ),
        ],
      ),
    );
  }
}