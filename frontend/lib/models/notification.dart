import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';


@freezed
class Notification with _$Notification {
  factory Notification({
    // ignore: non_constant_identifier_names
    int? task_id,
    String? message,
  }) = _Notification;

  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);
}