import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/notice_entity.dart';
import '../repositories/notice_repository.dart';

class PublishNoticeParams extends Equatable {
  final String societyId;
  final NoticeEntity notice;

  const PublishNoticeParams({
    required this.societyId,
    required this.notice,
  });

  @override
  List<Object?> get props => [societyId, notice];
}

class PublishNoticeUseCase
    implements UseCase<NoticeEntity, PublishNoticeParams> {
  final NoticeRepository repository;

  PublishNoticeUseCase(this.repository);

  @override
  Future<Either<Failure, NoticeEntity>> call(PublishNoticeParams params) async {
    return await repository.publishNotice(
      societyId: params.societyId,
      notice: params.notice,
    );
  }
}
