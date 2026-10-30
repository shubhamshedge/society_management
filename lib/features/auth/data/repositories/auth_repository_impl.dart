import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/society_role_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/society_role_model.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, bool>> sendOtp(String phoneNumber) async {
    try {
      final result = await remoteDataSource.sendOtp(phoneNumber);
      return Right(result);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> verifyOtp(
      String phoneNumber, String otp) async {
    try {
      final authResponse = await remoteDataSource.verifyOtp(phoneNumber, otp);
      
      // Cache tokens and user in secure storage
      await localDataSource.saveTokens(
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
      );
      await localDataSource.saveUser(authResponse.user);

      return Right(authResponse.user);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> selectSocietyRole(
      SocietyRoleEntity role) async {
    try {
      final currentUser = await localDataSource.getUser();
      if (currentUser == null) {
        return const Left(AuthFailure(message: 'No active session found'));
      }

      final roleModel = SocietyRoleModel(
        membershipId: role.membershipId,
        societyId: role.societyId,
        societyName: role.societyName,
        wing: role.wing,
        flatNumber: role.flatNumber,
        role: role.role,
        isApproved: role.isApproved,
      );

      final updatedUser = UserModel(
        id: currentUser.id,
        fullName: currentUser.fullName,
        phoneNumber: currentUser.phoneNumber,
        email: currentUser.email,
        avatarUrl: currentUser.avatarUrl,
        societyMemberships: currentUser.societyMemberships,
        activeMembership: roleModel,
      );

      await localDataSource.saveUser(updatedUser);
      await localDataSource.saveActiveRole(roleModel);

      return Right(updatedUser);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to update active role: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await localDataSource.getUser();
      return Right(user);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearAuthData();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
