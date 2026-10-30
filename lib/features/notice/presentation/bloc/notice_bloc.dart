import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/notice_entity.dart';
import '../../domain/usecases/get_notices_usecase.dart';
import '../../domain/usecases/publish_notice_usecase.dart';
import 'notice_event.dart';
import 'notice_state.dart';

class NoticeBloc extends Bloc<NoticeEvent, NoticeState> {
  final GetNoticesUseCase getNoticesUseCase;
  final PublishNoticeUseCase publishNoticeUseCase;

  NoticeBloc({
    required this.getNoticesUseCase,
    required this.publishNoticeUseCase,
  }) : super(NoticeInitialState()) {
    on<LoadNoticesEvent>(_onLoadNotices);
    on<PublishNoticeEvent>(_onPublishNotice);
  }

  Future<void> _onLoadNotices(
    LoadNoticesEvent event,
    Emitter<NoticeState> emit,
  ) async {
    emit(NoticeLoadingState());
    final result = await getNoticesUseCase(event.societyId);

    result.fold(
      (failure) => emit(NoticeErrorState(failure.message)),
      (list) => emit(NoticeLoadedState(notices: list)),
    );
  }

  Future<void> _onPublishNotice(
    PublishNoticeEvent event,
    Emitter<NoticeState> emit,
  ) async {
    final currentState = state;
    emit(NoticePublishingState());

    final result = await publishNoticeUseCase(
      PublishNoticeParams(
        societyId: event.societyId,
        notice: event.notice,
      ),
    );

    result.fold(
      (failure) => emit(NoticeErrorState(failure.message)),
      (createdNotice) {
        List<NoticeEntity> existing = [];
        if (currentState is NoticeLoadedState) {
          existing = List.from(currentState.notices);
        }
        existing.insert(0, createdNotice);
        emit(
          NoticeLoadedState(
            notices: existing,
            successMessage:
                'Notice successfully published and broadcast to all 40 flat owners via WhatsApp & Push Notification!',
          ),
        );
      },
    );
  }
}
