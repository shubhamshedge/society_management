import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/notice_entity.dart';

abstract class NoticeRepository {
  Future<Either<Failure, List<NoticeEntity>>> getNotices({
    required String societyId,
  });

  Future<Either<Failure, NoticeEntity>> publishNotice({
    required String societyId,
    required NoticeEntity notice,
  });
}
