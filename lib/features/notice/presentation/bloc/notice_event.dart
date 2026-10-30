import 'package:equatable/equatable.dart';
import '../../domain/entities/notice_entity.dart';

abstract class NoticeEvent extends Equatable {
  const NoticeEvent();

  @override
  List<Object?> get props => [];
}

class LoadNoticesEvent extends NoticeEvent {
  final String societyId;

  const LoadNoticesEvent(this.societyId);

  @override
  List<Object?> get props => [societyId];
}

class PublishNoticeEvent extends NoticeEvent {
  final String societyId;
  final NoticeEntity notice;

  const PublishNoticeEvent({
    required this.societyId,
    required this.notice,
  });

  @override
  List<Object?> get props => [societyId, notice];
}
