import '../../helpers/date_time_helper.dart';

class Alarm {
  final String id;
  final DateTime time;
  final String label;
  final bool isEnabled;

  Alarm({
    required this.id,
    required this.time,
    this.label = 'Alarm',
    this.isEnabled = true,
  });


  String get formattedTime => DateTimeHelper.formatTime(time);
  String get formattedDate => DateTimeHelper.formatDate(time);

  Alarm copyWith({
    String? id,
    DateTime? time,
    String? label,
    bool? isEnabled,
  }) {
    return Alarm(
      id: id ?? this.id,
      time: time ?? this.time,
      label: label ?? this.label,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}