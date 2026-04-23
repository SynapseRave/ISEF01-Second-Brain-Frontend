import 'package:injectable/injectable.dart';
import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/user/domain/entities/user_data.dart';
import 'package:isef01_second_brain_frontend/features/user/domain/repositories/user_repository.dart';

@lazySingleton
class GetUserUseCase {
  const GetUserUseCase(this._repository);

  final UserRepository _repository;

  Future<(UserData?, Failure?)> call() => _repository.getUser();
}
