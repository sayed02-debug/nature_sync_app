import '../../helpers/utils.dart';

class Alarm {
  final String id;
  final DateTime time;
  final bool isEnabled;

  Alarm({
    required this.id,
    required this.time,
    this.isEnabled = true,
  });

  String get formattedTime => Utils.formatTime(time);
  String get formattedDate => Utils.formatDate(time);

  Alarm copyWith({bool? isEnabled}) {
    return Alarm(
      id: id,
      time: time,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}