import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';


@freezed
class Notification with _$Notification {
  factory Notification({
    required int task_id,
    required String message,
  }) = _Notification;

  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);
}