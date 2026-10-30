import '../../domain/entities/notice_entity.dart';

class NoticeModel extends NoticeEntity {
  const NoticeModel({
    required super.id,
    required super.title,
    required super.content,
    required super.category,
    super.priority = NoticePriority.normal,
    required super.publishedBy,
    required super.publisherRole,
    required super.publishedAt,
    super.totalRecipients = 40,
    super.sentViaPush = true,
    super.sentViaWhatsapp = true,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: _parseCategory(json['category']),
      priority: _parsePriority(json['priority']),
      publishedBy: json['published_by'] ?? 'Chairman',
      publisherRole: json['publisher_role'] ?? 'Adhyaksha (Chairman)',
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'])
          : DateTime.now(),
      totalRecipients: json['total_recipients'] ?? 40,
      sentViaPush: json['sent_via_push'] ?? true,
      sentViaWhatsapp: json['sent_via_whatsapp'] ?? true,
    );
  }

  static NoticeCategory _parseCategory(dynamic cat) {
    final c = cat?.toString().toLowerCase() ?? '';
    if (c.contains('urgent') || c.contains('alert')) return NoticeCategory.urgentAlert;
    if (c.contains('maint')) return NoticeCategory.maintenance;
    if (c.contains('agm') || c.contains('meet')) return NoticeCategory.meetingAgm;
    if (c.contains('event') || c.contains('fest')) return NoticeCategory.celebrationEvent;
    if (c.contains('water') || c.contains('outage')) return NoticeCategory.waterPowerOutage;
    return NoticeCategory.general;
  }

  static NoticePriority _parsePriority(dynamic prio) {
    final p = prio?.toString().toLowerCase() ?? '';
    if (p.contains('emerg')) return NoticePriority.emergency;
    if (p.contains('high')) return NoticePriority.high;
    return NoticePriority.normal;
  }
}
