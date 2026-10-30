import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class SendOtpUseCase implements UseCase<bool, String> {
  final AuthRepository repository;

  SendOtpUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(String phoneNumber) async {
    return await repository.sendOtp(phoneNumber);
  }
}
