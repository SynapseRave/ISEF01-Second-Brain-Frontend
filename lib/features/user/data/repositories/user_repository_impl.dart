import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:isef01_second_brain_frontend/core/api/dio_error_mapper.dart';
import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/user/data/datasources/user_remote_datasource.dart';
import 'package:isef01_second_brain_frontend/features/user/domain/entities/user_data.dart';
import 'package:isef01_second_brain_frontend/features/user/domain/repositories/user_repository.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl(this._datasource);

  final UserRemoteDatasource _datasource;

  @override
  Future<(UserData?, Failure?)> getUser() async {
    try {
      final model = await _datasource.getUser();
      return (model.toEntity(), null);
    } on DioException catch (e) {
      return (null, mapDioException(e));
    } catch (_) {
      return (null, const ServerFailure());
    }
  }

  @override
  Future<(UserData?, Failure?)> updateUser({
    String? email,
    String? password,
    String? preferredLlm,
    Map<String, dynamic>? defaultTargets,
  }) async {
    try {
      final body = <String, dynamic>{
        if (email != null) 'email': email,
        if (password != null) 'password': password,
        if (preferredLlm != null) 'preferred_llm': preferredLlm,
        if (defaultTargets != null) 'default_targets': defaultTargets,
      };
      final model = await _datasource.updateUser(body);
      return (model.toEntity(), null);
    } on DioException catch (e) {
      return (null, mapDioException(e));
    } catch (_) {
      return (null, const ServerFailure());
    }
  }
}
