import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:isef01_second_brain_frontend/features/user/data/models/user_data_model.dart';

abstract interface class UserRemoteDatasource {
  Future<UserDataModel> getUser();
  Future<UserDataModel> updateUser(Map<String, dynamic> body);
}

@LazySingleton(as: UserRemoteDatasource)
class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  const UserRemoteDatasourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<UserDataModel> getUser() async {
    final response = await _dio.get<Map<String, dynamic>>('/api/user/');
    return UserDataModel.fromJson(response.data!);
  }

  @override
  Future<UserDataModel> updateUser(Map<String, dynamic> body) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '/api/user/',
      data: body,
    );
    return UserDataModel.fromJson(response.data!);
  }
}
