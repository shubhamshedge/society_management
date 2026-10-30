import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpParams extends Equatable {
  final String phoneNumber;
  final String otp;

  const VerifyOtpParams({required this.phoneNumber, required this.otp});

  @override
  List<Object?> get props => [phoneNumber, otp];
}

class VerifyOtpUseCase implements UseCase<UserEntity, VerifyOtpParams> {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(VerifyOtpParams params) async {
    return await repository.verifyOtp(params.phoneNumber, params.otp);
  }
}
