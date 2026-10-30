import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/maintenance_repository.dart';

class SendPaymentReminderParams extends Equatable {
  final String memberId;
  final String phoneNumber;

  const SendPaymentReminderParams({
    required this.memberId,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [memberId, phoneNumber];
}

class SendPaymentReminderUseCase
    implements UseCase<bool, SendPaymentReminderParams> {
  final MaintenanceRepository repository;

  SendPaymentReminderUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(SendPaymentReminderParams params) async {
    return await repository.sendPaymentReminder(
      memberId: params.memberId,
      phoneNumber: params.phoneNumber,
    );
  }
}
