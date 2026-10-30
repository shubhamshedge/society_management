import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/society_role_entity.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SelectSocietyRoleUseCase implements UseCase<UserEntity, SocietyRoleEntity> {
  final AuthRepository repository;

  SelectSocietyRoleUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SocietyRoleEntity role) async {
    return await repository.selectSocietyRole(role);
  }
}
