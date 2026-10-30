import 'package:equatable/equatable.dart';
import '../../domain/entities/notice_entity.dart';

abstract class NoticeState extends Equatable {
  const NoticeState();

  @override
  List<Object?> get props => [];
}

class NoticeInitialState extends NoticeState {}

class NoticeLoadingState extends NoticeState {}

class NoticePublishingState extends NoticeState {}

class NoticeLoadedState extends NoticeState {
  final List<NoticeEntity> notices;
  final String? successMessage;

  const NoticeLoadedState({
    required this.notices,
    this.successMessage,
  });

  NoticeLoadedState copyWith({
    List<NoticeEntity>? notices,
    String? successMessage,
  }) {
    return NoticeLoadedState(
      notices: notices ?? this.notices,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [notices, successMessage];
}

class NoticeErrorState extends NoticeState {
  final String message;

  const NoticeErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
