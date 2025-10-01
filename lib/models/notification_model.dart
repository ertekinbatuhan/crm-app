import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final String title;
  final String subtitle;
  final String avatar;

  const NotificationModel({
    required this.title,
    required this.subtitle,
    required this.avatar,
  });

  @override
  List<Object?> get props => [title, subtitle, avatar];
}
