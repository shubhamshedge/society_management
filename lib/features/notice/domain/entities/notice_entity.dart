import 'package:equatable/equatable.dart';

enum NoticeCategory {
  general,
  urgentAlert,
  maintenance,
  meetingAgm,
  celebrationEvent,
  waterPowerOutage,
}

extension NoticeCategoryExtension on NoticeCategory {
  String get displayName {
    switch (this) {
      case NoticeCategory.general:
        return 'General Circular';
      case NoticeCategory.urgentAlert:
        return 'Urgent Alert';
      case NoticeCategory.maintenance:
        return 'Maintenance & Billing';
      case NoticeCategory.meetingAgm:
        return 'AGM / Society Meeting';
      case NoticeCategory.celebrationEvent:
        return 'Festival & Events';
      case NoticeCategory.waterPowerOutage:
        return 'Utility / Outage Notice';
    }
  }
}

enum NoticePriority { normal, high, emergency }

class NoticeEntity extends Equatable {
  final String id;
  final String title;
  final String content;
  final NoticeCategory category;
  final NoticePriority priority;
  final String publishedBy; // 'Adhyaksha (Rajesh Sharma)'
  final String publisherRole; // 'Chairman / Adhyaksha'
  final DateTime publishedAt;
  final int totalRecipients; // e.g. 40 Owners
  final bool sentViaPush;
  final bool sentViaWhatsapp;

  const NoticeEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.priority = NoticePriority.normal,
    required this.publishedBy,
    required this.publisherRole,
    required this.publishedAt,
    this.totalRecipients = 40,
    this.sentViaPush = true,
    this.sentViaWhatsapp = true,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        category,
        priority,
        publishedBy,
        publisherRole,
        publishedAt,
        totalRecipients,
        sentViaPush,
        sentViaWhatsapp,
      ];
}
