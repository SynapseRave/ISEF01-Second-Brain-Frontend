import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/user/domain/entities/user_data.dart';

abstract interface class UserRepository {
  Future<(UserData?, Failure?)> getUser();

  Future<(UserData?, Failure?)> updateUser({
    String? email,
    String? password,
    String? preferredLlm,
    Map<String, dynamic>? defaultTargets,
  });
}
