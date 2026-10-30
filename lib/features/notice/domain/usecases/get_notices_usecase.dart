import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/notice_entity.dart';
import '../repositories/notice_repository.dart';

class GetNoticesUseCase implements UseCase<List<NoticeEntity>, String> {
  final NoticeRepository repository;

  GetNoticesUseCase(this.repository);

  @override
  Future<Either<Failure, List<NoticeEntity>>> call(String societyId) async {
    return await repository.getNotices(societyId: societyId);
  }
}
