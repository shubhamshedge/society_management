import '../../../../core/network/api_client.dart';
import '../../domain/entities/notice_entity.dart';
import '../models/notice_model.dart';

abstract class NoticeRemoteDataSource {
  Future<List<NoticeModel>> getNotices({required String societyId});

  Future<NoticeModel> publishNotice({
    required String societyId,
    required NoticeEntity notice,
  });
}

class NoticeRemoteDataSourceImpl implements NoticeRemoteDataSource {
  final ApiClient apiClient;

  final List<NoticeModel> _cachedNotices = [
    NoticeModel(
      id: 'not_01',
      title: 'Notice of 14th Annual General Body Meeting (AGM) & Agenda',
      content:
          'All respectable flat owners are cordially invited to attend the 14th AGM on Sunday, 15th November 2026 at 10:30 AM in the Clubhouse. Key agenda items include FY2025-26 Financial Audit sign-off, Rooftop Solar Grid resolution voting, and committee election.',
      category: NoticeCategory.meetingAgm,
      priority: NoticePriority.high,
      publishedBy: 'Rajesh Sharma',
      publisherRole: 'Adhyaksha (Chairman)',
      publishedAt: DateTime(2026, 10, 25, 10, 0),
      totalRecipients: 40,
      sentViaPush: true,
      sentViaWhatsapp: true,
    ),
    NoticeModel(
      id: 'not_02',
      title: 'Scheduled Overhead Water Tank Cleaning & Temporary Outage',
      content:
          'Please note that professional mechanical cleaning and UV sanitization of overhead water tanks for Wing A & Wing B will be conducted on Monday, 2nd November 2026 between 9:00 AM and 2:00 PM. Kindly store sufficient water in advance.',
      category: NoticeCategory.waterPowerOutage,
      priority: NoticePriority.high,
      publishedBy: 'Rajesh Sharma',
      publisherRole: 'Adhyaksha (Chairman)',
      publishedAt: DateTime(2026, 10, 28, 14, 30),
      totalRecipients: 40,
      sentViaPush: true,
      sentViaWhatsapp: true,
    ),
  ];

  NoticeRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<NoticeModel>> getNotices({required String societyId}) async {
    return List.from(_cachedNotices);
  }

  @override
  Future<NoticeModel> publishNotice({
    required String societyId,
    required NoticeEntity notice,
  }) async {
    final model = NoticeModel(
      id: 'not_${DateTime.now().millisecondsSinceEpoch}',
      title: notice.title,
      content: notice.content,
      category: notice.category,
      priority: notice.priority,
      publishedBy: notice.publishedBy,
      publisherRole: notice.publisherRole,
      publishedAt: DateTime.now(),
      totalRecipients: notice.totalRecipients,
      sentViaPush: notice.sentViaPush,
      sentViaWhatsapp: notice.sentViaWhatsapp,
    );

    _cachedNotices.insert(0, model);
    return model;
  }
}
