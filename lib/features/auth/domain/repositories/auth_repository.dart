import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/society_role_entity.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> sendOtp(String phoneNumber);
  
  Future<Either<Failure, UserEntity>> verifyOtp(String phoneNumber, String otp);
  
  Future<Either<Failure, UserEntity>> selectSocietyRole(SocietyRoleEntity role);
  
  Future<Either<Failure, UserEntity?>> getCurrentUser();
  
  Future<Either<Failure, void>> logout();
}
