import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/notice_entity.dart';
import '../../domain/repositories/notice_repository.dart';
import '../datasources/notice_remote_data_source.dart';

class NoticeRepositoryImpl implements NoticeRepository {
  final NoticeRemoteDataSource remoteDataSource;

  NoticeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<NoticeEntity>>> getNotices({
    required String societyId,
  }) async {
    try {
      final list = await remoteDataSource.getNotices(societyId: societyId);
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, NoticeEntity>> publishNotice({
    required String societyId,
    required NoticeEntity notice,
  }) async {
    try {
      final result = await remoteDataSource.publishNotice(
        societyId: societyId,
        notice: notice,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
